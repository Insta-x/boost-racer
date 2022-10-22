extends Racer

onready var BoostChargeDoneSFX := $BoostChargeDoneSFX

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("boost"):
		boost()


func _physics_process(delta: float) -> void:
	self.thrusting = Input.is_action_pressed("thrust")
	turning = Input.get_action_strength("turn_right") - Input.get_action_strength("turn_left")
	braking = Input.is_action_pressed("brake")
	
func _on_DashCooldownTimer_timeout() -> void:
	can_boost = true
	boost_charge_particles.emitting = false
	BoostChargeDoneSFX.play()
