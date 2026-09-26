extends Node

func _ready() -> void:
	await get_tree().create_timer(5).timeout
	Famine()

var famined = false


func Famine():
	$Popup.popup()
	$"../TimeManager".pause()
