extends Upgrade # Subclass of the Upgrade class
class_name ExtraTimeUpgrade

#Player is given 5 seconds of extra scratching time.

func _init(new_name : String, new_texture : Texture2D):
	upgrade_name = new_name
	upgrade_texture = new_texture
