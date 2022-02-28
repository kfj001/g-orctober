extends Node2D

"""
PlayerSpawner creates and manages both the player object as well as the "off screen"
enemy spawner. When spawn_player() is called both a new player is instantiated 
as well as an enemy spwaner as a sibling to the player. The enemy spawner keeps
enemies spawning 'just off screen'.

Game lifecycle events are connected by this class such as the 'too left' warning
when the player strays too far to the left (and risks getting killed)
"""
class_name PlayerSpawner

var _root_node:YSort

"""
A reference to the player to spawn when the user starts a new game, or the 
existing player dies.
"""
export (PackedScene) var player:PackedScene
"""
A reference to the gnome spawner. This will be attached to the player
and started once the game is begun.
"""
export (PackedScene) var gnome_spawner:PackedScene

"""
Instantiates a new player and gnome spawner and begins their animation
cycle on screen. Called when a new game is started.
"""
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
