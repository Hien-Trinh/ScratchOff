extends Area2D

@export var angle_x_max: float = 7.5
@export var angle_y_max: float = 7.5
@export var max_offset_shadow: float = 40.0

@export_category("Oscillator")
@export var spring: float = 150.0
@export var damp: float = 20.0
@export var velocity_multiplier: float = 2.0

var displacement: float = 0.0
var oscillator_velocity: float = 0.0

var tween_rot: Tween
var tween_hover: Tween
var tween_destroy: Tween
var tween_handle: Tween

var following_mouse: bool = false
var last_pos: Vector2
var velocity: Vector2
var drag_offset: Vector2 = Vector2.ZERO

# Make sure these paths match your new 2D node structure
@onready var card_texture: Sprite2D = $CardSprite
@onready var shadow: Sprite2D = $Shadow
# @onready var collision_shape: CollisionShape2D = $DestroyArea/CollisionShape2D

func _ready() -> void:
	# Convert to radians because lerp_angle is using that
	angle_x_max = deg_to_rad(angle_x_max)
	angle_y_max = deg_to_rad(angle_y_max)
	#collision_shape.set_deferred("disabled", true)

func _process(delta: float) -> void:
	rotate_velocity(delta)
	follow_mouse(delta)
	handle_shadow(delta)
	
#func destroy() -> void:
	#card_texture.use_parent_material = true
	#if tween_destroy and tween_destroy.is_running():
		#tween_destroy.kill()
	#tween_destroy = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	#tween_destroy.tween_property(material, "shader_parameter/dissolve_value", 0.0, 2.0).from(1.0)
	#tween_destroy.parallel().tween_property(shadow, "self_modulate:a", 0.0, 1.0)

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

func follow_mouse(_delta: float) -> void:
	if not following_mouse: return
	# Using drag_offset prevents snapping the card's exact center to the cursor
	global_position = get_global_mouse_position() + drag_offset

# This built-in function fires when the mouse interacts with the Area2D's CollisionShape
func _input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	# 1. Handle Mouse Click (Start Dragging)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			following_mouse = true
			# Grab the offset so we drag from where we clicked, not the center
			drag_offset = global_position - get_global_mouse_position()
			
	# 2. Handle Shader Rotation on Hover
	if following_mouse: return
	if not event is InputEventMouseMotion: return
	
	var mouse_pos: Vector2 = get_local_mouse_position()
	var size = card_texture.texture.get_size() * card_texture.scale
	
	# Because Sprite2Ds are centered, local coords go from -size/2 to +size/2
	# We remap these values back to 0 -> 1 for the shader math
	var lerp_val_x: float = remap(mouse_pos.x, -size.x / 2.0, size.x / 2.0, 0.0, 1.0)
	var lerp_val_y: float = remap(mouse_pos.y, -size.y / 2.0, size.y / 2.0, 0.0, 1.0)

	# Clamp just in case the mouse moves slightly outside bounds before triggering mouse_exited
	lerp_val_x = clamp(lerp_val_x, 0.0, 1.0)
	lerp_val_y = clamp(lerp_val_y, 0.0, 1.0)

	var rot_x: float = rad_to_deg(lerp_angle(-angle_x_max, angle_x_max, lerp_val_x))
	var rot_y: float = rad_to_deg(lerp_angle(angle_y_max, -angle_y_max, lerp_val_y))
	
	card_texture.material.set_shader_parameter("x_rot", rot_y)
	card_texture.material.set_shader_parameter("y_rot", rot_x)

# --- GLOBAL INPUT ---
# We use global input to detect the drop. If the user moves the mouse wildly, 
# it might leave the collision shape before they release the click.
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.is_pressed() and following_mouse:
			# Drop card
			following_mouse = false
			#collision_shape.set_deferred("disabled", false)
			if tween_handle and tween_handle.is_running():
				tween_handle.kill()
			tween_handle = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
			tween_handle.tween_property(self , "rotation", 0.0, 0.3)

# Connect this via the Godot Node Editor signals -> Area2D.mouse_entered
func _on_mouse_entered() -> void:
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(self , "scale", Vector2(1.2, 1.2), 0.5)

# Connect this via the Godot Node Editor signals -> Area2D.mouse_exited
func _on_mouse_exited() -> void:
	# Reset rotation
	if tween_rot and tween_rot.is_running():
		tween_rot.kill()
	tween_rot = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel(true)
	tween_rot.tween_property(card_texture.material, "shader_parameter/x_rot", 0.0, 0.5)
	tween_rot.tween_property(card_texture.material, "shader_parameter/y_rot", 0.0, 0.5)
	
	# Reset scale
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(self , "scale", Vector2.ONE, 0.55)
