extends Control

func _on_PlayButton_pressed():
	get_tree().change_scene("res://Src/GameWorld.tscn")

func _on_TextureButton_pressed():
	get_tree().quit()
