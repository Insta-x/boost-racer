extends CanvasLayer

var place = 1

onready var panel := $ColorRect
onready var ScorePanelContainer := $ColorRect/Control/CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer
onready var ScorePanelContainer2 := $ColorRect/Control/CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer2

var count := 1;
var list_racer_id := []
var start_time := 0.0

func _ready() -> void:
	GlobalSignal.connect("racer_finished",self,"_on_Racer_finished")
	GlobalSignal.connect("player_finished", self, "_on_Player_finished")
	GlobalSignal.connect("start_time", self, "set_start_time")
	
	var temp = 1;
	for child in ScorePanelContainer.get_children():
		child.set_label_ranking(temp)
		temp+= 1
	for child in ScorePanelContainer2.get_children():
		child.set_label_ranking(temp)
		temp+= 1
	panel.hide()
	pass
	

func _on_Racer_finished(var value : int) -> void:
	var temp
	if (list_racer_id.has(value)):
		return
	list_racer_id.append(value)
	if (count < 6):
		temp = ScorePanelContainer.get_child(count - 1)
	elif (count < 11):
		temp = ScorePanelContainer2.get_child(count - 6)
	else : return
	temp.set_label_name(str(value))
	temp.set_label_time((OS.get_ticks_msec() - start_time))
	count+=1


func _on_Player_finished() -> void:
	_on_Racer_finished(0)
	panel.show()

func set_start_time(value: float) -> void:
	start_time = value


func _on_RetryButton_pressed():
	get_tree().reload_current_scene()


func _on_ExitButton_pressed():
	get_tree().change_scene("res://Src/UI/Menu.tscn")
