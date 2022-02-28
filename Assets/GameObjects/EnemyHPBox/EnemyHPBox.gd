extends TextureRect

"""
Visual element showing the enemies remaining hitpoints.
"""
class_name EnemyHPBox

export (int, 0,100) var value:int = 0 setget set_value
export (int, 1,100) var max_value:int = 100 setget set_max

func set_value(new_value:int):
	$MarginContainer/TextureProgress.value = new_value

func set_max(new_value:int):
	$MarginContainer/TextureProgress.max_value = new_value
