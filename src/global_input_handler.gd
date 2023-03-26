extends Node

"""
Global input handler and global variable storage. Game-wide events are managed
and fired off from here. Events such as pausing, kickoff of a new game, pausing
and gameplay lifecycle events live in this global file.
"""

"""
This enum describes the game's overall status;

playing - the splashscreen is not visible and player input 
should be pursuant to gameplay rules.
Attract - the splashscreen is up and game input is only really inteded to launch the game and control meta functions.
"""
enum GameState {Playing, Attract}

@export var player_health: int:
	set = set_player_health
@export var max_player_health: int = 100
@export var player_score: int = 0:
	set = set_player_score

@export var player_lives: int:
	set = set_player_lives
@onready var _game_state:GameState = GameState.Attract:
	set = _set_game_state
var _player_ref: Player
var _playing: bool

signal HealthChanged
signal PlayerHurt
signal ScoreChange
signal PauseSounded
signal LivesChanged
signal GameStarted
signal GameEnded


func do_newgame_init():
	self.player_score = 0
	self.player_lives = 2
	do_newplayer_init()
	#Finally send the game started event
	_playing = true
	_game_state = GameState.Playing;


func do_newplayer_init():
	self.player_health = max_player_health
	_on_spawn_new_player_for_life()

func _on_spawn_new_player_for_life():
	_player_ref = null
	if self.player_lives > 0:
		self.player_lives -= 1
		do_newplayer_init()


func _unhandled_input(event: InputEvent):
	if (
		event.is_action_pressed("full_screen")
		and DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED
	):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	elif (
		event.is_action_pressed("full_screen")
		and DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif event.is_action_pressed("exit"):
		_quit_game()
	elif _is_playing() and !get_paused_status() and event.is_action_pressed("pause"):
		get_tree().paused = true
		emit_signal("PauseSounded")
	elif _is_playing() and get_paused_status() and event.is_action_pressed("pause"):
		get_tree().paused = false
		emit_signal("PauseSounded")
	elif Input.is_action_just_pressed("new_game") and _game_state == GameState.Attract:
		do_newgame_init()


func _quit_game():
	if _player_ref != null:
		_player_ref.disconnect("tree_exited", _on_spawn_new_player_for_life.bind())
	get_tree().quit(0)


func set_player_health(value: int):
	if player_health != value:
		if player_health > value:
			player_health = value
			emit_signal("PlayerHurt", value)
		player_health = value
		emit_signal("HealthChanged", value)
	if player_health <= 0 and player_lives <= 0:
		#Game over.
		if _is_playing():
			_playing = false
			_game_state = GameState.Attract


func set_player_score(value: int):
	player_score = value
	emit_signal("ScoreChange", value)


func set_player_lives(value: int):
	player_lives = value
	emit_signal("LivesChanged", value)


func get_paused_status() -> bool:
	return get_tree().paused


func _is_playing() -> bool:
	return _game_state == GameState.Playing

func _set_game_state(newVal:GameState):
	_game_state = newVal
	
	match newVal:
		GameState.Attract:
			emit_signal("GameEnded")
		GameState.Playing:
			emit_signal("GameStarted")
	
