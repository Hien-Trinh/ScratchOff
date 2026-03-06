extends Node

@onready var ticketList = Array() 
@onready var upgrade_dict = {}
@onready var ticket_template_dict = {}

var rng = RandomNumberGenerator.new()
var balance : float : 
	set = set_balance, get = get_balance
var mult : float : 
	set = set_mult, get = get_mult

# Called when the node enters the scene tree for the first time.
func _ready():
	mult = 1.0
	balance = 0
	init_ticket_dict()
	add_ticket(generate_ticket("LotsOfMoney"))
	print(ticketList)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func add_ticket(item : Item):
	# Add item to ticketList Array
	ticketList.append(item)
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

# Runs at startup.
# Adds one of every Item to the ticket_template_dict{} dictionary.
func init_ticket_dict():
	var lom_texture = preload("res://assets/cards/lots-of-money.png")
	ticket_template_dict["LotsOfMoney"] = ["Lots of Money", 20, lom_texture]
	var nc_texture = preload("res://assets/cards/NuclearCapital180.png")
	ticket_template_dict["NuclearCapital"] = ["Nuclear Capital", 50, nc_texture]

func generate_ticket(ticket_key : String):
	if(ticket_template_dict.has(ticket_key)):
		var ticketInfo = ticket_template_dict.get(ticket_key)
		var ticket_name = ticketInfo[0]
		var max_value = ticketInfo[1]
		var texture = ticketInfo[2]
		var act_val = snappedf(rng.randf_range(0.0, max_value) * mult, 0.01)
		return Item.new(ticket_name, act_val, texture)
	else: return null
