extends Control

@onready var color_rect = $ColorRect
@onready var tickets = $Tickets
@onready var upgrades = $Upgrades
@onready var balanceLabel = $MoneyLabel/Label

var shop_dict = {}

var rng = RandomNumberGenerator.new()

func _ready():
	animate_background()
	refresh_shop()
	EventBus.connect("player_money_updated", on_balance_updated)
	balanceLabel.text = "$" + str(GameManager.get_balance())
	
func on_balance_updated(new_value):
	balanceLabel.text = "$" + str(new_value)
	
func animate_background():
	var tween = get_tree().create_tween().set_loops()
	tween.tween_method(set_bg_hue, 0.0, 1.0, 10.0)

func set_bg_hue(hue: float):
	color_rect.modulate = Color.from_hsv(hue, 1.0, 1.0)

func refresh_shop():
	var ticket_template_arr = GameManager.ticket_template_dict.values()
	
	var shuffled_tickets = ticket_template_arr.duplicate()
	shuffled_tickets.shuffle()
	
	var shop_tickets = shuffled_tickets.slice(0, 4)
	shop_tickets.sort_custom(func(a, b): return a[2] < b[2])
	
	var tick1 = shop_tickets[0]
	var tick2 = shop_tickets[1]
	var tick3 = shop_tickets[2]
	var tick4 = shop_tickets[3]
	
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

func _on_upgrade_1_mouse_entered():
	$DescBox/DescLabel.text = "Multiply card value by 1.25"
	
func _on_upgrade_2_mouse_entered():
	$DescBox/DescLabel.text = "Multiply card value by 1.5"
	
func _on_upgrade_3_mouse_entered():
	$DescBox/DescLabel.text = "2.5x or nothing"
	
func _on_upgrade_4_mouse_entered():
	$DescBox/DescLabel.text = "Free card every round"
	
func _on_upgrade_5_mouse_entered():
	$DescBox/DescLabel.text = "Lower shop prices"
	
func _on_upgrade_6_mouse_entered():
	$DescBox/DescLabel.text = "More time per round"
