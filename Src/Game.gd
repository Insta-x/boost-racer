extends Node


var race_time : int


func _ready() -> void:
	GlobalSignal.connect("racer_finished", self, "_on_racer_finished")
	GlobalSignal.connect("player_finished", self, "_on_player_finished")


func start() -> void:
	race_time = OS.get_ticks_msec()
	GlobalSignal.emit_signal("game_start")


func _on_racer_finished(racer_id: int) -> void:
	var finish_time := OS.get_ticks_msec() - race_time
	print(racer_id, ": ", finish_time / 1000.0)


func _on_player_finished() -> void:
	var finish_time := OS.get_ticks_msec() - race_time
	print("Player: ", finish_time / 1000.0)


func _on_StartTimer_timeout() -> void:
	start()
