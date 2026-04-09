extends Upgrade # Subclass of the Upgrade class
class_name OnTheHouseUpgrade

#Triple or nothing rewards on each card

var rng = RandomNumberGenerator.new()

func _init(new_name : String, new_texture : Texture2D):
	upgrade_name = new_name
	upgrade_texture = new_texture
