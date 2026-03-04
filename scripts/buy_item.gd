extends Button

@export var item_cost : float
@export var item_name : String

@export var item_texture : Texture2D
@export var is_upgrade : bool

@export var item_max_payout : float
# Only used for ticket items

@onready var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	self.text = "$" + str(item_cost)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

# On button pressed should trigger buy depending on is_upgrade
	
func buy_ticket(): 
	var diff : float = GameManager.get_balance() - item_cost
	
	if(diff >= 0):
		GameManager.add_ticket(GameManager.generate_ticket(item_name, item_max_payout, item_texture))
		GameManager.set_balance(diff)
		# Inventory should update automatically b/c EventBus
	else:
		print("Player does not have enough money!")

func buy_upgrade():
	pass
