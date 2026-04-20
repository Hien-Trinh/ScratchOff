extends Node2D
const CARD_SCENE = preload("res://card.tscn")
var tutorial_card

# Called when the node enters the scene tree for the first time.
func _ready():
	tutorial_card = CARD_SCENE.instantiate()
	add_child(tutorial_card)
	var screen_center = get_viewport_rect().size / 2.0
	tutorial_card.global_position = screen_center
	tutorial_card.set_process_input(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	# No input handling?
