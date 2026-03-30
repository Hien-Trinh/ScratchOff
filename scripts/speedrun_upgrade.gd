extends Upgrade # Subclass of the Upgrade class


#if round complete with more than 50% time left, get a bonus

func _init(new_name : String, new_texture : Texture2D):
	upgrade_name = new_name
	upgrade_texture = new_texture

#Triggered when round ends and this upgrade is active
func check_speedrun():
	pass #for now
	#assuming the times are in float
	#float roundTime = methodToGrabTimeNeededForCurrentRoundWin
	#float timeTaken = methodToGrabTimeTakenInRound
	
	
	#0.5 is variable, maybe we do .6 or .7
#	if (roundtime * 0.5 < timeTaken):
#		addMoneyMethod, probably 1.2x current money? Or constant, like 200
	
