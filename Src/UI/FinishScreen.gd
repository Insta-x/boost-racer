extends CanvasLayer

var place = 1

onready var panel := $ColorRect
onready var ScorePanelContainer := $ColorRect/Control/CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer
onready var ScorePanelContainer2 := $ColorRect/Control/CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer2
onready var personal_best_label := $ColorRect/Control/CenterContainer/VBoxContainer/HBoxContainer3/PersonalBestLabel

var count := 1;
var list_racer_id := []
var start_time := 0.0
var best_time : int = 10000000000
var player_time : int

func _ready() -> void:
	GlobalSignal.connect("racer_finished",self,"_on_Racer_finished")
	GlobalSignal.connect("player_finished", self, "_on_Player_finished")
	GlobalSignal.connect("start_time", self, "set_start_time")
	
	var loadf := File.new()
	if loadf.file_exists("user://time.sav"):
		loadf.open("user://time.sav", File.READ)
		best_time = loadf.get_64()
	loadf.close()
	
	var temp = 1;
	for child in ScorePanelContainer.get_children():
		child.set_label_ranking(temp)
		temp+= 1
	for child in ScorePanelContainer2.get_children():
		child.set_label_ranking(temp)
		temp+= 1
	panel.hide()
	

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
	var finish_time := OS.get_ticks_msec() - start_time
	temp.set_label_time(finish_time)
	count+=1
	
	if value == 0:
		player_time = finish_time


func _on_Player_finished() -> void:
	_on_Racer_finished(0)
	
	var savef := File.new()
	if player_time < best_time:
		best_time = player_time
		savef.open("user://time.sav", File.WRITE)
		savef.store_64(best_time)
	savef.close()
	
	print(best_time)
	var milisecond := best_time%1000
	var second := (best_time/1000)%60
	var minute := (best_time/60000)%60
	personal_best_label.text = "%02d:%02d.%03d" % [minute, second, milisecond]
	panel.show()


func set_start_time(value: float) -> void:
	start_time = value


func _on_RetryButton_pressed():
	get_tree().reload_current_scene()


func _on_ExitButton_pressed():
	get_tree().change_scene("res://Src/UI/Menu.tscn")
