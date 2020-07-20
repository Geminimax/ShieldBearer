extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal level_restart
signal level_done(next_level)

onready var loot = $Loot.get_children()
onready var players = $Players.get_children()
onready var endpoint = $EndPoint
var completed = false
export (PackedScene) var teleport
export (PackedScene) var death_effect
export (PackedScene) var next_level
export (AudioStreamOGGVorbis) var music
# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalEvent.connect("hitpause",self,"hitpause")
	GlobalEvent.connect("screen_shake",self,"screen_shake")
	GlobalEvent.connect("screen_zoom",self,"screen_zoom")
	for player in players:
		player.level = self
	for l in loot:
		l.connect("collected",self,"_on_Loot_collected")
func get_loot():
	return $Loot.get_children()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _process(delta):
	if(Input.is_action_just_pressed("level-restart")):
		emit_signal("level_restart")
	
func _on_Player_death():
	$Players/Player.deactivate()
	var death = death_effect.instance()
	add_child(death)
	death.position = $Players/Player.global_position
	on_death()


func _on_AutoPlayer_death():
	$Players/AutoPlayer.deactivate()
	var death = death_effect.instance()
	add_child(death)
	death.position = $Players/AutoPlayer.global_position
	on_death()

func on_death():
	yield(get_tree().create_timer(0.5),"timeout")
	if(!completed):
		emit_signal("level_restart")

func hitpause(duration):
	get_tree().paused = true
	$Hitpause.start(duration)


func _on_Hitpause_timeout():
	get_tree().paused = false

func screen_shake(intensity,duration):
	$Camera2D.start_shake(duration,intensity)


func _on_Loot_collected():
	print("collect")
	print($Loot.get_child_count())
	if($Loot.get_child_count() == 1):
		$EndPoint.open()


func _on_EndPoint_entered(player):
	if(player.is_in_group("player")):
		$LevelComplete.play()
		var player_pos = player.global_position
		player.deactivate()
		var teleport_instance = teleport.instance()
		add_child(teleport_instance)
		teleport_instance.position = player_pos
		yield(get_tree().create_timer(0.75),"timeout")
		emit_signal("level_done",next_level)
