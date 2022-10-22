extends Area2D

func _ready():
	pass


func _on_BoostGuider_body_entered(body):
	body.canboost += 1


func _on_BoostGuider_body_exited(body):
	body.canboost -= 1
