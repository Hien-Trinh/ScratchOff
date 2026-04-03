extends Upgrade # Subclass of the Upgrade class

#Double or nothing rewards on each card

var rng = RandomNumberGenerator.new()

func _init(new_name : String, new_texture : Texture2D):
	upgrade_name = new_name
	upgrade_texture = new_texture

#This is called when a card is cashed in and this upgrade is present
func gamble():
	pass #for now
	
	var my_random_number = rng.randf_range(0.0, 1.0)
	
#	"winning" here refers to the 'winning' variable in cashInArea which grabs the
#	 card value. This upgrade is called after that variable is made.
	#var currentVal = winning

	var result = 0
	if (my_random_number > 0.5):
		result = 0
	else:
		result = 2
#	currentVal *= result

	
