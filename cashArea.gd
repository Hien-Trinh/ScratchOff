extends Sprite2D


@export var moneyLabel : Label
@onready var cashSpace = $Area2D
var money = 0
var winning = 0

func _process(delta: float) -> void:
	if Input.is_action_just_released("Click") && get_global_mouse_position().x < 350 && get_global_mouse_position().y > 600 && cashSpace.has_overlapping_bodies():
		var labelArray = cashSpace.get_overlapping_bodies()
		for card in labelArray:
			winning = card.card_data.card_value
			card.free()
		money = money + winning
		moneyLabel.text = "Money: " + str(money)
		
#line of tabs to see end of long line above, godot issue
																																										
