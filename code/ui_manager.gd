extends Control

@export var main : MainVariableHolder
@export var population : Label
@export var food : Label
@export var supplies : Label
@export var workers : Label
@export var availableWorkers : Label

@export var TileManager : TileManagerNode
@export var SelectorManager : SelectorManagerNode
@export var ConstructionCrewManager : ConstructionManager

@export var buildingPanel : VBoxContainer

var RootBuildings = [TileManagerNode.RoomTypes.House,TileManagerNode.RoomTypes.Hospital,TileManagerNode.RoomTypes.Construction_Office]
var GroundBuildings = [TileManagerNode.RoomTypes.Pathway,TileManagerNode.RoomTypes.Garden]

var selectedPos = Vector2i.ZERO
func _process(delta):
	population.text = "Population: " + str(main.Population) + " / " + str(main.MaxHousing)
	food.text = "Food: " + str(main.Food)
	supplies.text = "Building Supplies: " + str(main.Supplies)
	workers.text = "Construction Crews: " + str(main.CurrentWorkerTeams)
	availableWorkers.text = "Available Workers: " + str(main.AvailableWorkers)
	
	var SelectedTileType : TileManagerNode.RoomTypes = TileManager.Tiles.get(SelectorManager.selectedPos,-1)
	if selectedPos != SelectorManager.selectedPos:
		selectedPos = SelectorManager.selectedPos
		if SelectedTileType != null:
			for I in buildingPanel.get_children(): I.queue_free()
			var nameLabel = Label.new()
			buildingPanel.add_child(nameLabel)
			nameLabel.text = str(TileManagerNode.RoomTypes.find_key(SelectedTileType)).capitalize()
			if !ConstructionCrewManager.currentConstructions.has(selectedPos):
				if SelectedTileType == TileManagerNode.RoomTypes.Filled_Ground or SelectedTileType == TileManagerNode.RoomTypes.Filled_Root:
					var button = Button.new()
					buildingPanel.add_child(button)
					button.text = "DESTROY!!!!"
					if SelectedTileType == TileManagerNode.RoomTypes.Filled_Ground:
						button.pressed.connect(func():
							ConstructionCrewManager.startConstruction(selectedPos,TileManagerNode.RoomTypes.Emptied_Ground)
							selectedPos = Vector2i.ZERO
						)
					else:
						button.pressed.connect(func():
							ConstructionCrewManager.startConstruction(selectedPos,TileManagerNode.RoomTypes.Emptied_Root)
							selectedPos = Vector2i.ZERO
						)
				if SelectedTileType == TileManagerNode.RoomTypes.Emptied_Root:
					for I in RootBuildings:
						var button = Button.new()
						buildingPanel.add_child(button)
						button.text = str(TileManagerNode.RoomTypes.find_key(I)).capitalize()
						button.pressed.connect(func():
							ConstructionCrewManager.startConstruction(selectedPos,I)
							selectedPos = Vector2i.ZERO
						)
				if SelectedTileType == TileManagerNode.RoomTypes.Emptied_Ground:
					for I in GroundBuildings:
						var button = Button.new()
						buildingPanel.add_child(button)
						button.text = str(TileManagerNode.RoomTypes.find_key(I)).capitalize()
						button.pressed.connect(func():
							ConstructionCrewManager.startConstruction(selectedPos,I)
							selectedPos = Vector2i.ZERO
						)
