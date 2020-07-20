extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_toplevel(true)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position += velocity * delta
	$AnimatedSprite.rotation = velocity.rotated(PI/2).angle()
#	pass


func _on_Projectile_area_entered(area):
	destroy()

func destroy():
	$CollisionShape2D.set_deferred("disabled",true)
	$AnimatedSprite.play("destroy")
	velocity = Vector2()
	yield($AnimatedSprite,"animation_finished")
	queue_free()


func _on_Projectile_body_entered(body):
	destroy()
