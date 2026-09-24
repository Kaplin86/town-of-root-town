extends Node

const MAPSIZEX = 200
const MAPSIZEY = 400



var Tiles : Dictionary[Vector2i,String]
@export var NoiseThreshold = 0.0

func _generate():
	var noise = FastNoiseLite.new()
	noise.seed = 0
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	#noise.cellular_return_type = FastNoiseLite.RETURN_CELL_VALUE
	noise.fractal_gain = 0.39
	noise.frequency = 0.05
	for x in MAPSIZEX:
		var halfwayPercent = inverse_lerp(0,MAPSIZEX,x) #for later
		halfwayPercent -= 0.5 #for later
		halfwayPercent = abs(halfwayPercent) - 0.2
		
		for y in MAPSIZEY:
			var verticalPercent = inverse_lerp(0,MAPSIZEY,y)
			
			
			if noise.get_noise_2d(x ,y * 0.8) >= NoiseThreshold + (halfwayPercent * 3) + (verticalPercent * 0.8):
				Tiles[Vector2i(x,y)] = "Root"
			else:
				Tiles[Vector2i(x,y)] = "Dirt"
	_display()
	await get_tree().create_timer(0.2).timeout
	_generate()
	
func _ready():
	_generate()
	

func _display():
	$"../CoveringGround".clear()
	for I in Tiles:
		var val = Tiles[I]
		if val == "Root":
			$"../CoveringGround".set_cell(I,0,Vector2(1,0))
		else:
			$"../CoveringGround".set_cell(I,0,Vector2(0,0))
