extends Node2D

@export var shadingImage : Sprite2D

var dt = 0.0
func _process(delta: float) -> void:
	dt += delta
	shadingImage.modulate = Color(1,1,1,sin(dt) * 0.2 + 0.8)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
