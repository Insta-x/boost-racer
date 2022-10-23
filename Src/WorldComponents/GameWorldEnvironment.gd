extends WorldEnvironment


const low_quality_tres := preload("res://Assets/low_quality_environment.tres")


func _ready() -> void:
	if GlobalSettings.low_quality_mode:
		environment = low_quality_tres
