extends Control

"""
Visual indickator element, reminding the user to "continue moving" to the right.
"""
class_name GetMoving

var _time = 0.0

func _process(delta):
	_time += delta
	($shaft.material  as ShaderMaterial).set_shader_parameter("time_var", _time)

func _do_display():
	$AutohideTimer.start()
	$AnimationPlayer.play("active")
	show();
	
func _do_hide():
	$AutohideTimer.stop()
	$AnimationPlayer.play("inactive")
	hide();

func _on_AutohideTimer_timeout():
	hide()
