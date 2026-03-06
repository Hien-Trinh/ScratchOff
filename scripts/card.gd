extends Area2D

@export var angle_x_max: float = 7.5
@export var angle_y_max: float = 7.5
@export var max_offset_shadow: float = 40.0

@export_category("Oscillator")
@export var spring: float = 150.0
@export var damp: float = 20.0
@export var velocity_multiplier: float = 2.0

# Only one active card at a time
static var active_card: Area2D = null

var displacement: float = 0.0
var oscillator_velocity: float = 0.0

var tween_rot: Tween
var tween_hover: Tween
var tween_destroy: Tween
var tween_handle: Tween

var following_mouse: bool = false
var is_scratching: bool = false
var last_pos: Vector2
var velocity: Vector2
var drag_offset: Vector2 = Vector2.ZERO

# Make sure these paths match your new 2D node structure
@onready var shadow: Sprite2D = $Shadow
@onready var card_display: Sprite2D = $CardDisplay
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var eraser_mask: Node2D = $MaskViewport/ScratchBounds/EraserMask
@onready var card_size: Vector2 = Vector2($MainViewport.size) * card_display.scale

func _ready() -> void:
	# Convert to radians because lerp_angle is using that
	angle_x_max = deg_to_rad(angle_x_max)
	angle_y_max = deg_to_rad(angle_y_max)
	#collision_shape.set_deferred("disabled", true)

func _process(delta: float) -> void:
	rotate_velocity(delta)
	handle_shadow(delta)

func rotate_velocity(delta: float) -> void:
	if not following_mouse: return

	# Compute the velocity
	velocity = (position - last_pos) / delta
	last_pos = position

	oscillator_velocity += velocity.normalized().x * velocity_multiplier

	# Oscillator stuff
	var force = - spring * displacement - damp * oscillator_velocity
	oscillator_velocity += force * delta
	displacement += oscillator_velocity * delta

	rotation = displacement

func handle_shadow(_delta: float) -> void:
	# Y position is never changed.
	# Only x changes depending on how far we are from the center of the screen
	var center: Vector2 = get_viewport_rect().size / 2.0
	var distance: float = global_position.x - center.x

	shadow.position.x = lerp(0.0, -sign(distance) * max_offset_shadow, abs(distance / (center.x)))

# This built-in function fires when the mouse interacts with the Area2D's CollisionShape
func _input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	# If another card is currently active, ignore this event.
	if active_card != null and active_card != self: return 
	active_card = self

	# Handle Mouse Click (Start Dragging)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			following_mouse = true
			# Grab the offset so we drag from where we clicked, not the center
			drag_offset = global_position - get_global_mouse_position()

	# Right Click: Start Scratching
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.is_pressed():
			is_scratching = true
			_send_scratch_point()

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
	# If a card is being dragged/scratched, and it's not this one, ignore the mouse completely
	if active_card != null and active_card != self: return

	# Using drag_offset prevents snapping the card's exact center to the cursor
	if event is InputEventMouseMotion and following_mouse:
		global_position = get_global_mouse_position() + drag_offset

	# Release Left Click (Drop)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.is_pressed() and following_mouse:
			# Drop card
			following_mouse = false
			if tween_handle and tween_handle.is_running():
				tween_handle.kill()
			tween_handle = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
			tween_handle.tween_property(self , "rotation", 0.0, 0.3)

	# Handle Scratch Dragging
	if event is InputEventMouseMotion and is_scratching:
		_send_scratch_point()

	# Release Right Click (Stop Scratching)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if not event.is_pressed():
			is_scratching = false
			eraser_mask.break_line()

# Connect this via the Godot Node Editor signals -> Area2D.mouse_entered
func _on_mouse_entered() -> void:
	# Don't hover if the player is currently dragging/scratching a card
	if active_card != null: return

	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(self , "scale", Vector2(1.2, 1.2), 0.5)

# Connect this via the Godot Node Editor signals -> Area2D.mouse_exited
func _on_mouse_exited() -> void:
	# Only give up the lock if this card is the one holding it
	if active_card == self:
		active_card = null

	# Reset rotation
	if tween_rot and tween_rot.is_running():
		tween_rot.kill()
	tween_rot = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel(true)
	tween_rot.tween_property(card_display.material, "shader_parameter/x_rot", 0.0, 0.5)
	tween_rot.tween_property(card_display.material, "shader_parameter/y_rot", 0.0, 0.5)

	# Reset scale
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(self , "scale", Vector2.ONE, 0.55)

func _send_scratch_point() -> void:
	# Maps the centered physics coordinates to the top-left Viewport coordinates
	var local_pos = get_local_mouse_position()
	var viewport_pos = local_pos + (card_size / 2.0)
	eraser_mask.add_scratch_point(viewport_pos)
