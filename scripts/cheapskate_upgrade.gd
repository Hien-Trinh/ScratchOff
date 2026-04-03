extends Upgrade # Subclass of the Upgrade class

#shop prices are reduced 25%

#reference to shopmenu? Not sure how that works with scripts

func _init(new_name : String, new_texture : Texture2D):
	upgrade_name = new_name
	upgrade_texture = new_texture

#this function is called when entering shop, prices set, and this upgrade active
func cheapskate():
	pass #for now
	#$Tickets/Ticket1/Buy_1.buy_cost = tick1[2]
	#$Tickets/Ticket1/Buy_2.buy_cost = tick2[2]
	#$Tickets/Ticket1/Buy_3.buy_cost = tick3[2]
	#$Tickets/Ticket1/Buy_4.buy_cost = tick4[2]
