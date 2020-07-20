extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (float) var shoot_time = 0.5
export (float) var start_offset = 0.0
export (Vector2) var direction = Vector2.DOWN
export (PackedScene) var cannon_shoot_effect 
# Called when the node enters the scene tree for the first time.
func _ready():
	
	$Sprite2.rotation = direction.angle() - PI/2
	$ProjectileSpawner.direction = direction
	$ProjectileSpawner.position = direction * 2
	yield(get_tree().create_timer(start_offset),"timeout")
	$Timer.start(shoot_time)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	$ProjectileSpawner.shoot()
	var blast = cannon_shoot_effect.instance()
	blast.rotation = direction.angle()  - PI/2
	add_child(blast)
	blast.position = direction * 2 
	$Tween.interpolate_property($Sprite2,"position",Vector2.ZERO,-direction * 2,0.1,Tween.EASE_OUT)
	$Tween.interpolate_property($Sprite2,"position",-direction * 2,Vector2.ZERO,0.2,Tween.EASE_IN,0.1)
	$Tween.start()
	
