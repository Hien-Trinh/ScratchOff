extends Control

@onready var localList = Array() 

@onready var ticketBody = $TicketBody

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("ticket_inventory_updated", on_ticket_inventory_updated)
	ticketBody.clear()
	on_ticket_inventory_updated(GameManager.get_ticket_list())

	
func on_ticket_inventory_updated(new_list):
	ticketBody.text = ""
	localList = {}
	for item in new_list:
		var item_str = item.to_string()
		if localList.has(item_str):
			localList[item_str] += 1
		else:
			localList[item_str] = 1

	for key in localList:
		ticketBody.text += "%s x %s" % [key, localList[key]]
