extends Control

"""
Logic class mapping on-screen controls to game input actions.
"""

func _on_AttackButton_pressed():
	Input.action_press("attack")
