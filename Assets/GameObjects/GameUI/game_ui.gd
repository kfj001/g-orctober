extends Control

func _ready():
	if DisplayServer.is_touchscreen_available():
		$TouchControls.visible = true
	else:
		$TouchControls.visible = false
