extends Node

const MAPSIZEX = 200
const MAPSIZEY = 400

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
	
	await doWorm(Vector2(100,0), 10, 90)
	
	while activeWorms != []:
		await get_tree().create_timer(0.5).timeout
	
	_generate()
	
func _ready():
	_generate()
	

func doWorm(startPos, thickness, angleOffset):
	var myID = wormID
	wormID += 1
	activeWorms.append(myID)
	var worm_pos: Vector2 = startPos
	var worm_dist = randi_range(1,200 - (200 / thickness))
	
	for C in worm_dist:
		if randi_range(0,10) == 5:
			await RenderingServer.frame_post_draw
		var angle = noise.get_noise_2d(worm_pos.x * 0.5, worm_pos.y) * PI * 0.8
		angle += deg_to_rad(angleOffset)
		angle += randf_range(-0.25, 0.25)
		worm_pos += Vector2(cos(angle) * 1.2, sin(angle)) * 1.5
		for I in thickness:
			var offset = (I * 0.5) - thickness
			Tiles[Vector2i(worm_pos) - Vector2i(offset,0)] = "Root"
		
		if randf_range(0,1) <= 0.1 and thickness > 2 and C > 30:
			doWorm(worm_pos,thickness - 2,angleOffset + randf_range(-60,60))
			if randf_range(0,1) < 0.5:
				doWorm(worm_pos,thickness - 2,angleOffset + randf_range(-60,60))
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
