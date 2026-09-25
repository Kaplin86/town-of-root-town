extends Camera2D

@export var tileManager : TileManagerNode

func _on_tile_manager_done_generating():
	var tiles = tileManager.Tiles
	var TilePos = tiles.find_key(tileManager.RoomTypes.Capital)
	var Pos = tileManager.Background.map_to_local(TilePos)
	global_position = Pos
