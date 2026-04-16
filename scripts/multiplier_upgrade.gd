extends Upgrade # Subclass of the Upgrade class
class_name MultiplierUpgrade
# Class for Multiplier upgrades

var multiplier : float:
	set = set_multiplier, get = get_multiplier

func _init(new_name : String, multiplier : float):
	upgrade_name = new_name
	self.multiplier = multiplier

func get_multiplier():
	return multiplier

func set_multiplier(new_value):
	multiplier = new_value
