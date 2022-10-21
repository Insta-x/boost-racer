extends RigidBody2D


var thrusting := false
var turning := 0
var boosting := false

var thrust_force := 100.0
var turn_speed := PI * 3 / 2
var boost_force := 300.0
var max_speed := 300.0
var max_boost_speed := 1000.0


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	if thrusting:
		applied_force = Vector2.RIGHT.rotated(rotation) * thrust_force
	
	angular_velocity = turning * turn_speed
	
	if boosting:
		applied_force = Vector2.RIGHT.rotated(rotation) * boost_force
		
		if linear_velocity.length() > max_boost_speed:
			linear_velocity = linear_velocity.normalized() * max_boost_speed
		
	elif linear_velocity.length() > max_speed:
		linear_velocity = linear_velocity.normalized() * max_speed
