extends Node2D

@onready var shop_menu = $ShopMenu
@onready var table = $Table
@onready var anim = $AnimationPlayer
@onready var pause_menu = $PauseMenu
@onready var hand = $Hand
@onready var cashArea = $Table/cashArea
@onready var end_button = $EndRoundButton

@onready var round_label = $Table/TableUI/RoundLabel
@onready var money_label = $Table/TableUI/moneyLabel
@onready var goal_label = $Table/TableUI/GoalLabel

@onready var game_over = $GameOver

@export var yellSound : AudioStreamPlayer2D
@export var continueButton : Button

var game_timer = Timer.new()
var round_counter : int = 1

var goal : float = 800

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
	$EndRoundButton.disabled = true
	
	# Game timer init
	add_child(game_timer)
	game_timer.one_shot = true
	game_timer.connect("timeout", Callable(self,"_on_timer_timeout"))
	add_child(hand)
	GameManager.connect("game_started_signal", Callable(self, "round_start"))
	pause_menu.connect("game_resume", Callable(self, "on_game_resumed"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$Table/TableUI/TimerLabel.set_text("TIME LEFT: " + str(snappedf(game_timer.get_time_left(), 0.1)))
	if Input.is_action_just_released("Pause"):
		hand.visible = false
		get_tree().paused = true
		pause_menu.show()
		pause_menu.set_process(true)

func round_start():
	$EndRoundButton.disabled = false
	if round_counter > 1:
		table._ready()
	continueButton.disabled = false
	if (GameManager.check_extra_time() == true):
		game_timer.set_wait_time(25) #Seconds
	else:
		game_timer.set_wait_time(15.0) # Seconds
	game_timer.start()

# Timer referenced is specifically the game round timer
func _on_timer_timeout():
	if round_counter % rounds_per_loop == 0:
		check_win_lose()
	if table.visible == true:
		shop_menu.visible = true
		shop_menu.refresh_shop()
		hand.visible = false
		end_button.visible = false
		anim.play("shop_enter")
		await anim.animation_finished
		table.visible = false
		
func on_game_resumed():
	hand.visible = true
		
func _on_continue_button_pressed():
	continueButton.disabled = true
	if GameManager.check_on_the_house() == true:
		GameManager.do_on_the_house()
	if shop_menu.visible == true:
		# Swap from shop to table
		GameManager.calculate_mult()
		table.visible = true
		cashArea.round_reset()
		anim.play("shop_exit")
		await anim.animation_finished
		end_button.visible = true
		hand.visible = true
		shop_menu.visible = false
		round_counter += 1
		round_label.text = "Round: " + str(round_counter)
		round_start()

func check_win_lose():
	if GameManager.balance < goal:
		# LOSE
		yellSound.play()
		game_over.visible = true
		$GameOver/RoundNum.text = str(round_counter)
		anim.play("game_over_anim")
		await anim.animation_finished
		table.visible = false
		shop_menu.visible = false
	else:
		# WIN
		goal *= 6
		loop_count+=1
		goal_label.text = "Goal: " + str(goal) + " By Round " + str(rounds_per_loop * loop_count)

func _on_return_title_pressed():
	get_tree().change_scene_to_file("res://title_screen.tscn")
	GameManager.restart_game()

func _on_button_pressed() -> void:
	game_timer.stop()
	_on_timer_timeout()
