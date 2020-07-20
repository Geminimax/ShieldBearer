extends KinematicBody2D
class_name CharacterBody
signal death

var level setget set_level
var velocity : Vector2 = Vector2()
export (NodePath) var controller_path
var controller
onready var sprite = $AnimatedSprite
func _ready():
	print(controller_path)
	controller = get_node(controller_path)
	controller.body = self


func _process(delta):
	move_and_slide(velocity)

func set_level(value):
	level = value
	controller.level = value


func _on_HitBox_area_entered(area):
	handle_collision(area)

func handle_collision(area):
	pass


func knockback(position,velocity):
	controller.knockback(position,velocity)

func start_hitflash():
	$AnimationPlayer.play("HitFlash")

func stop_hitflash():
	sprite.modulate = Color.white
	$AnimationPlayer.stop()
	
func reset_hitbox():
	$HitBox/CollisionShape2D.set_deferred("disabled",true)
	yield(get_tree(),"idle_frame")
	$HitBox/CollisionShape2D.set_deferred("disabled",false)

func deactivate():
	$HitBox/CollisionShape2D.set_deferred("disabled",true)
	$CollisionShape2D.set_deferred("disabled",true)
	visible = false
