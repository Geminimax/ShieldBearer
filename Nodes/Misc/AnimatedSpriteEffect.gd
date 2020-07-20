extends AnimatedSprite
export(bool) var toplevel = true
func _ready():
	frame = 0
	set_as_toplevel(toplevel)
	play("default")

func _on_AnimatedSpriteEffect_animation_finished():
	queue_free()

