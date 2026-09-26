extends Node
class_name ConstructionManager

@export var TileManager : TileManagerNode

var currentConstructions : Dictionary[Vector2i,Variant] = {}

var constructionCrew = preload("res://scenes/construction_crew.tscn")

signal doneBuilding

func startConstruction(pos : Vector2i, into : TileManagerNode.RoomTypes):
	if !currentConstructions.has(pos):
		var newCrew : ConstructionCrewNode= constructionCrew.instantiate()
		add_child(newCrew)
		newCrew.global_position = TileManager.Background.map_to_local(pos)
		currentConstructions[pos] = newCrew
		newCrew.pos = pos
		newCrew.type = into
		newCrew.connect("done",done)

func done(pos : Vector2i, type : TileManagerNode.RoomTypes, crew : ConstructionCrewNode):
	currentConstructions.erase(pos)
	crew.queue_free()
	TileManager.Tiles[pos] = type
	doneBuilding.emit()
