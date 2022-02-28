extends EnemyBase

"""
Game logic for the 'shuffler' - another one of the Zombie gnome enemies.
"""

onready var _animation_player = $AnimationPlayer
onready var _gnome_host = $Gnome
onready var _perceptual_collider = $Gnome/PerceptualRadius/CollisionShape2D
onready var _general_collider =	$CollisionShape2D
onready var _hitbox_collider = $HitArea/Hitbox
onready var _attack_collider = $Gnome/AttackArea/CollisionShape2D2
onready var _hp_bar = $EnemyHPBox
onready var _flash_timer = $FlashTimer
onready var _gnome_shader = ($Gnome.material as ShaderMaterial)
onready var _hp_progress:EnemyHPBox = $EnemyHPBox

export (float, 50, 300) var shuffle_distance=150.0
export (int) var attack_damage = 5
var velocity:Vector2
var _player_target
const max_hit_points:int=100
onready var hit_points:int = max_hit_points setget _hit_points_set
var _dead:bool=false
var _timer:float = 0

func ready():
	_animation_player.play("idle")

func _on_node_removed(node:Node):
	if node == _player_target:
		_player_target = null
		#_animation_player.play("idle")

func _physics_process(delta):
	_timer += delta
	_gnome_shader.set("shader_param/time", _timer)
	if velocity.x < 0:
		_gnome_host.scale.x=1
	elif velocity.x > 0:
		_gnome_host.scale.x=-1
# warning-ignore:return_value_discarded
	move_and_slide(velocity)

func shuffle_forward():
	if (_player_target != null):
		velocity=position.direction_to(_player_target.position) * shuffle_distance

func stop():
	velocity=Vector2.ZERO

func _on_PerceptualRadius_body_entered(body):
	if body != self and !_dead:
		_animation_player.play("moving")
		_player_target = body

func _on_AttackArea_body_entered(_body):
	if !_dead:
		_animation_player.play("attack")
		stop()

func _on_AttackArea_body_exited(_body):
	if !_dead:
		_animation_player.play("moving")

func do_damage():
	Global.player_health -= attack_damage

func die():
	_dead = true
	_perceptual_collider.set_deferred("disabled", true)
	_general_collider.set_deferred("disabled", true)
	_hitbox_collider.set_deferred("disabled", true)
	_attack_collider.set_deferred("disabled", true)
	_hp_progress.visible = false
	stop()
	Global.player_score += 1000
	$CleanupTimer.start(5.0)
	_animation_player.play("dead")

func _hit_points_set(value:int):
	hit_points = value
	_hp_progress.value = hit_points
	start_blinking()
	if hit_points <= 0:
		die()

func _on_CleanupTimer_timeout():
	queue_free()

func _on_HitArea_area_entered(area):
	if area.name=="WeaponRange":
		# take the hit
		self.hit_points-=50

func get_facing_scale()->float:
	return _gnome_host.scale.x

func start_blinking():
	_timer = 0
	_gnome_shader.set_deferred("shader_param/hurt_effect_blend", 1)
	$Gnome/Torso/GnomeGusher.start()
	_flash_timer.start()

func stop_blinking():
	_gnome_shader.set_deferred("shader_param/hurt_effect_blend", 0)
	$Gnome/Torso/GnomeGusher.stop()
	_flash_timer.stop()
	
func _on_FlashTimer_timeout():
	stop_blinking()
