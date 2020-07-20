extends Node2D

export(bool) var current_state 
func set_state(value):
	current_state = value
	on_set_state()
func on_set_state():
	pass
