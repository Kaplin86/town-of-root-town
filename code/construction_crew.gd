extends Node2D
class_name ConstructionCrewNode

var pos = Vector2i.ZERO
var type : TileManagerNode.RoomTypes

signal done(pos : Vector2i, type : TileManagerNode.RoomTypes, crew : ConstructionCrewNode)

func format_time(time_in_seconds: float) -> String:
	var minutes: int = floori(time_in_seconds / 60.0)
	var seconds: int = int(time_in_seconds) % 60
	return "%02d:%02d" % [minutes, seconds]

func _process(delta: float) -> void:
	$Label.text = format_time($Timer.time_left)
	$ProgressBar.max_value = $Timer.wait_time
	$ProgressBar.value = $Timer.time_left


func _on_timer_timeout() -> void:
	done.emit(pos,type,self)
