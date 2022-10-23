extends Node2D

func _ready():
	GlobalSignal.emit_signal("game_start")

func _input(event):
	if (event.is_action_pressed("ui_cancel")):
		get_tree().change_scene("res://Src/UI/Menu.tscn")
