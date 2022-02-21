extends Node2D

class_name PlayerSpawner

var _root_node:YSort

export (PackedScene) var player:PackedScene
export (PackedScene) var gnome_spawner:PackedScene

func spawn_player()->Player:
	var r1 = get_node("/root")
	var r2 = r1.find_node("YSort", true, false)
	_root_node = r2
	var gnome_spawner_instance = gnome_spawner.instance()
	var player_obj:Player = player.instance()
	var new_pos = _root_node.to_local(to_global(position))
	var keep_moving_control:GetMoving = r1.find_node("GetMoving", true, false)
	new_pos.x += 1300
	new_pos.y = 1000
	player_obj.scale = Vector2(.6,.6)
	player_obj.position = new_pos 
# warning-ignore:return_value_discarded
	player_obj.connect("TooLeft", keep_moving_control, "show")
	_root_node.add_child(player_obj)
	player_obj.add_child(gnome_spawner_instance)
	gnome_spawner_instance.position = Vector2(2000, 100)
	gnome_spawner_instance.scale.y = 200
	# Walk player x units from the left
	player_obj.do_player_walkon()
	return player_obj
