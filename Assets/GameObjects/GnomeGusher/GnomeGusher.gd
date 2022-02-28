extends Node2D

"""
Visual element that shows 'gushing' blood from struck enemies. 
Uses CPU particles.
"""
class_name GnomeGusher

func start():
	$Gusher1.emitting = true
	$Gusher2.emitting = true
	
func stop():
	$Gusher1.emitting = false
	$Gusher2.emitting = false
