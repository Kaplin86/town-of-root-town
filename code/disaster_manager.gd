extends Node
class_name DisasterManagerNode



var famined = false
var discontented = false
var earthquakeed = false

func Famine():
	$Popup.popup()
	$"../TimeManager".pause()
	$Popup/Famine/Title.text = "FAMINE."
	$Popup/Famine/Desc.text = "Food will no longer be generated for the next "+str(int($FamineTimer.wait_time))+" seconds.

Hope you stocked up!"
	famined = true
	$FamineTimer.start()

func Discontent():
	$Popup.popup()
	$"../TimeManager".pause()
	$Popup/Famine/Title.text = "DISCONTENT."
	$Popup/Famine/Desc.text = "Population is unable to increase for the next "+str(int($DiscontentTimer.wait_time))+" seconds.


Aw shucks."
	discontented = true
	$DiscontentTimer.start()

func Disease():
	$Popup.popup()
	$"../TimeManager".pause()
	$Popup/Famine/Title.text = "SICKNESS."
	
	var tileManager : TileManagerNode = $"../TileManager"
	var amountToKill = max($"..".Population - (tileManager.Tiles.values().count(TileManagerNode.RoomTypes.Hospital) * 15),0)
	for I in amountToKill:
		$"..".killOnePopulation()
	$Popup/Famine/Desc.text = "A sickness has INFECTED everybody. Luckily, 15 people will be saved for every hospital you have.
	
	Death Count: " + str(int(amountToKill))

func Earthquake():
	$Popup.popup()
	$"../TimeManager".pause()
	$Popup/Famine/Title.text = "EARTHQUAKE."
	$Popup/Famine/Desc.text = "Uh oh! Earthquake!! woooaAaaAhhAHhhahhahaa!!11
	
	(you can no longer empty tiles with construction crews for "+str(int($EarthquakeTimer.wait_time)) +")"
	$EarthquakeTimer.start()
	earthquakeed = true

func Collapse():
	$Popup.popup()
	$"../TimeManager".pause()
	$Popup/Famine/Title.text = "COLLAPSE."
	$Popup/Famine/Desc.text = "The end is now. The grand storms above weakened the ground, collapsing the little town of RootTown as if it was never there. 

However, it does not have to end this way.
Click to try again."
	$"..".Population = 0
	

func Death():
	$Popup.popup()
	$"../TimeManager".pause()
	$Popup/Famine/Title.text = "DEATH."
	$Popup/Famine/Desc.text = "Everyone is dead. 

However, it does not have to end this way.
Click to try again."
	#$"..".Population = 0

func _on_famine_timer_timeout() -> void: famined = false
func _on_discontent_timer_timeout() -> void: discontented = false
func _on_earthquake_timer_timeout() -> void: earthquakeed = false

func _on_famine_arrival_timeout() -> void: Famine()
func _on_discontent_arrival_timeout() -> void: Discontent()
func _on_disease_arrival_timeout() -> void: Disease()
func _on_earthquake_arrival_timeout() -> void: Earthquake()
func _on_collapse_arrival_timeout() -> void: Collapse()
