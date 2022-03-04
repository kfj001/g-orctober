extends TextureRect

func _ready():
	fade_in()
	Global.connect("GameStarted", self, "_on_game_start")
	Global.connect("GameEnded", self, "_on_game_ended")

func fade_out():
	$AnimationPlayer.play("fade_out")

func fade_in():
	$AnimationPlayer.play("fading_in")

func _on_game_start():
	fade_out()
	
func _on_game_ended():
	fade_in()
