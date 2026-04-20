extends Button

func _on_button_pressed() -> void:
	GameManager.game_started = false
	get_tree().change_scene_to_file("res://game_view.tscn")
