extends Label

export(NodePath) var TimerPath
export(NodePath) var SFXPath

onready var timer := get_node(TimerPath)
onready var SFX := get_node(SFXPath)

var countdown := 3

func _process(delta):
	var temp = ceil(timer.time_left)
	if (temp <= 0):
		text = "GO"
		yield(get_tree().create_timer(2.0), "timeout")
		visible = false
		return
	if (temp <= countdown):
		if (!SFX.playing):
			SFX.play()
		if (!visible):
			visible = true
		text = str(temp)
	
	
