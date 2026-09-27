extends AudioStreamPlayer

@export var streams : Array[AudioStream] = []

func _ready() -> void:
	stream = streams.pick_random()
	play()


func _on_finished() -> void:
	var temp = streams.duplicate()
	temp.erase(stream)
	stream = temp.pick_random()
	play()
