extends Upgrade # Subclass of the Upgrade class

#shop prices are reduced 25%

func _init(new_name : String, new_texture : Texture2D):
	upgrade_name = new_name
	upgrade_texture = new_texture

#this function is called when entering shop and this upgrade active
func cheapskate():
	pass #for now
#	Shop isn't 
