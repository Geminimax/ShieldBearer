extends ColorRect

signal fade_in_done
signal fade_out_done

func fadein():
	$AnimationPlayer.stop()
	$AnimationPlayer.play("Fade-in")

func fadeout():
	$AnimationPlayer.stop()
	$AnimationPlayer.play("Fade-out")


func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name == "Fade-in"):
		emit_signal("fade_in_done")
	elif(anim_name =="Fade-out"):
		emit_signal("fade_out_done")
