extends Control

@onready var localList = Array() 

@onready var ticketBody = $TicketBody

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("ticket_inventory_updated", on_ticket_inventory_updated)
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
