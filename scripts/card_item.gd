# Class for lottery tickets
extends RefCounted # 
class_name CardItem

var card_id: String
var card_name: String
var card_value: float
var card_cost: float

var foil_texture: Texture2D
var reward_texture: Texture2D

var is_scratched: bool = false

func _init(id: String, new_name: String, value: float, cost: float, foil: Texture2D, reward: Texture2D):
	card_id = id
	card_name = new_name
	card_value = value
	card_cost = cost
	foil_texture = foil
	reward_texture = reward

func _to_string(): # Overriding the default _to_string() method
	return "[br]" + card_name + ", Value: " + str(card_value)
	# Hide value from player in test build
	# [br] is BBCode, signifies a text line break
