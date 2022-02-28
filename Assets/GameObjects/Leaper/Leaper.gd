extends EnemyBase

"""
Game logic for The Leaper - one of the Zombie gnome enemies in this game.
"""

onready var _hit_shader:ShaderMaterial = $LeaperRoot.material
onready var _flash_timer:Timer = $FlashTimer
onready var _gusher:GnomeGusher = $LeaperRoot/GnomeGusher
var _player_ref:Node2D
var _can_do_damage:bool = true
var _hit_points:int = 100 setget _hit_points_set
var _timer:float = 0
const _leap_distance:int = 250

func _on_node_removed(node:Node):
	if (node == _player_ref):
		_player_ref = null
		#$AnimationPlayer.play("Idle")
		#$LeapTimer.stop()

func _hit_points_set(value:int):
	if value < _hit_points:
		_timer = 0
		_hit_shader.set_deferred("shader_param/hurt_effect_blend", 1)
		_flash_timer.start()
		_gusher.start()
	_hit_points = value
	$HPBar.value = _hit_points
	
	#start_blinking()
	if _hit_points <= 0:
		$LeapTimer.stop()
		$AnimationPlayer.play("Dead")
		$HPBar.set_deferred("visible", false)
		Global.player_score += 1000
		$LeaperRoot/PerceptualRadius/CollisionShape2D.set_deferred("disabled", true)
		$LeaperRoot/AttackArea/AttackShape.set_deferred("disabled", true)
		$CollisionShape2D.set_deferred("disabled", true)
		$HitDetector/CollisionShape2D2.set_deferred("disabled", true)
		$CleanupTimer.start()
		
func _ready():
	$HPBar.max_value = 100
	
func _process(delta):
	_timer += delta
	_hit_shader.set_deferred("shader_param/time", _timer)
	if _hit_points > 0 and _player_ref != null:
		if _player_ref.position.x > position.x:
			$LeaperRoot.scale.x = -1
		else:
			$LeaperRoot.scale.x = 1

func _on_LeapTimer_timeout():
	$AnimationPlayer.play("Leap")

func get_facing_scale()->float:
	return $LeaperRoot.scale.x

func move_forward():
	if _player_ref != null:
		var player_pos_global = _player_ref.position
		var x_move_coord = player_pos_global.x + (100 * get_facing_scale())
		if abs(position.x-x_move_coord) > _leap_distance:
			x_move_coord = position.x - (_leap_distance * get_facing_scale())
		var y_move_distance = position.y
		_get_tweener().interpolate_property(self, "position", null, Vector2(x_move_coord, y_move_distance), .7, Tween.TRANS_LINEAR)
		_get_tweener().start()
	
func stop():
	_get_tweener().stop_all()

func _on_PerceptualRadius_body_entered(body:Node):
	if _player_ref == null and body != null and body.name == "Player":
		_player_ref = body
		$LeapTimer.start()

func _on_AttackArea_body_entered(_body):
	if _can_do_damage:
		_can_do_damage = false
		Global.player_health -= 10
		$AttackCooldown.start(1)


func _on_AttackCooldown_timeout():
	_can_do_damage = true
	$AttackCooldown.stop()

func _on_HitDetector_area_entered(area):
	if area.name=="WeaponRange":
		# take the hit
		self._hit_points-=50

func _on_FlashTimer_timeout():
	_hit_shader.set_deferred("shader_param/hurt_effect_blend", 0)
	_flash_timer.stop()
	_gusher.stop()
