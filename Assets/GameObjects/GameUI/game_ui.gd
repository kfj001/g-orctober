extends Control

func _ready():
	if DisplayServer.is_touchscreen_available():
		$TouchControls.visible = true
	else:
		$TouchControls.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
