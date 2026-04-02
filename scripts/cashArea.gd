extends Sprite2D


@export var moneyLabel : Label
@onready var cashSpace = $Area2D
@onready var explosion = $Sound/Explosion
var money : float = GameManager.balance
var winning = 0

func _ready():
	moneyLabel.text = "Money: " + str(money)
	
func _process(delta: float) -> void:
	if Input.is_action_just_released("Click") && get_global_mouse_position().x < 350 && get_global_mouse_position().y > 600 && cashSpace.has_overlapping_bodies():
		var labelArray = cashSpace.get_overlapping_bodies()
		for card in labelArray:
			if card.card_data.is_scratched == true:
				winning = card.card_data.card_value
				card.free()
				GameManager.remove_ticket_at_index(GameManager.ticketList.find(card))
				money += (winning * GameManager.mult)
				GameManager.set_balance(money)
				explosion.play()
		moneyLabel.text = "Money: $" + str(money)
		
#line of tabs to see end of long line above, godot issue
																																										
