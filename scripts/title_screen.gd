extends Control

@onready var start_button = $TextureRect2/StartButton
@onready var credits_button = $TextureRect2/StartButton
@onready var credits_window = $CreditsWindow

# Called when the node enters the scene tree for the first time.
func _ready():
	credits_window.visible = false

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://tutorial.tscn")

func _on_exit_credit_window_pressed():
	if(credits_window.visible == true):
		credits_window.visible = false

func _on_credits_button_pressed():
	if(credits_window.visible == false):
		credits_window.visible = true
