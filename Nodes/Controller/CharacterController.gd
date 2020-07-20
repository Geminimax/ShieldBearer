extends Node2D

export (float) var move_speed = 80
export (float) var accel_lerp_weight = 8
var body : CharacterBody
var level setget set_level
func _ready():
	pass # Replace with function body.

func set_level(value):
	level = value
