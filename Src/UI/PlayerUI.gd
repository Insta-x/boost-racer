extends Control


onready var timerLabel = $MarginContainer/VBoxContainer/CenterContainer/TimerLabel
onready var rank_label := $MarginContainer/VBoxContainer/RankingLabel

export (Array, NodePath) var racers := []
export (NodePath) var finish_line

var start_time := 0.0 setget set_start_time
var finish_line_pos : Vector2


func _ready() -> void:
	GlobalSignal.connect("game_start", self, "show")
	GlobalSignal.connect("start_time", self, "set_start_time")
	GlobalSignal.connect("player_finished", self,  "_on_player_finished")
	
	finish_line_pos = get_node(finish_line).global_position
	
	for i in range(racers.size()):
		racers[i] = get_node(racers[i])


func _process(delta: float):
	timerLabel.text = str((OS.get_ticks_msec() - start_time) / 1000.0)


func _physics_process(delta: float) -> void:
	var rank := 1
	var player_dist : float = racers[0].global_position.distance_to(finish_line_pos)
	
	if racers[0].reached_finish:
		return
	
	for i in range(1, racers.size()):
		if racers[i].global_position.distance_to(finish_line_pos) < player_dist or racers[i].reached_finish:
			rank += 1
	
	rank_label.text = str(rank)
	
	match(rank):
		1:
			rank_label.text += "st"
		2:
			rank_label.text += "nd"
		3:
			rank_label.text += "rd"
		_:
			rank_label.text += "th"


func set_start_time(value: float) -> void:
	start_time = value
	timerLabel.text = str((OS.get_ticks_msec() - start_time) / 1000.0)


func _on_player_finished() -> void:
	hide()
