extends Sprite2D


@export var moneyAmount : Label
@onready var cashSpace = $Area2D
@onready var explosion = $Sound/Explosion

var money : float = GameManager.balance
var displayed_money : float = GameManager.balance
var winning = 0
var local_goal = 0.0

var counter_tween : Tween


func _ready():
	_update_label(displayed_money)

func refresh_goal_count(new_value):
	# moneyAmount.text = "Money: $" + str(money) + " / " + str(new_value)
	local_goal = new_value

	
func _process(delta: float) -> void:
	if Input.is_action_just_released("Click") && get_global_mouse_position().x < 350 && get_global_mouse_position().y > 600 && cashSpace.has_overlapping_bodies():
		var labelArray = cashSpace.get_overlapping_bodies()
		var did_cash_in = false

		for card in labelArray:
			if card.card_data.is_scratched == true:
				winning = card.card_data.card_value

				# Gambling Upgrade calculation
				if GameManager.check_gamble() == true:
					print("gambling is true")
					winning *= GameManager.gamble()

				# Remove card from existence
				card.queue_free()
				GameManager.remove_ticket_at_index(GameManager.ticketList.find(card))

				money += (winning * GameManager.mult)
				GameManager.set_balance(money)
				explosion.play()
		
				did_cash_in = true

		if did_cash_in:
			animate_counter(money)
		# moneyLabel.text = "Money: $" + str(money) + " / " + str(local_goal)

func animate_counter(target_amount: float) -> void:
	if counter_tween and counter_tween.is_running():
		counter_tween.kill()
		
	counter_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	
	# Tween the 'displayed_money' variable from its current value to the target_amount over 0.75 seconds
	# It will call the _update_label function every single frame with the newly calculated number!
	counter_tween.tween_method(_update_label, displayed_money, target_amount, 0.75)
	
	# Update our tracker
	displayed_money = target_amount

func _update_label(current_val: float) -> void:
	moneyAmount.text = "$" + str(snappedf(current_val, 0.01))

#line of tabs to see end of long line above, godot issue
																																										
