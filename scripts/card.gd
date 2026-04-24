extends RigidBody2D

var card_data: CardItem

@export var angle_x_max: float = 7.5
@export var angle_y_max: float = 7.5
@export var max_offset_shadow: float = 40.0

@export var spring: float = 25.0 # How fast the card 'spring' to the mouse drag
@export var tilt_strength: float = 0.001
@export var tilt_angle_range_radians: float = 0.7
@export var angular_velocity_multiplier: float = 15.0
@export var velocity_multiplier: float = 2.0

# Only one active card at a time
static var active_card: RigidBody2D = null
static var hovered_cards: int = 0

var tween_rot: Tween
var tween_hover: Tween
var tween_destroy: Tween
var tween_handle: Tween

var following_mouse: bool = false
var is_scratching: bool = false
var is_hovered: bool = false
var drag_offset: Vector2 = Vector2.ZERO

# Make sure these paths match your 2D node structure
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var shadow: Sprite2D = $Shadow
@onready var card_display: Sprite2D = $CardDisplay
@onready var eraser_mask: Node2D = $MaskViewport/ScratchBounds/EraserMask
@onready var foil_dust: CPUParticles2D = $FoilDust
@onready var celebrate_dust: CPUParticles2D = $CelebrateDust
@onready var card_size := Vector2($MainViewport.size) * card_display.scale

@onready var foil_sprite: Sprite2D = $MainViewport/FoilSprite
@onready var reward_sprite: Sprite2D = $MainViewport/RewardSprite

# Scratch math
var grid_cell_size: int = 8
var grid_cols: int = 16 # 128 width / 8
var grid_rows: int = 8  # 64 height / 8
var total_cells: int = grid_cols * grid_rows # 128 total squares
var scratched_grid: Array[bool] = []
var scratched_cells: int = 0
var card_revealed: bool = false
var last_scratch_pos := Vector2(-9999, -9999)
const scratchable_area_offset := Vector2(26.0, 82.0)
const scratch_success_threshold: float = 0.80

func _ready() -> void:
	# Convert to radians because lerp_angle is using that
	angle_x_max = deg_to_rad(angle_x_max)
	angle_y_max = deg_to_rad(angle_y_max)
	
	# Create our 128-cell grid and set them all to 'false' (unscratched)
	scratched_grid.resize(total_cells)
	scratched_grid.fill(false)

	# Viewport setup in case the editor crashes out
	# Give the main card display the feed from the MainViewport
	card_display.texture = $MainViewport.get_texture()

	# Duplicate the material after assigning the texture so it doesn't break
	card_display.material = card_display.material.duplicate()

	# Ensure the Foil has its own unique material instance
	foil_sprite.material = foil_sprite.material.duplicate() 
	foil_sprite.material.set_shader_parameter("mask_texture", $MaskViewport.get_texture())
	

func _physics_process(_delta: float) -> void:
	if following_mouse:
		# Pull toward mouse
		var target_pos = get_global_mouse_position() + drag_offset
		var direction = target_pos - global_position
		
		# Set velocity to move towards the target.
		linear_velocity = direction * spring
		
		# Tilt based on movement speed
		var target_tilt = clamp(linear_velocity.x * tilt_strength, -tilt_angle_range_radians, tilt_angle_range_radians)
		angular_velocity = (target_tilt - rotation) * angular_velocity_multiplier
	else:
		# Return to upright when dropped
		angular_velocity = (0.0 - rotation) * angular_velocity_multiplier
		
	handle_shadow(_delta)

func handle_shadow(_delta: float) -> void:
	# Y position is never changed.
	# Only x changes depending on how far we are from the center of the screen
	var center: Vector2 = get_viewport_rect().size / 2.0
	var distance: float = global_position.x - center.x

	shadow.position.x = lerp(0.0, -sign(distance) * max_offset_shadow, abs(distance / (center.x)))

# This built-in function fires when the mouse interacts with the Area2D's CollisionShape
func _input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	# If the game is not started, do not allow inputs
	if not GameManager.game_started:
		return
	# Handle Mouse Click (Start Dragging)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			# If another card is currently active, ignore this event.
			if active_card != null and active_card != self: return 
			active_card = self

			following_mouse = true
			drag_offset = global_position - get_global_mouse_position()

	# Right Click: Start Scratching
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.is_pressed():
			if active_card != null and active_card != self: return 
			active_card = self

			is_scratching = true
			last_scratch_pos = Vector2(-9999, -9999)
			_send_scratch_point()
			foil_dust.global_position = get_global_mouse_position()
			foil_dust.emitting = true

	# Handle Shader Rotation on Hover
	if following_mouse: return
	if not event is InputEventMouseMotion: return
	
	var mouse_pos: Vector2 = get_local_mouse_position()
	
	# Because Sprite2Ds are centered, local coords go from -card_size/2 to +card_size/2
	# We remap these values back to 0 -> 1 for the shader math
	var lerp_val_x: float = remap(mouse_pos.x, -card_size.x / 2.0, card_size.x / 2.0, 0.0, 1.0)
	var lerp_val_y: float = remap(mouse_pos.y, -card_size.y / 2.0, card_size.y / 2.0, 0.0, 1.0)

	# Clamp just in case the mouse moves slightly outside bounds before triggering mouse_exited
	lerp_val_x = clamp(lerp_val_x, 0.0, 1.0)
	lerp_val_y = clamp(lerp_val_y, 0.0, 1.0)

	var rot_x: float = rad_to_deg(lerp_angle(-angle_x_max, angle_x_max, lerp_val_x))
	var rot_y: float = rad_to_deg(lerp_angle(angle_y_max, -angle_y_max, lerp_val_y))

	card_display.material.set_shader_parameter("x_rot", rot_y)
	card_display.material.set_shader_parameter("y_rot", rot_x)

# --- GLOBAL INPUT ---
# We use global input to detect the drop. If the user moves the mouse wildly, 
# it might leave the collision shape before they release the click.
func _input(event: InputEvent) -> void:
	# If the game is not started, do not allow inputs
	if not GameManager.game_started:
		return
	# If a card is being dragged/scratched, and it's not this one, ignore the mouse completely
	if active_card != null and active_card != self: return

	# Release Left Click (Drop)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.is_pressed() and following_mouse:
			following_mouse = false
			active_card = null

	# Handle Scratch Dragging
	if event is InputEventMouseMotion and is_scratching:
		_send_scratch_point()
		foil_dust.global_position = get_global_mouse_position()

	# Release Right Click (Stop Scratching)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if not event.is_pressed():
			is_scratching = false
			last_scratch_pos = Vector2(-9999, -9999)
			eraser_mask.break_line()
			foil_dust.emitting = false
			active_card = null

# Connect this via the Godot Node Editor signals -> Area2D.mouse_entered
func _on_mouse_entered() -> void:
	if not is_hovered:
		is_hovered = true
		hovered_cards += 1
	# If the game is not started, do not allow inputs
	if not GameManager.game_started:
		return
	# Don't hover if the player is currently dragging/scratching a card
	if active_card != null: return

	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC).set_parallel(true)
	tween_hover.tween_property(card_display, "scale", Vector2(1.2, 1.2), 0.5)
	tween_hover.tween_property(shadow, "scale", Vector2(1.2, 1.2), 0.5)

# Connect this via the Godot Node Editor signals -> Area2D.mouse_exited
func _on_mouse_exited() -> void:
	if is_hovered:
		is_hovered = false
		hovered_cards -= 1
	# If the game is not started, do not allow inputs
	if not GameManager.game_started:
		return
	# Reset rotation
	if tween_rot and tween_rot.is_running():
		tween_rot.kill()
	tween_rot = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel(true)
	tween_rot.tween_property(card_display.material, "shader_parameter/x_rot", 0.0, 0.5)
	tween_rot.tween_property(card_display.material, "shader_parameter/y_rot", 0.0, 0.5)

	# Reset scale
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC).set_parallel(true)
	tween_hover.tween_property(card_display, "scale", Vector2.ONE, 0.55)
	tween_hover.tween_property(shadow, "scale", Vector2.ONE, 0.55)

func _send_scratch_point() -> void:
	# Maps the centered physics coordinates to the top-left Viewport coordinates
	var local_pos = get_local_mouse_position()
	var viewport_pos = local_pos + (card_size / 2.0)
	var mask_local_pos = viewport_pos - scratchable_area_offset
	eraser_mask.add_scratch_point(mask_local_pos)
	_update_scratch_grid(mask_local_pos)

func _update_scratch_grid(mask_local_pos: Vector2) -> void:
	if card_revealed: return # Stop doing math if they already won!

	var brush_radius: float = eraser_mask.brush_size / 2.0

	# Interpolation for teleporting mouse between frames
	if last_scratch_pos == Vector2(-9999, -9999):
		last_scratch_pos = mask_local_pos

	var teleportation_distance = last_scratch_pos.distance_to(mask_local_pos)
	var step_number = teleportation_distance / brush_radius

	for i in range(step_number + 1):
		var t = float(i) / float(step_number)
		var current_pos = last_scratch_pos.lerp(mask_local_pos, t)

		# Find the grid columns/rows for THIS specific step along the line
		var min_col = max(0, int((current_pos.x - brush_radius) / grid_cell_size))
		var max_col = min(grid_cols - 1, int((current_pos.x + brush_radius) / grid_cell_size))
		var min_row = max(0, int((current_pos.y - brush_radius) / grid_cell_size))
		var max_row = min(grid_rows - 1, int((current_pos.y + brush_radius) / grid_cell_size))

		for col in range(min_col, max_col + 1):
			for row in range(min_row, max_row + 1):
				var index = row * grid_cols + col
				if not scratched_grid[index]:
					var cell_center = Vector2(col * grid_cell_size + (grid_cell_size / 2.0), row * grid_cell_size + (grid_cell_size / 2.0))

					# Check the distance from the interpolated step point
					if current_pos.distance_to(cell_center) <= brush_radius:
						scratched_grid[index] = true
						scratched_cells += 1

	# Calculate percentage
	var percentage = float(scratched_cells) / float(total_cells)
	if percentage >= scratch_success_threshold:
		card_revealed = true
		# TODO (done?): send signal that card is revealed
		card_data.is_scratched = true
		
		# Scratch complete exlposion
		celebrate_dust.visible = false 

		for i in range(5):
			var new_dust = celebrate_dust.duplicate()
			add_child(new_dust)
			new_dust.visible = true
			
			var celebrate_explosion_offset = Vector2(randf_range(-90, 90), randf_range(-90, 90))
			new_dust.global_position = self.global_position + celebrate_explosion_offset
			
			new_dust.emitting = true
			new_dust.restart()
			
			new_dust.finished.connect(new_dust.queue_free)

# Call this immediately after spawning the card!
func setup_ticket(data: CardItem) -> void:
	card_data = data

	# Apply the textures from the data class to the physical Viewport sprites
	if card_data.foil_texture:
		foil_sprite.texture = card_data.foil_texture

	if card_data.reward_texture:
		reward_sprite.texture = card_data.reward_texture

	# TODO (not needed i think): card_data.item_value logic here maybe...

func _exit_tree() -> void:
	if is_hovered:
		is_hovered = false
		hovered_cards -= 1
