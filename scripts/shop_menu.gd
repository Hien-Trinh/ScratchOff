extends Control

@onready var color_rect = $ColorRect
@onready var tickets = $Tickets
@onready var upgrades = $Upgrades

var shop_dict = {}

var rng = RandomNumberGenerator.new()

func _ready():
	animate_background()
	refresh_shop()
	
func animate_background():
	var tween = get_tree().create_tween().set_loops()
	tween.tween_method(set_bg_hue, 0.0, 1.0, 10.0)

func set_bg_hue(hue: float):
	color_rect.modulate = Color.from_hsv(hue, 1.0, 1.0)

func refresh_shop():
	var ticket_template_arr = GameManager.ticket_template_dict.values()
	
	var shuffled_tickets = ticket_template_arr.duplicate()
	shuffled_tickets.shuffle()
	
	var tick1 = shuffled_tickets[0]
	var tick2 = shuffled_tickets[1]
	var tick3 = shuffled_tickets[2]
	var tick4 = shuffled_tickets[3]
	
	$Tickets/Ticket1.texture = tick1[3]
	$Tickets/Ticket2.texture = tick2[3]
	$Tickets/Ticket3.texture = tick3[3]
	$Tickets/Ticket4.texture = tick4[3]
	
	$Tickets/Ticket1/Buy_1.buy_name = remove_spaces(tick1[1])
	$Tickets/Ticket1/Buy_1.buy_cost = tick1[2]
	
	$Tickets/Ticket2/Buy_2.buy_name = remove_spaces(tick2[1])
	$Tickets/Ticket2/Buy_2.buy_cost = tick2[2]
	
	$Tickets/Ticket3/Buy_3.buy_name = remove_spaces(tick3[1])
	$Tickets/Ticket3/Buy_3.buy_cost = tick3[2]
	
	$Tickets/Ticket4/Buy_4.buy_name = remove_spaces(tick4[1])
	$Tickets/Ticket4/Buy_4.buy_cost = tick4[2]
	
	$Tickets/Ticket1/Buy_1.text = "$" + str($Tickets/Ticket1/Buy_1.buy_cost)
	$Tickets/Ticket2/Buy_2.text = "$" + str($Tickets/Ticket2/Buy_2.buy_cost)
	$Tickets/Ticket3/Buy_3.text = "$" + str($Tickets/Ticket3/Buy_3.buy_cost)
	$Tickets/Ticket4/Buy_4.text = "$" + str($Tickets/Ticket4/Buy_4.buy_cost)

func remove_spaces(value : String):
	value = value.replace(" ", "")
	return value
