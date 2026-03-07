extends RigidBody2D



#applying zero force (or any force) here makes
#collisons work with drag. Huh. May need to be changed later
func _physics_process(delta: float) -> void:
	apply_central_force(Vector2(0, 0))
