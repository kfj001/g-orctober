extends Control

"""
This class contains the logic driving the in-game UI (player status, 
score, number of lives, health, etc.) This class connects to 
in-game play event messages and updates the player UI accordingly.

The authoratitive location for the data this UI element displays is in 
the Global scope (See global_input_handler.gd)
"""

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
	

"""
Event handler. Fires when the player's health is changed in the Global model. Updates
the health indicator UI.
"""
func _on_player_health_changed(new_value:int):
	_progress_bar.value = new_value
"""
Event handler. Fires when the player's score changes in the Global model. Updates
on-screen score.
"""
func _on_player_score_changed(new_value:int):
	_score.text =  str(new_value)
"""
Event handler. Fires when the player's lives counter is changed in the Global model. Updates
the listed number of lives.
"""
func _on_player_lives_changed(new_value:int):
	_set_lives_to(new_value)
"""
Updates the displayed lives value on screen given the parameterized value. 
The numeric value provided will be reformatted on-screen.
"""
func _set_lives_to(value:int):
	_lives.text = "x%s" % value
