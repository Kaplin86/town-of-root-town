extends Node
class_name TileManagerNode

@export var Background : TileMapLayer
@export var Coverground : TileMapLayer 

const MAPSIZEX = 40
const MAPSIZEY = 40

enum RoomTypes {
	Filled_Ground,
	Filled_Root,
	Emptied_Ground,
	Emptied_Root,
	Pathway,
	House,
	Garden,
	Capital,
	Hospital,
	Construction_Office
}


var Tiles : Dictionary[Vector2i,RoomTypes]

var noise = FastNoiseLite.new()

var activeWorms = []
var wormID = 0

signal DoneGenerating

func _generate():
	Tiles = {}
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = 0.56
	
	for x in MAPSIZEX:
		for y in MAPSIZEY:
			Tiles[Vector2i(x,y)] = RoomTypes.Filled_Ground
	
	doWorm(Vector2(20,0), 4, 90)
	
	while activeWorms != []:
		await get_tree().process_frame
	
	var lowestY = 0
	var lowestX = 0
	for x in MAPSIZEX:
		for y in MAPSIZEY:
			if Tiles[Vector2i(x,y)] == RoomTypes.Filled_Root:
				if y >= lowestY:
					lowestY = y
					lowestX = x
	Tiles[Vector2i(lowestX,lowestY)] = RoomTypes.Capital
	
	DoneGenerating.emit()
	
func _ready():
	_generate()

func doWorm(startPos, thickness, angleOffset):
	var myID = wormID
	wormID += 1
	activeWorms.append(myID)
	var worm_pos: Vector2 = startPos
	var worm_dist = {
		4: round((18.0/40.0) * MAPSIZEY),
		3: round((10.0/40.0) * MAPSIZEY),
		2: round((5.0/40.0) * MAPSIZEY),
		1: round((5.0/40.0) * MAPSIZEY),
		0: 0,
	}[thickness]
	
	for C in worm_dist:
		var angle = noise.get_noise_2d(worm_pos.x * 0.5, worm_pos.y) * PI * 0.8
		angle += deg_to_rad(angleOffset)
		angle += randf_range(-0.25, 0.25)
		worm_pos += Vector2(cos(angle) * 1.2, sin(angle)) * 1
		for I in thickness:
			var offset = I - (thickness * 0.5)
			if Tiles.get(Vector2i(worm_pos) + Vector2i(offset,0),null) == RoomTypes.Filled_Ground:
				Tiles[Vector2i(worm_pos) + Vector2i(offset,0)] = RoomTypes.Filled_Root
		
		if thickness == 4 and C == round(worm_dist / 2.0):
			var sideOffset
			if randi_range(0,1) == 1:
				sideOffset = randf_range(-60,-30)
			else:
				sideOffset = randf_range(30,60)
			doWorm(worm_pos,thickness - 1,angleOffset + sideOffset)
		
		if C == worm_dist - 1:
			var sideOffset
			if randi_range(0,1) == 1:
				sideOffset = randf_range(-60,-30)
			else:
				sideOffset = randf_range(30,60)
			doWorm(worm_pos,thickness - 1,angleOffset + sideOffset)
			doWorm(worm_pos,thickness - 1,angleOffset + randf_range(-60,60))
			thickness -= 1
	
	activeWorms.erase(myID)

func _process(delta):
	_display()

func _display():
	Coverground.clear()
	Background.clear()
	for I in Tiles:
		var val : RoomTypes = Tiles[I]
		if val == RoomTypes.Filled_Ground:
			Coverground.set_cell(I,0,Vector2i(0,0))
		elif val == RoomTypes.Filled_Root:
			Coverground.set_cell(I,0,Vector2i(1,0))
		elif val == RoomTypes.Capital:
			Background.set_cell(I,1,Vector2i(0,0),1)
		elif val == RoomTypes.Emptied_Ground:
			Background.set_cell(I,0,Vector2i(0,0))
		elif val == RoomTypes.Emptied_Root:
			Background.set_cell(I,0,Vector2i(1,0))
		elif val == RoomTypes.Pathway:
			Background.set_cell(I,1,Vector2i(0,0),2)
		elif val == RoomTypes.House:
			Background.set_cell(I,1,Vector2i(0,0),4)
		elif val == RoomTypes.Garden:
			Background.set_cell(I,1,Vector2i(0,0),3)
