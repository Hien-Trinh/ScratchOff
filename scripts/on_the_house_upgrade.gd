extends Upgrade # Subclass of the Upgrade class
class_name OnTheHouseUpgrade

#Free scratcher appears on table each round after buying, random between level 1-3

var rng = RandomNumberGenerator.new()

func _init(new_name : String, new_texture : Texture2D):
	upgrade_name = new_name
	upgrade_texture = new_texture
