extends Sprite2D


@export var moneyAmount : Label
@onready var cashSpace = $Area2D
@onready var explosion = $Sound/Explosion

var displayed_money : float = GameManager.balance
var winning = 0
var local_goal = 0.0

var counter_tween : Tween


func _ready():
	EventBus.player_money_updated.connect(animate_counter)
	round_reset()
	
func round_reset():
	moneyAmount.text = "$" + str(snappedf(displayed_money, 0.01))
	
func _process(delta: float) -> void:
	if Input.is_action_just_released("Click") && get_global_mouse_position().x < 350 && get_global_mouse_position().y > 600 && cashSpace.has_overlapping_bodies():
		var labelArray = cashSpace.get_overlapping_bodies()

		# Accumulate total winnings first (prevents animation glitching if stacking 3 cards)
		var total_winnings = 0.0

		for card in labelArray:
			if card.card_data.is_scratched == true:
				winning = card.card_data.card_value

				if GameManager.check_gamble() == true:
					winning *= GameManager.gamble()

				total_winnings += (winning * GameManager.mult)

				card.queue_free()
				GameManager.remove_ticket_at_index(GameManager.ticketList.find(card))

		# If we actually won money, apply it to the GameManager exactly ONCE.
		if total_winnings > 0:
			explosion.play()
			var new_balance = GameManager.balance + total_winnings
			GameManager.set_balance(new_balance)

		# moneyLabel.text = "Money: $" + str(money) + " / " + str(local_goal)

func animate_counter(target_amount: float) -> void:
	if counter_tween and counter_tween.is_running():
		counter_tween.kill()
		
	counter_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	counter_tween.tween_method(_on_money_updated, displayed_money, target_amount, 0.75)
	
	displayed_money = target_amount
	
func _on_money_updated(current_val: float):
	moneyAmount.text = "$" + str(snappedf(current_val, 0.01))
	# moneyAmount.text = "$" + str(snappedf(current_val, 0.01)) + " / $" + str(local_goal)

#line of tabs to see end of long line above, godot issue
																																										
