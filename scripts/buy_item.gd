extends Button

@export var buy_cost : float
@export var buy_name : String
@export var is_upgrade : bool

var upgrade_already_owned : bool
# Only used for upgrades

@onready var rng = RandomNumberGenerator.new()
@onready var buysfx_player = AudioStreamPlayer.new()
@onready var buysfx = preload("res://assets/audio/sfx/cash-register.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.text = "$" + str(buy_cost)
	upgrade_already_owned = false
	add_child(buysfx_player)
	buysfx_player.stream = buysfx
	buysfx_player.bus = "Distort"
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func buy_ticket(): 
	var ticket = GameManager.generate_ticket(buy_name)
	GameManager.add_ticket(ticket)
	GameManager.spawn_list.append(ticket)
		# Inventory should update automatically b/c EventBus
		# This doesn't actually add something to the game in the table scene

func buy_upgrade():
	if (!upgrade_already_owned):
		if(GameManager.get_upgrade_dict().has(buy_name)):
			GameManager.activate_upgrade(buy_name)
			upgrade_already_owned = true
			GameManager.set_balance(GameManager.get_balance() - buy_cost)
			buysfx_player.play()
			self.text = "OWNED"

func _on_pressed():
	var diff : float = GameManager.get_balance() - buy_cost
	if(diff>=0):
		if(!is_upgrade):
			buy_ticket()
			buysfx_player.play()
			GameManager.set_balance(diff)
		else: 
			buy_upgrade()
	else: print("Player does not have enough money!")
