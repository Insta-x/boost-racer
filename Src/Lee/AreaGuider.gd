extends Area2D

class_name AreaGuider

export var target_speed := 750
onready var target_velocity : Vector2 = $Direction.position.normalized() * target_speed

func _on_AreaGuider_body_entered(body : EnemyRacer):
	#body.target_velocity = self.target_velocity
	body.guiders.append(self)
	body.raycastP.add_exception(self)

func _on_AreaGuider_body_exited(body):
	body.guiders.erase(self)
	body.raycastP.remove_exception(self)
