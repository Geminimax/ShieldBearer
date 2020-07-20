extends Camera2D

var shaking = false
var shake_time 
var shake_str
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func start_shake(time,strength):
	shake_time = time 
	shake_str = strength * 15
	shaking = true

func stop_shake():
	shaking = false
	offset.x = 0
	offset.y = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(shaking):
		shake_time -= delta
		shake()
		if(shake_time <= 0):
			stop_shake()
	else:
		offset.x = 0
		offset.y = 0
		
func shake():
	offset.x =  lerp(offset.x,rand_range(-shake_str,shake_str),0.05)
	offset.y = lerp(offset.y,rand_range(-shake_str,shake_str),0.05)
