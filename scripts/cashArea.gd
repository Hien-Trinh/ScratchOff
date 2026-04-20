extends Sprite2D


@export var moneyAmount : Label
@onready var cashSpace = $Area2D
@onready var explosion_sound = $Sound/Explosion

var displayed_money : float = GameManager.balance
var winning = 0

var counter_tween : Tween

const EXPLO_SPRITE = preload("res://explosion.tscn")

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
					winning *= GameManager.do_gamble()

				total_winnings += (winning * GameManager.mult)
				var spawned_explosion_sprite = EXPLO_SPRITE.instantiate()
				add_child(spawned_explosion_sprite)
				
				explosion_sound.play()
				# Get child of explosion sprite
				var anim_explo = spawned_explosion_sprite.get_child(0)
				anim_explo.position = card.position
				anim_explo.position.y -= 800
				anim_explo.scale *= 3
				anim_explo.z_index = 10
				# Play animation
				card.queue_free()
				anim_explo.play("default")
				# Await animation finish
				await anim_explo.animation_finished
				# Remove explosion sprite from tree
				spawned_explosion_sprite.queue_free()
				# Can cause bug: attempt to call queue free on a previously freed null instance
				GameManager.remove_ticket_at_index(GameManager.ticketList.find(card))

		# If we actually won money, apply it to the GameManager exactly ONCE.
		if total_winnings > 0:
			var new_balance = GameManager.balance + total_winnings
			GameManager.set_balance(new_balance)

func animate_counter(target_amount: float) -> void:
	if counter_tween and counter_tween.is_running():
		counter_tween.kill()

	# Reset scale
	moneyAmount.scale = Vector2.ONE
	moneyAmount.rotation_degrees = 0.0

	counter_tween = create_tween()
	counter_tween.set_parallel(true)
	
	# The Number Counting (Takes 0.75 seconds)
	counter_tween.tween_method(_on_money_updated, displayed_money, target_amount, 0.75)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	
	
	# The "Jump" UP (Scale to 1.5x and tilt slightly over 0.15 seconds)
	counter_tween.tween_property(moneyAmount, "scale", Vector2(1.5, 1.5), 0.15)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	counter_tween.tween_property(moneyAmount, "rotation_degrees", 5.0, 0.15)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	
	
	# The "Jump" DOWN (Scale back to normal over 0.60 seconds)
	counter_tween.tween_property(moneyAmount, "scale", Vector2.ONE, 0.6)\
		.set_delay(0.15).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	counter_tween.tween_property(moneyAmount, "rotation_degrees", 0.0, 0.6)\
		.set_delay(0.15).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	
	displayed_money = target_amount
	
func _on_money_updated(current_val: float):
	moneyAmount.text = "$" + str(snappedf(current_val, 0.01))
