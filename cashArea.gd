extends Sprite2D

@export var moneyLabel : Label
@onready var cashSpace = $Area2D

var money = 0

func _process(delta: float) -> void:
#	always has overlapping bodies atm, wood texture?
	print(cashSpace.has_overlapping_bodies())
	if Input.is_action_just_released("Click") && get_global_mouse_position().x < 350 && get_global_mouse_position().y > 600:
		money = money + 1
		moneyLabel.text = "Money: " + str(money)
