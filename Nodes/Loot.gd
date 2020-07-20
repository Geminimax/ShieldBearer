extends Area2D
signal collected()
var holding = null
func pick(object):
	set_deferred("monitorable",false)
	set_deferred("monitoring",false)
	$AnimatedSprite2.hide()
	holding = object
	$CPUParticles2D.emitting = false
func collect():
	emit_signal("collected")
	queue_free()
func _process(delta):
	if(holding):
		global_position = holding.global_position + Vector2.UP * 15
