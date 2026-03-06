extends Node
class_name Item
# Class for lottery tickets

var item_value : float:
	set = set_value, get = get_value
	
var item_name : String:
	set = set_item_name, get = get_item_name
	
var item_texture : Texture

func _init(new_name :  String, new_value : float, new_texture : Texture2D):
	item_name = new_name
	item_value = new_value
	item_texture = new_texture
	
func get_value():
	return item_value

func get_item_name():
	return item_name

func set_value(new_value):
	item_value = new_value

func set_item_name(new_name):
	item_name = new_name

func _to_string():
	return item_name + ", Value: " + str(item_value)
