extends Sprite

"""
This object provides the logic that drives the on-screen joystick. It maps
the motion of the 'stick' on screen to up, down, left and right axis movement.
"""

const _deadzone:int = 50
onready var size = texture.get_size() * global_scale
var _is_dragging:bool = false

func _ready():
	visible = OS.has_touchscreen_ui_hint()

func _input(event:InputEvent):
	if event is InputEventScreenDrag:
		var touch_event = event as InputEventScreenDrag
		if _is_dragging:
			var local_touch_event = to_local(touch_event.position)
			# todo: adjust the position by normalization and scaling if outside the outer radius
			if !is_within_bounds(touch_event.position):
				local_touch_event = to_local(touch_event.position).normalized() * size
			$joystick_nub.position = local_touch_event
			transmit_input(local_touch_event)
	elif event is InputEventScreenTouch and (event as InputEventScreenTouch).pressed:
		var touch_event = event as InputEventScreenTouch
		if is_within_bounds(touch_event.position):
			_is_dragging = true
	elif event is InputEventScreenTouch and !(event as InputEventScreenTouch).pressed:
		$joystick_nub.position = Vector2.ZERO
		transmit_input(Vector2.ZERO)
		_is_dragging = false

func is_within_bounds(point:Vector2)->bool:
	var local_point = to_local(point)
	var distance = local_point.distance_to(Vector2.ZERO)
	return  distance <= size.x
	
func transmit_input(offset:Vector2):
	if offset.x - _deadzone > 0:
		Input.action_press("move_right")
	else:
		Input.action_release("move_right")
	if offset.x + _deadzone < 0:
		Input.action_press("move_left")
	else:
		Input.action_release("move_left")
	if offset.y - _deadzone > 0:
		Input.action_press("move_down")
	else:
		Input.action_release("move_down")
	if offset.y + _deadzone < 0:
		Input.action_press("move_up")
	else:
		Input.action_release("move_up")
		
	if offset.x == 0:
		Input.action_release("move_left")
		Input.action_release("move_right")
		Input.action_release("move_up")
		Input.action_release("move_down")
