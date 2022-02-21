extends Node2D
class_name JumpWave

func trigger():
	$AnimationPlayer.play("Active")
	
func _animations_completed(animation_name:String):
	if animation_name != "Default":
		$AnimationPlayer.play("Default")


func _on_WaveFieldEffect_body_entered(body:Node2D):
	if body is EnemyBase:
		var enemy = body as EnemyBase
		enemy.blowback(150)
