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
		if TileManager.RoomDatas.get(into, {}).has("cost"):
			$"..".Supplies -= TileManager.RoomDatas.get(into, {}).get("cost",0)

func done(pos : Vector2i, type : TileManagerNode.RoomTypes, crew : ConstructionCrewNode):
	currentConstructions.erase(pos)
	crew.queue_free()
	TileManager.Tiles[pos] = type
	$"../CanvasLayer/UiManager".selectedPos = Vector2i(-999,-999)
	doneBuilding.emit()
	if type in [TileManagerNode.RoomTypes.Emptied_Ground, TileManagerNode.RoomTypes.Emptied_Root]:
		if type == TileManagerNode.RoomTypes.Emptied_Ground:
			$"..".Supplies += 10
		else:
			$"..".Supplies += 15
