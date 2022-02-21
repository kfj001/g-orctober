extends Camera2D

class_name PlayerCamera

onready var _timer = $Timer

var _shaking:bool = false setget _set_shaking

func shake():
	self._shaking = true

func _process(_delta):
	if _shaking:
		offset.y = 8 * sin(.025 * OS.get_ticks_msec())
		
func _set_shaking(value:bool):
	_shaking = value
	_timer.start()

func _on_Timer_timeout():
	self._shaking = false
	offset = Vector2.ZERO
