extends CanvasLayer

var place = 1

onready var panel := $ColorRect
onready var ScorePanelContainer := $ColorRect/Control/CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer
onready var ScorePanelContainer2 := $ColorRect/Control/CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer2

var count := 1;

func _ready() -> void:
	GlobalSignal.connect("racer_finished",self,"_on_Racer_finished")
	GlobalSignal.connect("player_finished", self, "_on_Player_finished")
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
	if (count < 6):
		temp = ScorePanelContainer.get_child(count - 1)
	else:
		temp = ScorePanelContainer2.get_child(count - 6)
	
	temp.set_label_name(String(value))
	count+=1


func _on_Player_finished() -> void:
	var temp
	if (count < 6):
		temp = ScorePanelContainer.get_child(count - 1)
	else:
		temp = ScorePanelContainer2.get_child(count - 6)
	
	temp.set_label_name(String(0))
	count+=1
	panel.show()



func _on_RetryButton_pressed():
	pass # Replace with function body.


func _on_ExitButton_pressed():
	pass # Replace with function body.
