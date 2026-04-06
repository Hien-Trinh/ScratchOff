extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("Pause"):
		get_tree().paused = false
		self.hide()
		set_process(false)
