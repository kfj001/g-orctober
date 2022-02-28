extends TextureRect

"""
Visual indickator element, reminding the user to "continue moving" to the right.
"""
class_name GetMoving

var _time = 0.0

func _process(delta):
	_time += delta
	($shaft.material  as ShaderMaterial).set_shader_param("time_var", _time)

func show():
	$AutohideTimer.start()
	$AnimationPlayer.play("active")
	
func hide():
	$AutohideTimer.stop()
	$AnimationPlayer.play("inactive")

func _on_AutohideTimer_timeout():
	hide()
