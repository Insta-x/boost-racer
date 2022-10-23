extends TextureRect

export(NodePath) var finish_area
export(NodePath) var player
export(Vector2) var offset := Vector2(100,0)


onready var finish_node : Area2D = get_node(finish_area)
onready var player_node : RigidBody2D = get_node(player)

var size := Vector2(40,75)
var anim_time := 0.4
var temp := 0.0
var maju := false
var game_started := false

func _ready() -> void:
	GlobalSignal.connect("game_start", self, "start")


func _physics_process(delta):
	if (temp < anim_time):
		temp+= delta
	else:
		temp = 0.0
		maju = !maju
		
	var dir = (finish_node.global_position - player_node.global_position)
	if (abs(dir.x) < (get_viewport_rect().size.x + offset.x)/2) and abs(dir.y) <(get_viewport_rect().size.y)/2:
		hide()
	elif (game_started):
		show()
		dir.normalized()
		var pos = Vector2(((get_viewport_rect().size.x - size.x)/2), (get_viewport_rect().size.y - size.y)/2)
		pos += offset.rotated(dir.angle())
		if (maju):
			pos+= offset.rotated(dir.angle())/2
		set_rotation(dir.angle())
		set_position(pos)

func start():
	game_started = true
