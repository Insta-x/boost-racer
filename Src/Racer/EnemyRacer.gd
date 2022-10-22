extends Racer

class_name EnemyRacer

var target_velocity := Vector2.ZERO
var adjust_velocity := Vector2.ZERO

const ROT := 0.15
const CEKDEG := deg2rad(30) # raycast degree

var canboost := 0

var guiders := []
var turning_stabilizer := 0.0
var turn_history := []

func _ready():
	pass # Replace with function body.

func _physics_process(delta:float) -> void:
	if len(guiders) > 0:
		target_velocity = Vector2.ZERO
		for x in guiders: target_velocity += x.target_velocity
		target_velocity /= len(guiders)
	avoid_wall()
	actions()
	debug()
	if thrusting and not boosting: boost()

func actions() -> void:
	# kalo ga searah, searahin dulu
	braking = false
	#boosting = true
	$Target.cast_to = (target_velocity + adjust_velocity - linear_velocity) #debugging purpose
	var target_rotation := (target_velocity + adjust_velocity - linear_velocity).angle()
	var drot := (target_rotation - rotation)
	if drot < 0: drot += PI * 2
	
	# turning
	if drot < PI: turning_stabilizer = 1 #min(1,  drot)
	else: turning_stabilizer = -1 #max(-1, -(2*PI - drot))
	if drot < deg2rad(3) or drot > deg2rad(360-3): turning_stabilizer = 0
	turning = (turning * (1-ROT) + turning_stabilizer * ROT)
	
	# braking
	var vrot = linear_velocity.angle_to(target_velocity + adjust_velocity)
	braking = (deg2rad(45) < vrot and vrot < deg2rad(360-45)) and linear_velocity.length() > 50 or linear_velocity.length() - (target_velocity + adjust_velocity).length() > -30
	
	# boosting
	#boosting = false
	#if canboost > 0: 
	#	if vrot < deg2rad(15) or vrot > deg2rad(360-15):
	#		boost()
			
	# thrusting
	if PI/2 < deg2rad(90-45) and drot < deg2rad(270+45): 
		thrusting = false
		return
	
	# itung difference velocity
	var d = target_velocity - linear_velocity
	if target_velocity.dot(d) > 0 and d.angle_to(Vector2.RIGHT.rotated(rotation)) < PI / 4:
		thrusting = true
	else:
		thrusting = false
	

onready var raycastL := $RayCastLeft
onready var raycastR := $RayCastRight
onready var raycastF := $RayCastFront
onready var raycastP := $RayCastPredict

func avoid_wall() -> void:
	raycastL.global_rotation = 0
	raycastR.global_rotation = 0
	raycastF.global_rotation = 0
	raycastP.global_rotation = 0
	$Target.global_rotation = 0
	adjust_velocity = Vector2.ZERO
	var ADJRATE = pow(linear_velocity.length(), 0.8) / thrust_force
	
	raycastL.cast_to = linear_velocity.rotated(-CEKDEG) * ADJRATE + Vector2.RIGHT.rotated(rotation - CEKDEG) * 40
	raycastR.cast_to = linear_velocity.rotated(CEKDEG) * ADJRATE + Vector2.RIGHT.rotated(rotation + CEKDEG) * 40
	raycastF.cast_to = linear_velocity * ADJRATE 
	raycastP.cast_to = linear_velocity * ADJRATE
	if raycastL.is_colliding():
		adjust_velocity += linear_velocity.rotated(PI/2).normalized() * (raycastL.cast_to.length() - raycastL.get_collision_point().distance_to(global_position))
	if raycastR.is_colliding():
		adjust_velocity += linear_velocity.rotated(-PI/2).normalized() * (raycastR.cast_to.length() - raycastR.get_collision_point().distance_to(global_position))
	if raycastP.is_colliding():
		adjust_velocity += raycastP.get_collider().target_velocity * 0.5 - target_velocity * 0.5
	if raycastF.is_colliding():
		adjust_velocity += raycastF.get_collision_normal().normalized() * (linear_velocity.length() - raycastF.get_collision_point().distance_to(global_position))
		print(raycastF.get_collision_normal())

func debug() -> void:
	$Label.text = str(turning)
	if thrusting: $Label.text += " Thrust "
	if braking: $Label.text += "Brake "
	if boosting: $Label.text += "Boost "
