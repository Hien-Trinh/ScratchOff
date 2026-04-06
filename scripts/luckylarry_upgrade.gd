extends Upgrade # Subclass of the Upgrade class
class_name LuckyLarryUpgrade

#Adds 1 random bonus scratcher to table each round. seems early game.
#The scratcher added isn't too good of a scratcher

func _init(new_name : String, new_texture : Texture2D):
	upgrade_name = new_name
	upgrade_texture = new_texture

#Called on round start, but also connects to inventory? Not sure
func bonusCard():
	pass #for now
