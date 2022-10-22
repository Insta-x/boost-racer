extends Node


var race_time : int


func _ready() -> void:
	GlobalSignal.connect("racer_finished", self, "_on_racer_finished")
	GlobalSignal.connect("player_finished", self, "_on_player_finished")
	start()


func start() -> void:
	race_time = OS.get_ticks_msec()


func _on_racer_finished(racer_id: int) -> void:
	var finish_time := OS.get_ticks_msec() - race_time
	print(racer_id, ": ", finish_time / 1000.0)


func _on_player_finished() -> void:
	var finish_time := OS.get_ticks_msec() - race_time
	print("Player: ", finish_time / 1000.0)
