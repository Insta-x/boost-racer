extends Control

func _on_PlayButton_pressed():
	get_tree().change_scene("res://Src/Game.tscn")


func _on_ExitButton_pressed():
	get_tree().quit()


func _on_TutorialButton_pressed():
	get_tree().change_scene("res://Src/SampleWorld.tscn")
