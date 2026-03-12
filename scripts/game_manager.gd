extends Node

@onready var ticketList = Array() 
@onready var upgrade_dict = {}
@onready var ticket_template_dict = {}

@onready var valueArray = [1, 5, 10, 25, 50, 100, 500, 1000]

var rng = RandomNumberGenerator.new()
var balance : float : 
	set = set_balance, get = get_balance
var mult : float : 
	set = set_mult, get = get_mult

# Called when the node enters the scene tree for the first time.
func _ready():
	mult = 1.0
	set_balance(100)
	init_ticket_dict()
	init_upgrade_dict()
	add_ticket(generate_ticket("LotsOfMoney"))
	print(ticketList)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func add_ticket(cardItem : CardItem):
	# Add item to ticketList Array
	ticketList.append(cardItem)
	# Broadcast updated Array to EventBus with corresponding signal
	EventBus.ticket_inventory_updated.emit(ticketList)

func remove_ticket_at_index(index : int):
	ticketList.remove_at(index)
	EventBus.ticket_inventory_updated.emit(ticketList)

func get_balance():
	return balance

func set_balance(new_value):
	balance = new_value
	# Broadcast updated balance to EventBus with corresponding signal
	EventBus.player_money_updated.emit(balance)
	# If balance is less than zero, trigger fail state

func get_mult():
	return mult

func set_mult(new_value):
	mult = new_value
	EventBus.mult_updated.emit(mult)

func get_upgrade_dict():
	return upgrade_dict
	
func get_ticket_list():
	return ticketList
	
func activate_upgrade(upgrade_name):
	if(upgrade_dict.has(upgrade_name)):
		upgrade_dict[upgrade_name].set_is_active(true)
		print(upgrade_name + " is active: " + str(upgrade_dict[upgrade_name].get_is_active()))
		EventBus.upgrade_inventory_updated.emit()

# Runs at startup.
# Adds one of every Item to the ticket_template_dict{} dictionary.
func init_ticket_dict():
	var lom_texture = preload("res://assets/cards/lots-of-money.png")
	ticket_template_dict["LotsOfMoney"] = ["Lots of Money", 0, 2, lom_texture]
	# Integers correspond to indexes in valueArray[]
	var nc_texture = preload("res://assets/cards/NuclearCapital180.png")
	ticket_template_dict["NuclearCapital"] = ["Nuclear Capital", 2, 4, nc_texture]

func init_upgrade_dict():
	var mult1_texture = preload("res://assets/upgrades/temp_up.svg")
	upgrade_dict["Mult1"] = MultiplierUpgrade.new("1.5x Multiplier", mult1_texture, 1.5)
	print(upgrade_dict)

func generate_ticket(ticket_key : String):
	if(ticket_template_dict.has(ticket_key)):
		var ticketInfo = ticket_template_dict.get(ticket_key)
		var ticket_name = ticketInfo[0]
		var min_value = ticketInfo[1]
		var max_value = ticketInfo[2]
		var foil_texture = ticketInfo[3]
		var act_val = valueArray[rng.randi_range(min_value, max_value)]
		return CardItem.new(ticket_name, act_val, foil_texture)
	else: return null
