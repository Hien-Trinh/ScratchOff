extends Node
class_name CardItem
# Class for lottery tickets

var item_value : float:
	set = set_item_value, get = get_item_value
	
var item_name : String:
	set = set_item_name, get = get_item_name
	
var item_foil_texture : Texture

func _init(new_name :  String, new_value : float, new_texture : Texture2D):
	item_name = new_name
	item_value = new_value
	item_foil_texture = new_texture

func get_item_value():
	return item_value

func get_item_name():
	return item_name

func set_item_value(new_value):
	item_value = new_value

func set_item_name(new_name):
	item_name = new_name

func _to_string(): # Overriding the default _to_string() method
	return "[br]" + item_name + ", Value: " + str(item_value)
	# Hide value from player in test build
	# [br] is BBCode, signifies a text line break
