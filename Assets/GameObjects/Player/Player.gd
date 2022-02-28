extends KinematicBody2D

"""
Represents the player's logic. Handles input and hitbox tracking.
"""
class_name Player

export var horizontal_movement_speed:=250
export var vertical_movement_speed:=150

enum PlayerStates {NORMAL, STUN_LOCKED, ATTACKING, JUMP_ATTACKING}
enum VisualStates {FACING_LEFT, FACING_RIGHT}

signal TooLeft
signal DoneDieing

onready var _orc_sprite = $Orc
onready var _orc_collider = $CollisionShape2D
onready var _animation_player =$AnimationPlayer

var _camera:PlayerCamera

var _current_state:int
var _current_visual_state:int
var idle_to_use:="idle"
var walk_to_use:="walk"
var attack_to_use="attack"
var jump_attack_to_use = "jump_attack"
var _begun_dying:bool = false
var _autopressing_right:bool = false

func _ready():
	_camera = get_tree().current_scene.find_node("PlayerCamera")
	_current_state = PlayerStates.NORMAL
	_current_visual_state = VisualStates.FACING_RIGHT
# warning-ignore:return_value_discarded
	Global.connect("PlayerHurt", self, "_on_player_hurt")

func do_player_walkon():
	_current_state = PlayerStates.STUN_LOCKED
	_animation_player.play("walking_on")

func _physics_process(delta):
	_handle_input(delta)
	_check_sweep(delta)

func _check_sweep(_delta:float):
	if Global.player_health > 0 and get_global_transform_with_canvas().get_origin().x < 200:
		emit_signal("TooLeft")
			
func _handle_input(delta:float):
	var not_moving_H:bool
	var not_moving_V:bool
	
	match _current_state:
		PlayerStates.NORMAL:
			if Input.is_action_pressed("move_left"):
				if _can_move_left():
					if _current_visual_state == VisualStates.FACING_RIGHT:
						_flip_player()
					_move_in(delta, horizontal_movement_speed, Vector2.LEFT)
			elif Input.is_action_pressed("move_right"):
				if _can_move_right():
					_move_right(delta)
			else:
				not_moving_H=true
			if Input.is_action_pressed("move_up") and _can_move_up():
				_move_in(delta, vertical_movement_speed, Vector2.UP)
			elif Input.is_action_pressed("move_down") and _can_move_down():
				_move_in(delta, vertical_movement_speed, Vector2.DOWN)
			else:
				not_moving_V=true
			if not_moving_H and not_moving_V:
				_animation_player.play(idle_to_use)
				
			if Input.is_action_just_pressed("attack"):
				_handle_attack()			
			elif Input.is_action_just_pressed("jump_attack"):
				_handle_jump_attack()
		PlayerStates.JUMP_ATTACKING:
			continue
		PlayerStates.ATTACKING:
			yield(_animation_player, "animation_finished")
			_current_state=PlayerStates.NORMAL
			continue
		PlayerStates.STUN_LOCKED:
			continue
			
func _flip_player():
	_current_visual_state = !_current_visual_state
	_orc_sprite.scale.x=-_orc_sprite.scale.x
	_orc_collider.scale.x=-_orc_collider.scale.x

func _move_in(delta:float, speed:float, direction:Vector2):
# warning-ignore:return_value_discarded
	move_and_collide(direction*speed*delta)
	_animation_player.play(walk_to_use)

func _can_move_up()->bool:
	return get_global_transform().get_origin().y > 750
	
func _can_move_down()->bool:
	return get_global_transform().get_origin().y < 1080
	
func _can_move_left()->bool:
	return true

func _move_right(delta):
	if _current_visual_state==VisualStates.FACING_LEFT:
		_flip_player()
	_move_in(delta, horizontal_movement_speed, Vector2.RIGHT)
	
func _can_move_right()->bool:
	return true

func _handle_attack():
	_current_state=PlayerStates.ATTACKING
	_animation_player.play(attack_to_use)

func _handle_jump_attack():
	_current_state=PlayerStates.JUMP_ATTACKING
	_animation_player.play(jump_attack_to_use)

func _on_player_hurt(new_health:int):
	if !_begun_dying:
		_current_state = PlayerStates.STUN_LOCKED
		_animation_player.play("stunned")
		if new_health <= 0 and ! _begun_dying:
			_begun_dying = true
			_animation_player.play("dying")
			
func die():
	emit_signal("DoneDieing")
	queue_free()

func shake_camera():
	if _camera != null:
		_camera.shake()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name=="stunned":
		_current_state = PlayerStates.NORMAL
		_animation_player.play(idle_to_use)
	elif anim_name == "jump_attack":
		_current_state = PlayerStates.NORMAL
		_animation_player.play(idle_to_use)
	elif anim_name == "walking_on":
		_current_state = PlayerStates.NORMAL
		_animation_player.play("idle")
