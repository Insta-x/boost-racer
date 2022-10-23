extends Control

onready var timerLabel = $MarginContainer/VBoxContainer/CenterContainer/TimerLabel

var start_time := 0.0 setget set_start_time


func _ready() -> void:
	GlobalSignal.connect("game_start", self, "show")
	GlobalSignal.connect("start_time", self, "set_start_time")


func _process(delta):
	timerLabel.text = str((OS.get_ticks_msec() - start_time) / 1000.0)


func set_start_time(value: float) -> void:
	start_time = value
	timerLabel.text = str((OS.get_ticks_msec() - start_time) / 1000.0)
