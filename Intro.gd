extends Node2D

signal level_done(next_level)
signal level_restart

export (PackedScene) var next_level 
export (AudioStreamOGGVorbis) var music
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var can_start = false
var started = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("dash") and can_start and !started):
		$AudioStreamPlayer.play()
		emit_signal("level_done",next_level)
		started = true



func _on_AnimationPlayer_animation_changed(old_name, new_name):
	can_start = true
	print("changed")
	
