extends "res://Nodes/CharacterController.gd"
enum STATE{SLEEP,PORSUE,ATTACK,KNOCKBACK}
var state = STATE.SLEEP
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var target 
var target_radius = 80
var offset = 0
var total_angle_speed = 55
var projectile_amount = 3
var projectile_spread = 35
var time = 0
var recoil_speed = 100
export (PackedScene) var blast_anim
export (PackedScene) var shoot_charge
var initial_position
# Called when the node enters the scene tree for the first time.
func _ready():
	initial_position = global_position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (state == STATE.PORSUE):
		if(target):
			var dir = Vector2.ZERO
			offset += total_angle_speed * delta
			var goal = target.global_position + ((Vector2.UP.rotated(deg2rad(offset))).tangent().normalized() * target_radius)
			dir = body.global_position.direction_to(goal)
			
			#var new_velocity = dir  * total_angle_speed	
			body.velocity = lerp(body.velocity,body.global_position.direction_to(goal) * move_speed,delta)
			#body.velocity = new_velocity
		else:
			$ShootTimer.stop()
			var goal = initial_position
			
			if(body.global_position.distance_to(goal) > 5):
				body.velocity = lerp(body.velocity,body.global_position.direction_to(goal) * move_speed,delta)
			else:
				body.velocity = Vector2.ZERO
				$CollectRadiusCircle.activate()
	if(state == STATE.ATTACK or state == STATE.KNOCKBACK):
		body.velocity = lerp(body.velocity,Vector2(),delta * 3)

#	pass


func _on_CollectRadiusCircle_radius_entered(area):
	target = area.get_parent()
	state = STATE.PORSUE
	$ShootTimer.start()
	$CollectRadiusCircle.deactivate()


func _on_ShootTimer_timeout():
	state = STATE.ATTACK
	body.sprite.stop()
	var blast = shoot_charge.instance()
	#blast.rotation = body.global_position.direction_to(target.global_position).angle() + PI/2
	add_child(blast)
	yield(get_tree().create_timer(0.4),"timeout")
	shoot()
	yield(get_tree().create_timer(0.3),"timeout")
	state = STATE.PORSUE
	body.sprite.play("default")
	$ShootTimer.start()

func shoot():
	var center_dir = body.global_position.direction_to(target.global_position)
	var blast = blast_anim.instance()
	blast.rotation = center_dir.angle() + PI/2
	add_child(blast)
	blast.global_position = global_position
	
	var angle_increment = (2 * projectile_spread)/projectile_amount
	yield(get_tree().create_timer(0.05),"timeout")
	for i in range(projectile_amount):
		var shoot_dir = center_dir.rotated(deg2rad(-projectile_spread + (angle_increment * i)))
		$ProjectileSpawner.shoot(shoot_dir)
	body.velocity = -center_dir * recoil_speed
	
func knockback(position,velocity):
	#body.velocity = (body.global_position - position).normalized() * knockback_speed
	body.velocity = velocity * 0.66
	state = STATE.KNOCKBACK
	yield(get_tree().create_timer(0.5),"timeout")
	state = STATE.PORSUE
		
