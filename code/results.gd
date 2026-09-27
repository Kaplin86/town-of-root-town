extends Node2D

var Tiles : Dictionary[Vector2i,TileManagerNode.RoomTypes]
var Win = false
var CurrentPop = 0
var PeakPopulation = 0


func _ready() -> void:
	if Win:
		$Status.text = "win :)"
	else:
		$Status.text = "game over :("
	
	$Population.text = "Survivors: " + str(int(CurrentPop))
	$Peak.text = "Peak Population:" + str(int(PeakPopulation))
