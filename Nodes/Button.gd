extends Area2D


export (NodePath) var mechanism_path
export (bool) var active_state = true
var mechanism
func _ready():
	mechanism = get_node(mechanism_path)
func _on_Button_area_entered(area):
	mechanism.set_state(active_state)


func _on_Button_area_exited(area):
	mechanism.set_state(!active_state)
