extends Node2D
class_name MainVariableHolder

var MaxHousing = 10
var Population = 10
var Food = 50
var Supplies = 50
var CurrentWorkerTeams = 1
var AvailableWorkers = 10
var maxWorkerTeams = 1


func _on_construction_manager_done_building() -> void:
	MaxHousing = $TileManager.getMaxPopulation()

var reproduceDT = 0.0
func _process(delta: float) -> void:
	reproduceDT += delta
	if randf_range(0,5) <= reproduceDT / 100:
		reproduceDT =0 
		if Population < MaxHousing and Population >= 2:
			Population += 1
			AvailableWorkers += 1
	maxWorkerTeams = $TileManager.getMaxWorkerTeams()
	CurrentWorkerTeams = max(0,maxWorkerTeams - $ConstructionManager.currentConstructions.size())

func killOnePopulation():
	if Population > 0:
		Population -= 1
		if AvailableWorkers > 0:
			AvailableWorkers -= 1
		else:
			$TileManager.RemoveARandomEmployee()
	
