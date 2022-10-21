extends Area2D

class_name AreaGuider

export var target_speed := 300
onready var target_velocity : Vector2 = $Direction.position.normalized() * target_speed

func _on_AreaGuider_body_entered(body : EnemyRacer):
	body.target_velocity = self.target_velocity
