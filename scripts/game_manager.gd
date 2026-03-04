extends Node

@onready var ticketList = Array() 

var rng = RandomNumberGenerator.new()
var balance : float : set = set_balance, get = get_balance

# Called when the node enters the scene tree for the first time.
func _ready():
	balance = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func add_ticket(item : Item):
	# Add item to ticketList Array
	ticketList.add(item)
	# Broadcast updated Array to EventBus with corresponding signal
	EventBus.ticket_inventory_updated.emit(ticketList)

func get_balance():
	return balance
	
func set_balance(new_value):
	balance = new_value
	# Broadcast updated balance to EventBus with corresponding signal
	EventBus.player_money_updated.emit(balance)
	# If balance is less than zero, trigger fail state

func generate_ticket(ticket_name : String, max_value : float, texture : Texture2D):
	return Item.new(ticket_name, rng.randi_range(0, max_value), texture)
