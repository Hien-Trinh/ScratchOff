extends Button

@export var buy_cost : float
@export var buy_name : String
@export var buy_texture : Texture2D
@export var is_upgrade : bool

@export var item_max_payout : float
# Only used for ticket items
var upgrade_already_owned : bool
# Only used for upgrades

@onready var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	self.text = "$" + str(buy_cost)
	upgrade_already_owned = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func buy_ticket(): 
	GameManager.add_ticket(GameManager.generate_ticket(buy_name))
		# Inventory should update automatically b/c EventBus
		# This doesn't actually add something to the game in the table scene

func buy_upgrade():
	if (!upgrade_already_owned):
		if(GameManager.get_upgrade_dict().has(buy_name)):
			GameManager.activate_upgrade(buy_name)
			upgrade_already_owned = true
			GameManager.set_balance(GameManager.get_balance() - buy_cost)
			print("Upgrade bought!")
	else: self.text = "OWNED"

func _on_pressed():
	var diff : float = GameManager.get_balance() - buy_cost
	if(diff>=0):
		if(!is_upgrade):
			print("Buy ticket started...")
			buy_ticket()
			GameManager.set_balance(diff)
		else: 
			print("Buy upgrade started...")
			buy_upgrade()
	else: print("Player does not have enough money!")
