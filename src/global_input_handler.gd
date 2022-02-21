extends Node

onready var _player_spawner:PlayerSpawner = get_node("/root").find_node("PlayerSpawner", true, false)

enum AnimationMode {REAL, TOON}
export var anim_mode:int setget set_anim_mode
export var player_health:int setget set_player_health
export var max_player_health:int = 100
export var player_score:int = 0 setget set_player_score

export var player_lives:int setget set_player_lives
var _player_ref:Player

signal AnimationChanged
signal HealthChanged
signal PlayerHurt
signal ScoreChange
signal PauseSounded
signal LivesChanged

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	
func do_newgame_init():
	self.player_score = 0
	self.player_lives = 2
	do_newplayer_init()
	
func do_newplayer_init():
	self.player_health = max_player_health
	# Decide if score should reset, say, after lives exhausted?
	#emit_signal("PlayerSpawned")
	_player_ref = _player_spawner.spawn_player()
	if _player_ref != null:
		# warning-ignore:return_value_discarded
		_player_ref.connect("tree_exited", self, "_on_spawn_new_player_for_life")
		
func _on_spawn_new_player_for_life():
	_player_ref = null
	if self.player_lives > 0:
		self.player_lives -= 1
		do_newplayer_init()

func _unhandled_input(event:InputEvent):
	get_tree().set_input_as_handled()
	
	if event.is_action_pressed("full_screen") and !OS.window_fullscreen:
		OS.window_fullscreen = true
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	elif event.is_action_pressed("full_screen") and OS.window_fullscreen:
		OS.window_fullscreen = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif event.is_action_pressed("exit"):
		_quit_game()
	elif Input.is_key_pressed(KEY_T):
		if anim_mode == AnimationMode.TOON:
			self.anim_mode = AnimationMode.REAL
		else:
			self.anim_mode = AnimationMode.TOON		
	elif get_tree().paused == false and event.is_action_pressed("pause"):
		get_tree().paused = true
		emit_signal("PauseSounded")
	elif get_tree().paused and event.is_action_pressed("pause"):
		get_tree().paused = false
		emit_signal("PauseSounded")
	elif Input.is_action_just_pressed("new_game") and get_node("/root").find_node("Player", true, false) == null:
		do_newgame_init()

func _quit_game():
	if _player_ref != null:
		_player_ref.disconnect("tree_exited", self, "_on_spawn_new_player_for_life")
	get_tree().quit(0)

func set_anim_mode(value:int):
	anim_mode = value
	emit_signal("AnimationChanged")

func set_player_health(value:int):
	if player_health != value:
		if (player_health > value):
			player_health = value
			emit_signal("PlayerHurt", value)
		player_health = value
		emit_signal("HealthChanged", value)

func set_player_score(value:int):
	player_score = value
	emit_signal("ScoreChange", value)

func set_player_lives(value:int):
	player_lives = value
	emit_signal("LivesChanged", value)
