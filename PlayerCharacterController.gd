extends "res://Nodes/CharacterController.gd"
enum STATE{WALKING,DASHING,KNOCKBACK}
var state = STATE.WALKING
var dash_speed = 300
var hold_direction_speed = 50
var knockback_speed = 200
var facing_direction = Vector2.DOWN
var max_life = 3
var life_amount = max_life
var holding_direction = false
var dash_buffer = false
onready var shield = $Shield
var final_speed  = move_speed
var invencible = false
export (PackedScene) var dash_blast
export (PackedScene) var shield_bash

func _ready():
	$CanvasLayer/HealthBarBig.set_health(max_life,life_amount)
func get_facing_direction():
	#var clamped_angle = stepify(rad2deg(body.global_position.direction_to(get_global_mouse_position()).angle()),22.5)
	#return Vector2.RIGHT.rotated(deg2rad(clamped_angle))
	return body.global_position.direction_to(get_global_mouse_position())
	
func _process(delta):
	if(body):
		if(state == STATE.WALKING):
			var direction = (get_vertical_input() + get_horizontal_input()).normalized()
			facing_direction = get_facing_direction()
			if(direction != Vector2.ZERO):
				body.sprite.play("walk")
			else:
				body.sprite.play("idle")
			body.velocity = lerp(body.velocity, direction * move_speed,delta * accel_lerp_weight)
			
			if(Input.is_action_just_pressed("dash") or dash_buffer):
				dash()
				return
			shield.set_shield_position(15,facing_direction)
		if(state == STATE.DASHING):
			body.velocity = lerp(body.velocity, Vector2.ZERO ,delta * 2)
			if(Input.is_action_just_pressed("dash")):
				dash_buffer = true
				$DashBuffer.start()
		if(state == STATE.KNOCKBACK):
			if(Input.is_action_just_pressed("dash")):
				dash_buffer = true
				$DashBuffer.start()
			body.velocity = lerp(body.velocity, Vector2.ZERO ,delta * 5)
func get_vertical_input():
	var input = 0
	if(Input.is_action_pressed("move_up")):
		input = -1
	elif(Input.is_action_pressed("move_down")):
		input = 1
	return Vector2(0,input)
func dash():
	$DashSound.play()
	body.reset_hitbox()
	body.velocity = dash_speed * facing_direction
	state = STATE.DASHING
	var blast = dash_blast.instance()
	blast.rotation = body.velocity.angle()  - PI/2
	add_child(blast)
	blast.global_position = global_position - body.velocity.normalized() * 15
	$DashTimer.start()
	$CPUParticles2D.restart()
	$CPUParticles2D.direction = - body.velocity
	body.sprite.play("dash")
	
	
func get_horizontal_input():
	var input = 0
	if(Input.is_action_pressed("move_left")):
		input = -1
	elif(Input.is_action_pressed("move_right")):
		input = 1
	return Vector2(input,0)


func _on_DashTimer_timeout():
	if(state == STATE.DASHING):
		state = STATE.WALKING
		$CPUParticles2D.emitting = false

func _on_HitBox_area_entered(area):
	if(area.is_in_group("damage")):
		take_damage(area)
	if(state == STATE.DASHING):
		if(area.is_in_group("pushable_object")):
			bash(area)
			
		elif(area.get_parent().is_in_group("pushable_object")):
			bash(area.get_parent())	

func bash(object):
	$BashSound.play()
	object.knockback(body.global_position,body.velocity)
	body.velocity = -body.velocity * 0.5
	GlobalEvent.emit_signal("hitpause",0.08)
	GlobalEvent.emit_signal("screen_shake",0.5,0.15)
	var blast = shield_bash.instance()
	blast.rotation = -body.global_position.direction_to(object.global_position).angle() - PI/2
	add_child(blast)
	blast.global_position =  (body.global_position + object.global_position)/2
	
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
		$CanvasLayer/HealthBarBig.set_health(max_life,life_amount)



func _on_Shield_shield_hit(pos):
	var clamped_angle = stepify(rad2deg((body.global_position - pos).normalized().angle()),45)	
	#body.velocity += Vector2.RIGHT.rotated(deg2rad(clamped_angle)) * 35
	if(state == STATE.DASHING):
		body.velocity = -body.velocity * 0.5


func knockback(source_position,velocity = Vector2.ZERO,duration = 1.0):
	#if(velocity == Vector2.ZERO):		
	var clamped_angle = stepify(rad2deg((body.global_position - source_position).normalized().angle()),45)	
	body.velocity =  Vector2.RIGHT.rotated(deg2rad(clamped_angle)) * knockback_speed
	#else:	
		#body.velocity = velocity * 0.8
	state = STATE.KNOCKBACK
	$CPUParticles2D.emitting = false
	body.sprite.stop()
	$KnockbackTimer.start(duration)


func _on_DashBuffer_timeout():
	dash_buffer = false


func _on_KnockbackTimer_timeout():
	if( state ==  STATE.KNOCKBACK ):
		state = STATE.WALKING


func _on_InvencibilityTimer_timeout():
	invencible = false
	body.stop_hitflash()


func _on_HitBox_body_entered(hit_body):
	if(hit_body.is_in_group("damage")):
		take_damage(hit_body)
