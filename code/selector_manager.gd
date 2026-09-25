extends Node
class_name SelectorManagerNode

@export var tileManager : TileManagerNode

var hoveringPos : Vector2i
var selectedPos : Vector2i 
var dt = 0.0
func _process(delta):
	dt += delta
	var mousePos = $"..".get_global_mouse_position()
	hoveringPos = tileManager.Background.local_to_map(mousePos)
	#print(tileManager.Tiles.get(hoveringPos,null))
	var finalGlobal = tileManager.Background.map_to_local(hoveringPos)
	
	if selectedPos != null:
		$Inner.visible = true
		$Inner.rotation += delta
		$Inner.modulate = lerp(Color.WHITE,Color(1.572, 1.572, 1.572, 1.0),sin($Outer.rotation * 4) * 0.5 + 0.5)
		var secondGlobal = tileManager.Background.map_to_local(selectedPos)
		$Inner.global_position = lerp($Inner.global_position,secondGlobal,delta * 20)
	else:
		$Inner.visible = false
	
	
	$Outer.global_position = finalGlobal

func _unhandled_input(event):
	if Input.is_action_pressed("select"):
		if selectedPos != hoveringPos:
			print("truly selecting!!")
			selectedPos = hoveringPos
