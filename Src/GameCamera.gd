extends Camera2D


export (NodePath) onready var following = get_node(following) as PlayerRacer

var shake_time_left := 0.0
var shake_total_time := 0.0
var strength := 0


func _ready() -> void:
	GlobalSignal.connect("player_boosted", self, "_on_player_boosted")


func _process(delta: float) -> void:
	follow(delta)
	
	shake_time_left = move_toward(shake_time_left, 0.0, delta)
	
	# Shakes
	if shake_time_left > 0.01:
		var damping := ease(shake_time_left / shake_total_time, 1.0)
		offset = Vector2(
			randi() % strength * damping,
			randi() % strength * damping
			)


func follow(delta: float) -> void:
	var target_position = following.global_position
	var velocity_offset = following.linear_velocity * 0.3
	var look_offset = Vector2.RIGHT.rotated(following.rotation) * 75.0
	target_position += look_offset
	global_position = global_position.move_toward(target_position, 800.0 * delta)
#	global_position = following.global_position
	zoom = zoom.move_toward(lerp(Vector2.ONE, Vector2(2.5, 2.5), following.linear_velocity.length() / 1000.0), 0.5 * delta)


func shake(duration : float = 0.1, power : int = 20) -> void:
	shake_time_left = duration
	shake_total_time = duration
	strength = power


func _on_player_boosted() -> void:
	shake(1.5, 13)
