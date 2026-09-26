extends Camera2D

@export var tileManager : TileManagerNode

var wantedZoom = 1.58
var wantedPos = Vector2.ZERO
var speed = 500

func _on_tile_manager_done_generating():
	var tiles = tileManager.Tiles
	var TilePos = tiles.find_key(tileManager.RoomTypes.Capital)
	var Pos = tileManager.Background.map_to_local(TilePos)
	global_position = Pos
	wantedPos = Pos

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 5:
			wantedZoom *= 0.92
		if event.button_index == 4:
			wantedZoom *= 1.1
		wantedZoom = clamp(wantedZoom,0.58,5)

func _process(delta):
	zoom = lerp(zoom,Vector2.ONE * wantedZoom,min(delta * 5,1))
	global_position = lerp(global_position,wantedPos,min(delta * 15,1))
	
	if Input.is_action_pressed("down"):
		wantedPos.y += speed * delta
	if Input.is_action_pressed("up"):
		wantedPos.y -= speed * delta
	if Input.is_action_pressed("left"):
		wantedPos.x -= speed * delta
	if Input.is_action_pressed("right"):
		wantedPos.x += speed * delta
