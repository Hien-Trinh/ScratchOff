extends Upgrade # Subclass of the Upgrade class
class_name CheapskateUpgrade

#shop prices are reduced 15% for each item

func _init(new_name : String, new_texture : Texture2D):
	upgrade_name = new_name
	upgrade_texture = new_texture
