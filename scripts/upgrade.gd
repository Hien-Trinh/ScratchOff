extends Node
class_name Upgrade
# Class for upgrades
	
var upgrade_name : String:
	set = set_upgrade_name, get = get_upgrade_name
	
var upgrade_texture : Texture

func _init(new_name :  String, new_texture : Texture2D):
	upgrade_name = new_name
	upgrade_texture = new_texture

func get_upgrade_name():
	return upgrade_name

func set_upgrade_name(new_name):
	upgrade_name = new_name
