extends Node2D
class_name MainVariableHolder

var MaxHousing = 10
var Population = 10
var Food = 50
var Supplies = 50
var CurrentWorkerTeams = 1
var AvailableWorkers = 10
var maxWorkerTeams = 1

var peakPopulation = 0

func _on_construction_manager_done_building() -> void:
	MaxHousing = $TileManager.getMaxPopulation()

var reproduceDT = 0.0
func _process(delta: float) -> void:
	if Population > peakPopulation:
		peakPopulation = Population
	
	if !get_tree().paused:
		reproduceDT += delta
		if randf_range(0,5) <= reproduceDT / 100:
			reproduceDT =0 
			if Population < MaxHousing and Population >= 2:
				if !$DisasterManager.discontented:
					Population += 1
					AvailableWorkers += 1
	maxWorkerTeams = $TileManager.getMaxWorkerTeams()
	CurrentWorkerTeams = max(0,maxWorkerTeams - $ConstructionManager.currentConstructions.size())

func killOnePopulation():
	#print(Population)
	if Population > 0:
		Population -= 1
		if AvailableWorkers > 0:
			AvailableWorkers -= 1
		else:
			$TileManager.RemoveARandomEmployee()
	
	if Population == 0:
		$DisasterManager.Death()

var win = false

func _on_popup_close_requested() -> void:
	if win or Population <= 0:
		var resultingScene = load("res://scenes/results.tscn").instantiate()
		resultingScene.Tiles = $TileManager.Tiles
		resultingScene.CurrentPop = Population
		resultingScene.PeakPopulation = peakPopulation
		resultingScene.Win = win
		get_tree().change_scene_to_node(resultingScene)
		

func winCondition() -> void:
	win = true
