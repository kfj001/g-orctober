extends Control

onready var _progress_bar = $TextureRect/GridContainer/hpProgress
onready var _score = $TextureRect/GridContainer/scoreLabel2
onready var _lives = $TextureRect/Face/LivesLabel

func _ready():
	_progress_bar.value = Global.player_health
# warning-ignore:return_value_discarded
	Global.connect("HealthChanged", self, "_on_player_health_changed")
# warning-ignore:return_value_discarded
	Global.connect("ScoreChange", self, "_on_player_score_changed")
# warning-ignore:return_value_discarded
	Global.connect("PauseSounded", $PauseSoundPlayer, "play")
# warning-ignore:return_value_discarded
	Global.connect("LivesChanged", self, "_on_player_lives_changed")
	_set_lives_to(Global.player_lives)
	_score.text = str(Global.player_score)
	
	
func _on_player_health_changed(new_value:int):
	_progress_bar.value = new_value

func _on_player_score_changed(new_value:int):
	_score.text =  str(new_value)

func _on_player_lives_changed(new_value:int):
	_set_lives_to(new_value)

func _set_lives_to(value:int):
	_lives.text = "x%s" % value
