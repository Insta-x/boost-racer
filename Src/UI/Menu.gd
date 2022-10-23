extends Control


onready var music_button := $MarginContainer/HBoxContainer/MusicButton


func _ready() -> void:
	music_button.pressed = not AudioServer.is_bus_mute(1)


func _on_PlayButton_pressed():
	get_tree().change_scene("res://Src/Game.tscn")


func _on_ExitButton_pressed():
	get_tree().quit()


func _on_TutorialButton_pressed():
	get_tree().change_scene("res://Src/SampleWorld.tscn")


func _on_MusicButton_toggled(button_pressed: bool) -> void:
	AudioServer.set_bus_mute(1, not button_pressed)
