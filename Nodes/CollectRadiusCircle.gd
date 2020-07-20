extends Node2D
signal radius_entered(area)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var amount = 14
export (float) var radius = 10
export (PackedScene) var circleDot
# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D/CollisionShape2D.shape.radius = radius
	for i in range(amount):
		var c = circleDot.instance()
		add_child(c)
		c.frame = i % c.frames.get_frame_count("default")
		c.position = Vector2.UP.rotated(deg2rad(i * (360/amount))) * radius
		
		



func _on_Area2D_area_entered(area):
	emit_signal("radius_entered",area)

func deactivate():
	$Area2D/CollisionShape2D.set_deferred("disabled",true)
	visible = false
func activate():
	$Area2D/CollisionShape2D.set_deferred("disabled",false)
	visible = true
