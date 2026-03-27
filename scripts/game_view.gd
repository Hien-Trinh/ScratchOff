extends Node2D

@onready var shop_menu = $ShopMenu
@onready var table = $Table
@onready var anim = $AnimationPlayer
@onready var pause_menu = $PauseMenu
@onready var hand = $Hand

# Called when the node enters the scene tree for the first time.
func _ready():
	remove_child(hand)
	shop_menu.process_mode = Node.PROCESS_MODE_PAUSABLE
	table.process_mode = Node.PROCESS_MODE_PAUSABLE
	pause_menu.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	pause_menu.visible = false
	shop_menu.visible = false
	round_start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# SwapScreenTest = the "V" key
	if Input.is_action_just_released("SwapScreenTest"):
		if shop_menu.visible == true:
			# Swap from shop to table
			table.visible = true
			hand.visible = true
			anim.play("shop_exit")
			await anim.animation_finished
			shop_menu.visible = false
		elif table.visible == true:
			# Swap from table to shop
			shop_menu.visible = true
			anim.play("shop_enter")
			await anim.animation_finished
			hand.visible = false
			table.visible = false

func round_start():
	table._ready()
	add_child(hand)
	var game_timer = Timer.new()
	add_child(game_timer)
	game_timer.set_wait_time(15.0) # Seconds
	game_timer.connect("timeout", Callable(self,"_on_timer_timeout"))
	# Create a countdown animation?
	game_timer.start()

func _on_timer_timeout():
	if table.visible == true:
		shop_menu.visible = true
		anim.play("shop_enter")
		hand.visible = false
		await anim.animation_finished
		table.visible = false
	
func _on_continue_button_pressed():
	if shop_menu.visible == true:
			# Swap from shop to table
			table.visible = true
			anim.play("shop_exit")
			await anim.animation_finished
			hand.visible = true
			shop_menu.visible = false
