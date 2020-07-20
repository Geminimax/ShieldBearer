extends Position2D
signal entered(player)

func open():
	$AnimatedSprite.play("opening")
	yield($AnimatedSprite,"animation_finished")
	$AnimatedSprite.play("open")
	$Area2D/CollisionShape2D.disabled = false
	

func _on_Area2D_area_entered(area):
	emit_signal("entered",area.get_parent())
