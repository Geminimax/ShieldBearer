extends Node2D

export (float) var speed
export (PackedScene) var bullet
export (Vector2) var direction
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func shoot(direction = self.direction, speed = self.speed):
	var bullet_instance = bullet.instance()
	add_child(bullet_instance)
	bullet_instance.global_position = global_position
	bullet_instance.velocity = speed * direction



