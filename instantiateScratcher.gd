extends Button

@export var scratcherScene : PackedScene

func _on_pressed() -> void:
	var new_scratcher = scratcherScene.instantiate()
	add_child(new_scratcher)
