extends Racer

class_name EnemyRacer

var target_velocity := Vector2.ZERO

const ROT := 1.6
func _ready():
	pass # Replace with function body.

func _physics_process(delta:float) -> void:
	actions()

func actions() -> void:
	# kalo ga searah, searahin dulu
	braking = false
	var target_rotation := target_velocity.angle()
	var drot := (target_rotation - rotation)
	if drot < 0: drot += PI * 2
	if drot < PI: turning = min(1,  ROT * drot / PI)
	else: turning = max(-1, -ROT * (2*PI - drot) / PI)
	$Label.text = str(drot)
	print(turning, drot)
	if PI/2 < drot and drot < PI*3/2: 
		thrusting = false
		braking = true
		return
	
	# itung difference velocity
	var d = target_velocity - linear_velocity
	if target_velocity.dot(d) > 0 and d.angle_to(Vector2.RIGHT.rotated(rotation)) < PI / 4:
		thrusting = true
	else:
		thrusting = false
