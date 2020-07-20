extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var next_level = null
onready var transition = $CanvasLayer/Transition
var current_level 
var new_music = null
export (PackedScene) var level1
# Called when the node enters the scene tree for the first time.
func _ready():
	var initial_level = level1.instance()
	add_child(initial_level)
	next_level = level1
	current_level = initial_level
	current_level.connect("level_done",self,"on_level_done")
	current_level.connect("level_restart",self,"restart_level")
	transition.fadein()
	if(current_level.music):
		if(current_level.music != $AudioStreamPlayer.stream):
			new_music = current_level.music
			$AnimationPlayer.play("MusicFade")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func on_level_done(next_level):
	self.next_level = next_level
	print("levelDone")
	transition.fadeout()


func _on_Transition_fade_out_done():
	get_tree().paused = false
	$LevelTransition.start()
	current_level.queue_free()
	var new_level = next_level.instance()
	add_child(new_level)
	new_level.connect("level_done",self,"on_level_done")
	new_level.connect("level_restart",self,"restart_level")
	current_level = new_level
	
	if(current_level.music):
		if(current_level.music != $AudioStreamPlayer.stream):
			new_music = current_level.music
			$AnimationPlayer.play("MusicFade")
func _on_LevelTransition_timeout():
	transition.fadein()
	pass


func _on_Transition_fade_in_done():
	pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name == "MusicFade"):
		$AudioStreamPlayer.stream = new_music
		$AnimationPlayer.play("MusicStart")
		$AudioStreamPlayer.play(0)

func restart_level():
	transition.fadeout()

