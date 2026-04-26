extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("startCountdown")

func start_game():
	GameManager.start_game()
