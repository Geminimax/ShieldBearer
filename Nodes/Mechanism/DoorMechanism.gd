extends "res://Nodes/Mechanism/Mechanism.gd"
enum move_dir{UP = -1,DOWN = 1}

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (move_dir) var move_direction = move_dir.UP
var goal_position = null
var activate_speed = 0.05
onready var original_position = position
# Called when the node enters the scene tree for the first time.

func on_set_state():
	goal_position = original_position
	if(current_state == true):
		goal_position.y = original_position.y + ($StaticBody2D/CollisionShape2D.shape.extents.y * 2 * move_direction)

func _physics_process(delta):
	if(goal_position != null):
		position.y = lerp(position.y, goal_position.y, activate_speed)
		if(round(position.y) == round(goal_position.y)):
			position.y = goal_position.y
			goal_position = null
