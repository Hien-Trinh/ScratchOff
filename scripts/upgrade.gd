extends Node
class_name Upgrade
# Class for upgrades

var upgrade_name : String:
	set = set_upgrade_name, get = get_upgrade_name

var upgrade_texture : Texture

var is_active : bool:
	set = set_is_active, get = get_is_active

func _init(new_name :  String, new_texture : Texture2D):
	upgrade_name = new_name
	upgrade_texture = new_texture
	is_active = false

func get_upgrade_name():
	return upgrade_name

func set_upgrade_name(new_name):
	upgrade_name = new_name

func get_is_active():
	return is_active

func set_is_active(new_value : bool):
	is_active = new_value

func _to_string(): # Overriding the default _to_string() method
	return upgrade_name
