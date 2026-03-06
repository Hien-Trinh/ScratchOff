extends Button

@export var buy_cost : float
@export var buy_name : String
@export var buy_texture : Texture2D
@export var is_upgrade : bool

@export var item_max_payout : float
# Only used for ticket items
var upgrade_already_owned : bool
# Only used for upgrades
# Potentially determined through GameManager's upgrade_dict{}?

@onready var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	self.text = "$" + str(buy_cost)
	upgrade_already_owned = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
# On button pressed should trigger buy depending on is_upgrade
	
func buy_ticket(): 
	var diff : float = GameManager.get_balance() - buy_cost
	
	if(diff >= 0):
		GameManager.add_ticket(GameManager.generate_ticket("LotsOfMoney"))
		GameManager.set_balance(diff)
		# Inventory should update automatically b/c EventBus
		# This doesn't actually add something to the game in the table scene
	else:
		print("Player does not have enough money!")

func buy_upgrade():
	pass
