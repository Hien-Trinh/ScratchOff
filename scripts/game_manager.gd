extends Node

@onready var ticketList = Array() 
@onready var upgrade_dict = {}
@onready var ticket_template_dict = {}

@onready var reward_dict = {}
@onready var valueArray = [1, 5, 10, 25, 50, 100, 500, 1000]

var rng = RandomNumberGenerator.new()
var balance : float : 
	set = set_balance, get = get_balance
var mult : float : 
	set = set_mult, get = get_mult

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	mult = 1.0
	set_balance(100)
	init_ticket_dict()
	init_reward_dict()
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
	# LOTS OF MONEY
	var lom_foil = preload("res://assets/cards/lots-of-money.png")

	# Array Structure: 
	# [0: ID, 1: Name, 2: Cost, 3: Foil Tex, 4: Min Index, 5: Max Index]
	ticket_template_dict["LotsOfMoney"] = ["lom_01", "Lots of Money", 5.00, lom_foil, 0, 2]

	# NUCLEAR CAPITAL
	var nc_foil = preload("res://assets/cards/NuclearCapital180.png")

	ticket_template_dict["NuclearCapital"] = ["nc_01", "Nuclear Capital", 10.00, nc_foil, 2, 4]

# Reward sprite preload
func init_reward_dict():
	#reward_dict[0] = preload("res://assets/scratch_reward/1.png")
	#reward_dict[1] = preload("res://assets/scratch_reward/5.png")
	#reward_dict[2] = preload("res://assets/scratch_reward/10.png")
	#reward_dict[3] = preload("res://assets/scratch_reward/25.png")
	#reward_dict[4] = preload("res://assets/scratch_reward/50.png")
	#reward_dict[5] = preload("res://assets/scratch_reward/100.png")
	reward_dict[5] = preload("res://assets/scratch_reward/temp_scratch_100.png")
	#reward_dict[6] = preload("res://assets/scratch_reward/500.png")
	#reward_dict[7] = preload("res://assets/scratch_reward/1000.png")

func init_upgrade_dict():
	var mult1_texture = preload("res://assets/upgrades/temp_up.svg")
	upgrade_dict["Mult1"] = MultiplierUpgrade.new("1.5x Multiplier", mult1_texture, 1.5)
	print(upgrade_dict)

func generate_ticket(ticket_key : String):
	if(ticket_template_dict.has(ticket_key)):
		var info = ticket_template_dict.get(ticket_key)

		# Unpack the array based on our new structure
		var t_id = info[0]
		var t_name = info[1]
		var t_cost = info[2]
		var t_foil = info[3]
		var min_index = info[4]
		var max_index = info[5]

		# Calculate the final value
		var random_index = rng.randi_range(min_index, max_index)
		random_index = 5 # Temp until other reward sprites are done
		var base_val = valueArray[random_index]
		var act_val = base_val * mult
		
		# Reward sprite based on random_index
		var t_reward = reward_dict[random_index]

		# Return the perfectly formatted CardItem!
		return CardItem.new(t_id, t_name, act_val, t_cost, t_foil, t_reward)
	else: 
		return null
