extends Node2D

class_name RightMover

export(int, 20, 150) var move_rate:int=200

func _process(delta):
	position.x += delta*move_rate


func _on_Timer_timeout():
	if Global.player_health > 0:
		Global.player_score += 250


func _on_Area2d_body_entered(body):
	if body.name == "Player":
		Global.player_health = 0
	elif body is EnemyBase:
		body.queue_free()
