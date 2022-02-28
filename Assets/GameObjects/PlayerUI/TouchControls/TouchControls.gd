extends Control

"""
Logic class mapping on-screen controls to game input actions.
"""

func _on_UpButton_button_down():
	Input.action_press("move_up")

func _on_UpButton_button_up():
	Input.action_release("move_up")


func _on_LeftButton_button_down():
	Input.action_press("move_left")


func _on_LeftButton_button_up():
	Input.action_release("move_left")


func _on_RightButton_button_down():
	Input.action_press("move_right")


func _on_RightButton_button_up():
	Input.action_release("move_right")

func _on_DownButton_button_down():
	Input.action_press("move_down")

func _on_DownButton_button_up():
	Input.action_release("move_down")

func _on_AttackButton_pressed():
	Input.action_press("attack")
