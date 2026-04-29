extends Button

@export var buy_cost : float = 0.0
@export var buy_name : String = "empty"
@export var is_upgrade : bool

var upgrade_already_owned : bool
# Only used for upgrades

@onready var rng = RandomNumberGenerator.new()
@onready var buysfx_player = AudioStreamPlayer.new()
@onready var buysfx = preload("res://assets/audio/sfx/cash-register.wav")
@onready var fail_buysfx_player = AudioStreamPlayer.new()
@onready var fail_buysfx = preload("res://assets/audio/sfx/no-money.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	if (buy_name == "Mult2" or buy_name == "Mult3"):
		disabled = true
	self.text = "$" + str(buy_cost)
	upgrade_already_owned = false
	add_child(buysfx_player)
	add_child(fail_buysfx_player)
	buysfx_player.stream = buysfx
	buysfx_player.volume_db = -2.5
	fail_buysfx_player.stream = fail_buysfx
	fail_buysfx_player.volume_db = -14.0
	
func _process(_delta):
	if (is_upgrade && !upgrade_already_owned):
		if (GameManager.shop_mult2_active == true && GameManager.shop_mult2_updated == false):
			disabled = false
			GameManager.shop_mult2_updated = true
		if (GameManager.shop_mult3_active == true && GameManager.shop_mult3_updated == false):
			disabled = false
			GameManager.shop_mult3_updated = true
		if GameManager.num_upgrades == 0:
				buy_cost = 50
				self.text = "$" + str(buy_cost)
		elif GameManager.num_upgrades == 1:
				buy_cost = 75
				self.text = "$" + str(buy_cost)
		elif GameManager.num_upgrades == 2:
				buy_cost = 100
				self.text = "$" + str(buy_cost)
		elif GameManager.num_upgrades == 3:
				buy_cost = 200
				self.text = "$" + str(buy_cost)
		elif GameManager.num_upgrades == 4:
				buy_cost = 450
				self.text = "$" + str(buy_cost)
		elif GameManager.num_upgrades == 5:
				buy_cost = 800
				self.text = "$" + str(buy_cost)
		elif GameManager.num_upgrades >= 6:
				buy_cost = 2000
				self.text = "$" + str(buy_cost)
		
	#for cheapskate upgrade
	if (GameManager.check_cheapskate() == true && !is_upgrade):
		if (buy_cost == 100 or buy_cost == 75 or buy_cost == 30 or buy_cost == 15 or buy_cost == 10 or buy_cost == 5):
			buy_cost *= 0.7
			self.text = "$" + str(buy_cost)

func buy_ticket(): 
	var ticket = GameManager.generate_ticket(buy_name)
	GameManager.add_ticket(ticket)
	GameManager.spawn_list.append(ticket)
		# Inventory should update automatically b/c EventBus
		# This doesn't actually add something to the game in the table scene

func buy_upgrade():
	if (!upgrade_already_owned):
		if(GameManager.get_upgrade_dict().has(buy_name)):
			if (buy_name == "Mult1"):
				GameManager.shop_mult2_active = true
			if (buy_name == "Mult2"):
				GameManager.shop_mult3_active = true
			GameManager.activate_upgrade(buy_name)
			upgrade_already_owned = true
			GameManager.set_balance(GameManager.get_balance() - buy_cost)
			buysfx_player.play()
			self.text = "OWNED"
			GameManager.num_upgrades += 1

func _on_pressed():
	var diff : float = GameManager.get_balance() - buy_cost
	if(diff>=0):
		if(!is_upgrade):
			buy_ticket()
			buysfx_player.play()
			GameManager.set_balance(diff)
		else: 
			buy_upgrade()
	else: fail_buysfx_player.play()
