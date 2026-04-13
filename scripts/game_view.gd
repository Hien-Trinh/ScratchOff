extends Node2D

@onready var shop_menu = $ShopMenu
@onready var table = $Table
@onready var anim = $AnimationPlayer
@onready var pause_menu = $PauseMenu
@onready var hand = $Hand
@onready var cashArea = $Table/cashArea

@onready var round_label = $Table/TableUI/RoundLabel
@onready var money_label = $Table/TableUI/moneyLabel
@onready var goal_label = $Table/TableUI/GoalLabel

@onready var game_over = $GameOver

var game_timer = Timer.new()
var round_counter : int = 1

var goal : float = 1000

var rounds_per_loop : int = 6
var loop_count : int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	remove_child(hand)
	shop_menu.process_mode = Node.PROCESS_MODE_PAUSABLE
	table.process_mode = Node.PROCESS_MODE_PAUSABLE
	pause_menu.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	pause_menu.visible = false
	shop_menu.visible = false
	game_over.visible = false
	round_label.text = "Round: " + str(round_counter)
	goal_label.text = "Goal: " + str(goal) + " By Round " + str(rounds_per_loop * loop_count)
	
	# Game timer init
	add_child(game_timer)
	game_timer.one_shot = true
	game_timer.connect("timeout", Callable(self,"_on_timer_timeout"))
	GameManager.connect("game_started_signal", Callable(self, "round_start"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$Table/TableUI/TimerLabel.set_text("TIME LEFT: " + str(snappedf(game_timer.get_time_left(), 0.1)))
	if Input.is_action_just_released("Pause"):
		get_tree().paused = true
		pause_menu.show()
		pause_menu.set_process(true)
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
	if round_counter > 1:
		table._ready()
	if round_counter == 1:
		add_child(hand)
	#if round_counter % rounds_per_loop == 0:
		#check_win_lose()
	if (GameManager.check_extra_time() == true):
		game_timer.set_wait_time(20) #Seconds
	else:
		game_timer.set_wait_time(15.0) # Seconds
	# Create a countdown animation?
	game_timer.start()

func _on_timer_timeout():
	if table.visible == true:
		shop_menu.visible = true
		shop_menu.refresh_shop()
		anim.play("shop_enter")
		hand.visible = false
		await anim.animation_finished
		table.visible = false
	if round_counter % rounds_per_loop == 0:
		check_win_lose()
		
func _on_continue_button_pressed():
	if GameManager.check_on_the_house() == true:
		GameManager.do_on_the_house()
	if shop_menu.visible == true:
		# Swap from shop to table
		GameManager.calculate_mult()
		table.visible = true
		cashArea.round_reset()
		anim.play("shop_exit")
		await anim.animation_finished
		hand.visible = true
		shop_menu.visible = false
		round_counter += 1
		round_label.text = "Round: " + str(round_counter)
		round_start()

func check_win_lose():
	if GameManager.balance < goal:
		# LOSE
		game_over.visible = true
		$GameOver/RoundNum.text = str(round_counter) #this wasn't str() before, caused an error
		anim.play("game_over_anim")
		await anim.animation_finished
		table.visible = false
		shop_menu.visible = false
	else:
		# WIN
		goal *=2
		cashArea.refresh_goal_count(goal)
		loop_count+=1
		goal_label.text = "Goal: " + str(goal) + " By Round " + str(rounds_per_loop * loop_count)

func _on_return_title_pressed():
	get_tree().change_scene_to_file("res://title_screen.tscn")
	GameManager.restart_game()
