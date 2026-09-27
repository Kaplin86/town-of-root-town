extends Node2D

var base = global_position

func _process(delta: float) -> void:
	var x = ( get_global_mouse_position().x - base.x) * 0.2
	var y =  ( get_global_mouse_position().y - base.y) * -0.2
	global_position = base + Vector2(x,y)
