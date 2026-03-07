extends Control

@onready var localList = Array() 

@onready var balanceLabel = $MoneyLabel/Label
@onready var ticketBody = $TicketBody
@onready var upgradeBody = $UpgradeBody

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("ticket_inventory_updated", on_ticket_inventory_updated)
	EventBus.connect("player_money_updated", on_balance_updated)
	EventBus.connect("upgrade_inventory_updated", on_upgrade_inventory_updated)
	balanceLabel.text = "$" + str(GameManager.get_balance())
	ticketBody.clear()
	on_ticket_inventory_updated(GameManager.get_ticket_list())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func on_ticket_inventory_updated(new_list):
	ticketBody.text = ""
	localList = new_list
	for item in localList:
		ticketBody.text += item._to_string()
		
func on_upgrade_inventory_updated():
	upgradeBody.text = ""
	var localDict = GameManager.get_upgrade_dict().duplicate()
	for upgradeKey in localDict:
		var upgrade = localDict[upgradeKey]
		if (upgrade.get_is_active()):
			upgradeBody.text += upgrade._to_string()
		

func on_balance_updated(new_value):
	balanceLabel.text = "$" + str(new_value)
	
