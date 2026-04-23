extends Control

signal game_resume
# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("Pause"):
		get_tree().paused = false
		self.hide()
		game_resume.emit()
		set_process(false)

func _on_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://title_screen.tscn")
	GameManager.restart_game()
	set_process(false)
