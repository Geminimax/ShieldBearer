extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (int) var sprite_width = 8
export (bool) var center = true
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_health(max_value,current_value):
	$Empty.region_rect.size.x = max_value * sprite_width
	$Filled.region_rect.size.x = current_value * sprite_width
	if(center):
		position.x = -$Empty.region_rect.size.x/2
