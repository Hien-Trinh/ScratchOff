extends Sprite2D

const CardClass = preload("res://scripts/card.gd")

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
		var is_hovering = CardClass.hovered_cards > 0
		
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			if is_hovering:
				self.texture = scratch_texture
				self.offset = scratch_offset
			else:
				self.texture = open_texture
				self.offset = default_offset
		elif Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if is_hovering:
				self.texture = closed_texture
				self.offset = default_offset
			else:
				self.texture = open_texture
				self.offset = default_offset
		else:
			self.texture = open_texture
			self.offset = default_offset
			
		position = get_global_mouse_position() + offset
