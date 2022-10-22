extends RigidBody2D

class_name Racer

onready var thrusting_particles := $ThrustingParticles
onready var boosting_particles := $BoostingParticles
onready var dash_cooldown_timer := $DashCooldownTimer
onready var boost_charge_particles := $BoostChargeParticles
onready var thrusting_sfx := $ThrustingSFX
onready var boosting_sfx := $BoostingSFX

var thrusting := false setget set_thrusting
var turning := 0.0
var braking := false
var boosting := false setget set_boosting

var thrust_force := 200.0
var turn_speed := PI * 3 / 2
var boost_force := 400.0
var max_speed := 500.0
var max_boost_speed := 1000.0
var can_boost := true


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	if thrusting:
		applied_force = Vector2.RIGHT.rotated(rotation) * thrust_force
	
	angular_velocity = turning * turn_speed * (0.5 if thrusting or boosting else 1.0)
	
	if boosting:
		applied_force = Vector2.RIGHT.rotated(rotation) * boost_force
		
		if linear_velocity.length() > max_boost_speed:
			linear_velocity = linear_velocity.normalized() * max_boost_speed
		
	elif linear_velocity.length() > max_speed:
		linear_velocity = linear_velocity.move_toward(linear_velocity.normalized() * max_speed, 5.0)
	
	if braking:
		linear_velocity = linear_velocity.move_toward(Vector2.ZERO, 5.0)
	
	if not (thrusting or boosting):
		applied_force = Vector2.ZERO


func boost() -> void:
	if not can_boost:
		return
	
	can_boost = false
	self.boosting = true
	yield(get_tree().create_timer(1.5), "timeout")
	self.boosting = false
	boost_charge_particles.emitting = true
	
	dash_cooldown_timer.start()


func set_thrusting(value: bool) -> void:
	thrusting = value
	thrusting_particles.emitting = thrusting
	if (!thrusting_sfx.playing && thrusting):
		thrusting_sfx.play()
	elif(!thrusting):
		thrusting_sfx.stop()
	
func set_boosting(value: bool) -> void:
	boosting = value
	boosting_particles.emitting = boosting
	if (boosting):
		boosting_sfx.play()



func _on_DashCooldownTimer_timeout() -> void:
	can_boost = true
	boost_charge_particles.emitting = false
