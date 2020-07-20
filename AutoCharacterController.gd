extends "res://Nodes/CharacterController.gd"
signal death
enum STATE{WALK,KNOCKBACK,COLLECT_LOOT}
var state = STATE.WALK
var knockback_speed = 200
var current_goal
var max_life = 3
var life_amount = max_life
var invencible = false
onready var cast = $RayCast2D
func _ready():
	$HealthBar.set_health(max_life,life_amount)

func _process(delta):
	if(body):
		position_pointer()
		if(state == STATE.WALK):
			if(current_goal):
				
				var direction = body.global_position.direction_to(current_goal)
				cast.cast_to = direction * 8
				if(cast.is_colliding()):
					direction = Vector2.ZERO
					$Question.show()
					body.sprite.play("idle")
				else:
					$Question.hide()
					body.sprite.play("walk")
				body.velocity = lerp(body.velocity,direction * move_speed,delta * accel_lerp_weight)
				
					
		if(state == STATE.KNOCKBACK or state == STATE.COLLECT_LOOT):
			body.velocity = lerp(body.velocity, Vector2.ZERO ,delta * 5)
func set_level(value):
	.set_level(value)
	get_next_goal()
	
func get_next_goal():
	$Pointer.show()
	var loot = level.get_loot()
	var min_dist = -1
	if(loot.size() > 0):
		for l in loot:
			var pos = l.global_position
			var dist = body.global_position.distance_to(pos)
			if(dist < min_dist or min_dist == -1):
				min_dist = dist 
				current_goal = pos
	else:
		current_goal = level.endpoint.global_position
func _on_HitBox_area_entered(area):
	 handle_collision(area)


func handle_collision(area):
	if(area.is_in_group("loot")):
		$CollectSound.play()
		area.pick(self)
		if(state == STATE.WALK):
			body.velocity = Vector2.ZERO
		state = STATE.COLLECT_LOOT
		$Pointer.hide()
		body.sprite.play("collect")
		$CPUParticles2D2.restart()
		yield(get_tree().create_timer(1.0),"timeout")
		area.collect()
		if(state == STATE.COLLECT_LOOT):
			state = STATE.WALK	
		#Wait until the next frame so the loot is already freed
		yield(area,"tree_exited")
		get_next_goal()
	elif(area.is_in_group("damage")):
		take_damage(area)
		
func knockback(source_position,velocity = Vector2.ZERO,duration = 1.08):
	if(velocity == Vector2.ZERO):		
		if(body.velocity != Vector2.ZERO):
			body.velocity = -body.velocity.normalized() * knockback_speed
		else:
			body.velocity = -(body.global_position - source_position).normalized() * knockback_speed
	else:	
		body.velocity = velocity * 0.8
	state = STATE.KNOCKBACK
	body.sprite.stop()
	$KnockBackTimer.start(duration)

func position_pointer():
	var dir = body.global_position.direction_to(current_goal)
	$Pointer.position = (Vector2.RIGHT * 20).rotated(dir.angle())
	$Pointer.rotation = dir.angle() + PI/2

func _on_KnockBackTimer_timeout():
	if( state ==  STATE.KNOCKBACK ):
		state = STATE.WALK
		
func take_damage(source):
	if(!invencible):
		$DamageSound.play()
		invencible = true
		life_amount -= 1
		$InvencibilityTimer.start()
		body.start_hitflash()
		if(life_amount <= 0):
			body.emit_signal("death")
			GlobalEvent.emit_signal("screen_shake",1.8,0.25)
		else:
			GlobalEvent.emit_signal("hitpause",0.05)
			GlobalEvent.emit_signal("screen_shake",1.4,0.25)
			knockback(source.global_position,Vector2.ZERO,0.75)
		$HealthBar.set_health(max_life,life_amount)

func _on_HitBox_body_entered(body):
	print("BOdy entered!")
	if(body.is_in_group("damage")):
		take_damage(body)


func _on_InvencibilityTimer_timeout():
	body.stop_hitflash()
	invencible = false
