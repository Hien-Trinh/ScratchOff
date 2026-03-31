extends Control

@onready var color_rect = $ColorRect

func _ready():
	animate_background()
	
func animate_background():
	var tween = get_tree().create_tween().set_loops()
	tween.tween_method(set_bg_hue, 0.0, 1.0, 10.0)

func set_bg_hue(hue: float):
	color_rect.modulate = Color.from_hsv(hue, 1.0, 1.0)
	
