extends KinematicBody2D
class_name EnemyBase

onready var tween:Tween = Tween.new()

func _ready():
	add_child(tween)
# warning-ignore:return_value_discarded
	get_tree().connect("node_removed", self, "_on_node_removed")
	
func _on_node_removed(_node:Node):
	pass
	
func get_facing_scale()->float:
	return 1.0

func blowback(distance_units:int):
	_get_tweener().stop_all()
	_get_tweener().interpolate_property(self, "position", null, Vector2(position.x + (get_facing_scale() * distance_units), position.y), .2, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	_get_tweener().start()

func _get_tweener():
	return tween
