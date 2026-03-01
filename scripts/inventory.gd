extends Control

@onready var localList = Array() 

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("ticket_inventory_updated", on_ticket_inventory_updated)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func on_ticket_inventory_updated(new_list):
	localList = new_list
