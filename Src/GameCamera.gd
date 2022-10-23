extends Camera2D


export (NodePath) onready var following = get_node(following) as PlayerRacer

var shake_time_left := 0.0
var shake_total_time := 0.0
var strength := 0


func _ready() -> void:
	GlobalSignal.connect("player_boosted", self, "_on_player_boosted")


func _process(delta: float) -> void:
	global_position = following.global_position
	
	shake_time_left = move_toward(shake_time_left, 0.0, delta)
	
	# Shakes
	if shake_time_left > 0.01:
		var damping := ease(shake_time_left / shake_total_time, 1.0)
		offset = Vector2(
			randi() % strength * damping,
			randi() % strength * damping
			)


func shake(duration : float = 0.1, power : int = 20) -> void:
	shake_time_left = duration
	shake_total_time = duration
	strength = power


func _on_player_boosted() -> void:
	shake(1.5, 8)
