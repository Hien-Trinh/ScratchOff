extends Node2D

var mouseEntered : bool
var mousePos : Vector2 = Vector2.ZERO
var difference : Vector2

func _on_area_2d_mouse_entered() -> void:
	mouseEntered = true

func _on_area_2d_mouse_exited() -> void:
	mouseEntered = false

func _process(delta: float) -> void:
	difference = mousePos - get_global_mouse_position()
	
	if Input.is_action_pressed("Click") and mouseEntered and difference != Vector2.ZERO:
		global_position -= difference

	mousePos = get_global_mouse_position()
