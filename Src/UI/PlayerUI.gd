extends Control

onready var timerLabel = $MarginContainer/VBoxContainer/CenterContainer/TimerLabel

var timer := 0.0

func _process(delta):
	timer += stepify(delta,0.001)
	timerLabel.text = String(timer)
