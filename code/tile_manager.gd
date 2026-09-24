extends Node

const MAPSIZEX = 40
const MAPSIZEY = 40

var Tiles : Dictionary[Vector2i,String]

var noise = FastNoiseLite.new()

var activeWorms = []
var wormID = 0

func _generate():
	Tiles = {}
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = 0.56
	
	for x in MAPSIZEX:
		for y in MAPSIZEY:
			Tiles[Vector2i(x,y)] = "Dirt"
	
	await doWorm(Vector2(20,0), 4, 90)
	
	while activeWorms != []:
		await get_tree().create_timer(0.5).timeout
	
	await get_tree().create_timer(0.3).timeout
	_generate()
	
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
		if randi_range(0,10) == 5:
			await RenderingServer.frame_post_draw
		var angle = noise.get_noise_2d(worm_pos.x * 0.5, worm_pos.y) * PI * 0.8
		angle += deg_to_rad(angleOffset)
		angle += randf_range(-0.25, 0.25)
		worm_pos += Vector2(cos(angle) * 1.2, sin(angle)) * 1
		for I in thickness:
			var offset = I - (thickness * 0.5)
			Tiles[Vector2i(worm_pos) + Vector2i(offset,0)] = "Root"
		
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
	$"../CoveringGround".clear()
	for I in Tiles:
		var val = Tiles[I]
		if val == "Root":
			$"../CoveringGround".set_cell(I,0,Vector2(1,0))
		else:
			$"../CoveringGround".set_cell(I,0,Vector2(0,0))
