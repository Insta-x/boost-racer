extends Area2D


func _on_FinishArea2D_body_entered(body: Racer) -> void:
	if body.racer_id == 0:
		GlobalSignal.emit_signal("player_finished")
	else:
		GlobalSignal.emit_signal("racer_finished", body.racer_id)
