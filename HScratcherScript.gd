extends Node2D

#TODO Make collision between Scratchers push them away with icy
#physics. 

var mouseEntered : bool
var mousePos : Vector2 = Vector2.ZERO
var difference : Vector2
var rng = RandomNumberGenerator.new()

func _on_area_2d_mouse_entered() -> void:
	mouseEntered = true

func _on_area_2d_mouse_exited() -> void:
	mouseEntered = false

func _ready() -> void:
	var randX = rng.randf_range(480, 1920)
	var randY = rng.randf_range(0, 1080)
	position = Vector2(randX, randY)

func _process(delta: float) -> void:
	difference = mousePos - get_global_mouse_position()
	
	if Input.is_action_pressed("Click") and mouseEntered and difference != Vector2.ZERO:
		global_position -= difference

	mousePos = get_global_mouse_position()
