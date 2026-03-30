extends Node2D

# Load the physical card scene we built previously
const CARD_SCENE = preload("res://card.tscn")

func _ready() -> void:
	var inventory = GameManager.get_ticket_list()
	for card in inventory:
		if GameManager.spawn_list.has(card):
			spawn_card_on_table(card)
	GameManager.spawn_list.clear()

func spawn_card_on_table(ticket_item: CardItem) -> void:
	# Create a physical instance of the card
	var new_card = CARD_SCENE.instantiate()

	# Add it to the game world
	add_child(new_card)

	# Position it in the center of the screen
	var screen_center = get_viewport_rect().size / 2.0
	new_card.global_position = screen_center

	# Pass the data to the card so it updates its textures!
	new_card.setup_ticket(ticket_item)
