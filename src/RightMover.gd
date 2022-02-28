extends Node2D

"""
This object 'sweeps' right, behind the player and sits just off screen.
If the player strikes this object during play, the player dies immediately.
This object is intended to keep the player moving to the right, or die.
"""
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
