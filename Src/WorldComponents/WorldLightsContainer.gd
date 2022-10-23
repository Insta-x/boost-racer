extends Node2D


func _ready() -> void:
	if GlobalSettings.low_quality_mode:
		hide()
