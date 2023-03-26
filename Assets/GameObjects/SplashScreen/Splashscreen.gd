extends Control

func _ready():
	Global.connect("GameStarted", _on_game_start.bind())
	Global.connect("GameEnded", _on_game_ended.bind())

func fade_out():
	$AnimationPlayer.play("fade_out")

func fade_in():
	$AnimationPlayer.play("fading_in")

func _on_game_start():
	fade_out()
	
func _on_game_ended():
	fade_in()
