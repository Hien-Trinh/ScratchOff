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
				anim_explo.scale *= 2
				anim_explo.z_index = 10
				# Play animation
				anim_explo.play("default")
				# Await animation finish
				await anim_explo.animation_finished
				# Remove explosion sprite from tree
				spawned_explosion_sprite.queue_free()
				card.queue_free()
				# Can cause bug: attempt to call queue free on a previously freed null instance
				GameManager.remove_ticket_at_index(GameManager.ticketList.find(card))

		# If we actually won money, apply it to the GameManager exactly ONCE.
		if total_winnings > 0:
			var new_balance = GameManager.balance + total_winnings
			GameManager.set_balance(new_balance)

func animate_counter(target_amount: float) -> void:
	if counter_tween and counter_tween.is_running():
		counter_tween.kill()
		
	counter_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	counter_tween.tween_method(_on_money_updated, displayed_money, target_amount, 0.75)
	
	displayed_money = target_amount
	
func _on_money_updated(current_val: float):
	moneyAmount.text = "$" + str(snappedf(current_val, 0.01))
