extends TextureRect

export(NodePath) var finish_area
export(NodePath) var player
export(Vector2) var offset := Vector2(100,0)


onready var finish_node : Area2D = get_node(finish_area)
onready var player_node : RigidBody2D = get_node(player)

var size := Vector2(100,150)


func _ready() -> void:
	GlobalSignal.connect("game_start", self, "show")


func _physics_process(delta):
	var dir = (finish_node.global_position - player_node.global_position)
	if (abs(dir.x) < (get_viewport().size.x + offset.x)/2) and abs(dir.y) <(get_viewport().size.y)/2:
		return
	
	dir.normalized()
	var pos = Vector2(((get_viewport().size.x - size.x)/2), (get_viewport().size.y - size.y)/2)
	pos += offset.rotated(dir.angle())
	set_rotation(dir.angle())
	set_position(pos)
	
