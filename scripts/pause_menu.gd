extends Control

signal game_resume

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)

# -1 means off, 1 means on
var muteToggle = -1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("Pause"):
		get_tree().paused = false
		self.hide()
		game_resume.emit()
		set_process(false)

func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://title_screen.tscn")
	GameManager.restart_game()
	set_process(false)

func _on_mute_button_pressed() -> void:
	var audioPlayer = get_tree().get_current_scene().get_child(0)
	if muteToggle == 1:
		$XLabel.visible = true
		audioPlayer.volume_db = -100
	else:
		$XLabel.visible = false
		audioPlayer.volume_db = -5

func _on_mute_button_toggled(toggled_on: bool) -> void:
	muteToggle *= -1
