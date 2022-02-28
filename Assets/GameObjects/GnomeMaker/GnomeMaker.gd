extends Node2D

"""
Spawns one of two parameterized game objects at random. Will continue to spawn
enemies until the max_spawnlings are hit. Tracks spawns/kills using 
lifecycle events
"""

onready var _spawn_area_shape:CollisionShape2D = $SpawnArea/CollisionShape2D
export (PackedScene) var enemy1
export (PackedScene) var enemy2
export (int, 1,300) var max_spawnlings:int
var _spawnlings:int = 0
var _initial_y_pos:float

func _ready():
	_initial_y_pos = to_global( _spawn_area_shape.position).y

func _on_GnomeTImer_timeout():
# warning-ignore:return_value_discarded
	rand_seed(1)
	var file:PackedScene = enemy1 if randi() % 2 == 0  else enemy2
	if _spawnlings < max_spawnlings:
		var root=get_parent().get_parent()
		var to_spawn:KinematicBody2D = file.instance()
		var extents = (_spawn_area_shape.shape as RectangleShape2D).extents * scale
		var spawn_shape_location = _spawn_area_shape.position
		spawn_shape_location.y = _initial_y_pos
		var position_to_use = to_global(spawn_shape_location)
		position_to_use.y = _initial_y_pos
		var xPos = rand_range(position_to_use.x-(extents.x/2), position_to_use.x+(extents.x/2))
		var yPos = rand_range(position_to_use.y-(extents.y/2), position_to_use.y+(extents.y/2))
		var new_position = Vector2(xPos,yPos)
		to_spawn.position = new_position
		to_spawn.scale = Vector2(.2,.2)
# warning-ignore:return_value_discarded
		to_spawn.connect("tree_exited", self, "_on_spawnling_despawned")
		root.add_child(to_spawn)
		_spawnlings += 1
		
func _on_spawnling_despawned():
	_spawnlings-=1
