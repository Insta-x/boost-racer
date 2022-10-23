extends Racer

class_name EnemyRacer

onready var body_2 := $Polygon2D
onready var body_1 := $Polygon2D2


var target_velocity := Vector2.ZERO
var adjust_velocity := Vector2.ZERO
var guideID := -1

var next := -1
var nextnext := -1

const ROT := 0.15
const CEKDEG := deg2rad(30) # raycast degree

var canboost := 0

var turning_stabilizer := 0.0
var turn_history := []

var targetpos := Vector2.ZERO
var targetspeed := 750
func _ready():
	pass # Replace with function body.

func calc_target_velocity():
	if next == -1: return
	targetpos = get_parent().arr[next].position + (get_parent().arr[nextnext].position - get_parent().arr[next].position).normalized() * 50 - linear_velocity.normalized() * 50
	target_velocity = (targetpos - position).normalized() * targetspeed#position.distance_to(targetpos))
	#if position.distance_to(targetpos) / targetspeed < 0.5:
	#	target_velocity *= position.distance_to(targetpos) / targetspeed 
		
func _physics_process(delta:float) -> void:
	calc_target_velocity()
	avoid_wall()
	actions()
	#debug()

func actions() -> void:
	# kalo ga searah, searahin dulu
	braking = false
	#$Target.cast_to = target_velocity + adjust_velocity #debugging purpose
	$Target.cast_to = target_velocity + adjust_velocity
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
	if vrot < 0: vrot += 2 * PI
	braking = (deg2rad(30) < vrot and vrot < deg2rad(360-30)) and linear_velocity.length() > 150 #or linear_velocity.length() - (target_velocity + adjust_velocity).length() > -30
	
	if (drot < deg2rad(15) or drot > deg2rad(360-15)) and not boosting and targetpos.distance_to(position) > 500:
		boost()
		
	thrusting = drot < deg2rad(45) or drot > deg2rad(360-45)
	thrusting_particles.emitting = thrusting


onready var raycastL := $RayCastLeft
onready var raycastR := $RayCastRight
onready var raycastF := $RayCastFront

func avoid_wall() -> void:
	raycastL.global_rotation = 0
	raycastR.global_rotation = 0
	raycastF.global_rotation = 0
	$Target.global_rotation = 0
	adjust_velocity = Vector2.ZERO
	var ADJRATE = pow(linear_velocity.length(), 0.8) / thrust_force
	
	raycastL.cast_to = linear_velocity.rotated(-CEKDEG) * ADJRATE * 1.2 + Vector2.RIGHT.rotated(rotation - CEKDEG) * 40
	raycastR.cast_to = linear_velocity.rotated(CEKDEG) * ADJRATE * 1.2 + Vector2.RIGHT.rotated(rotation + CEKDEG) * 40
	raycastF.cast_to = linear_velocity * ADJRATE  * 1.2 + Vector2.RIGHT * 40
	if raycastL.is_colliding():
		adjust_velocity += linear_velocity.rotated(PI/2).normalized() * (raycastL.cast_to.length() - raycastL.get_collision_point().distance_to(global_position))
	if raycastR.is_colliding():
		adjust_velocity += linear_velocity.rotated(-PI/2).normalized() * (raycastR.cast_to.length() - raycastR.get_collision_point().distance_to(global_position))
	#if raycastP.is_colliding():
	#	adjust_velocity += raycastP.get_collider().target_velocity * 0.5 - target_velocity * 0.5
	if raycastF.is_colliding():
		adjust_velocity += raycastF.get_collision_normal().normalized() * (linear_velocity.length() - raycastF.get_collision_point().distance_to(global_position))
		if linear_velocity.length() < 20:
			adjust_velocity += raycastF.get_collision_normal().normalized() * 6000
	var d = linear_velocity.angle_to(targetpos-position)
	if (d < deg2rad(45) or d > deg2rad(360-45)) and linear_velocity.length() > 50:
		if (targetpos-position).length() / linear_velocity.length() / cos(d) < ADJRATE:
			adjust_velocity += (get_parent().arr[nextnext].position - position).normalized() * linear_velocity.length() * 0.5 - target_velocity * 0.5


func debug() -> void:
	$Label.text = str(turning)
	if thrusting: $Label.text += " Thrust "
	if braking: $Label.text += "Brake "
	if boosting: $Label.text += "Boost "
