extends AnimatedSprite

func show():
	$Tween.interpolate_property(self,"modulate:a",modulate.a,1.0,0.2,Tween.TRANS_QUAD,Tween.EASE_OUT)
	$Tween.start()

func hide():
	$Tween.interpolate_property(self,"modulate:a",modulate.a,0.0,0.2,Tween.TRANS_QUAD,Tween.EASE_OUT)
	$Tween.start()
