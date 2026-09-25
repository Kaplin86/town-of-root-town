extends Node

@export var tileManager : TileManagerNode

var hoveringPos : Vector2i

func _process(delta):
	var mousePos = $"..".get_global_mouse_position()
	hoveringPos = tileManager.Background.local_to_map(mousePos)
	print(tileManager.Tiles.get(hoveringPos,null))
