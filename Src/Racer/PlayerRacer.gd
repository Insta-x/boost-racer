extends Racer


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("boost"):
		boost()


func _physics_process(delta: float) -> void:
	thrusting = Input.is_action_pressed("thrust")
	turning = Input.get_action_strength("turn_right") - Input.get_action_strength("turn_left")
	braking = Input.is_action_pressed("brake")
