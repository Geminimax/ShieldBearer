extends Node2D
signal shield_hit(pos)

func set_shield_position(distance : float,direction : Vector2):
	var final_pos = distance * direction
	var final_rot = Vector2.UP.angle_to(final_pos)
	position = final_pos
	rotation = final_rot
#	$Tween.interpolate_property($AnimatedSprite,"position",$AnimatedSprite.position,final_pos,0.1,Tween.TRANS_QUAD,Tween.EASE_OUT)
#	$Tween.interpolate_property($AnimatedSprite,"rotation",$AnimatedSprite.rotation,final_rot,0.1,Tween.TRANS_QUAD,Tween.EASE_OUT)
#	$Tween.start()
	
static func lerp_angle(from: float, to: float, weight: float) -> float:
	return from + short_angle_dist(from, to) * weight

static func short_angle_dist(from: float, to: float) -> float:
	var difference = fmod(to - from, PI * 2)
	return fmod(2 * difference, PI * 2) - difference


func _on_Area2D_area_entered(area):
	$AnimationPlayer.play("Hit")
	emit_signal("shield_hit",area.global_position)
	$Defend.play()
