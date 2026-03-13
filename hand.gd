extends Sprite2D

var hand_active = true
var open_texture = load("res://assets/hand/pixel_open.png")
var closed_texture = load("res://assets/hand/pixel_grab.png")
var scratch_texture = load("res://assets/hand/pixel_scratch.png")

var default_offset = Vector2(54.0, 249.34)
var scratch_offset = Vector2(115.0, 255.34)

# Called when the node enters the scene tree for the first time.
func _ready():
	self.offset = default_offset

func _process(delta: float) -> void:
	if hand_active == true:
		position = get_global_mouse_position() + offset
		
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				self.texture = closed_texture
			if event.is_released():
				self.texture = open_texture
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_pressed():
				self.texture = scratch_texture
				self.offset = scratch_offset
			if event.is_released():
				self.texture = open_texture
				self.offset = default_offset
