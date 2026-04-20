extends Node2D
const CARD_SCENE = preload("res://card.tscn")
@onready var tutorial_card = $Card
@onready var button = $Button

# Called when the node enters the scene tree for the first time.
func _ready():
	var card_data = GameManager.generate_ticket("LotsOfMoney")
	tutorial_card.setup_ticket(card_data)
	GameManager.game_started = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if tutorial_card.card_data.is_scratched and not button.visible:
		button.visible = true
