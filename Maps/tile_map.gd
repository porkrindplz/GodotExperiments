extends TileMap

class_name ProcMapGen

enum ETerrainType{Grass=0, Cave=1, City=2}
enum ETileType{Walkable = 0, Nonwalkable = 1}
enum ESurfaceType{Wall=0, Water =1}

#Terrain
@export var _terrain = ETerrainType.Grass

#Tile Data
#@onready var walkable: TileMap = %Walkable
#@onready var non_walkable: TileMap = %NonWalkable

const WALKABLE = preload("res://Maps/TileSets/Walkable.tres")
const OBSTACLES = preload("res://Maps/TileSets/Obstacles.tres")

#Generation Dials
@export var _xSize = 49 #half extent
@export var _ySize = 49
@export var _fractal_octaves: int = 2
@export var _fractal_gain: float = 8
@export var _fractal_ping_pong_strength: float = 0.15
@export var _fractal_lacunarity: float = 1.4

#Spawnable Objects
@export var _spawnable_items: Array[Item] = []
const PICKUP = preload("res://Interactive/Pickup.tscn")

var rng = RandomNumberGenerator.new()

var _val = 0
var _min = 0
var _max = 0

var TILESIZE = 32
var TILEOFFSET = 16 # Centers tile

func _ready():
	rng.randomize()
	
	var _noise = FastNoiseLite.new()
	
	_noise.seed = rng.randf_range(0, 999999)
	_noise.fractal_octaves = _fractal_octaves # original 2
	_noise.fractal_gain = _fractal_gain # original 8
	_noise.fractal_ping_pong_strength = _fractal_ping_pong_strength # original 0.15
	_noise.fractal_lacunarity = _fractal_lacunarity # original 1.4
	
	
	for i in range( - _xSize, _xSize - 1):
		for j in range( - _ySize, _ySize - 1):
			_val = _noise.get_noise_2d(i, j)
			if _val < - 0.2:
				#walls
				_max += 1
				set_cell(1, Vector2i(i, j), ETileType.Nonwalkable, Vector2i(ESurfaceType.Wall, _terrain))
			elif _val > 0.3:
				#water
				_max += 1
				set_cell(1, Vector2i(i, j), ETileType.Nonwalkable, Vector2i(ESurfaceType.Water, _terrain))
			else:
				#ground
				set_cell(0, Vector2i(i, j), ETileType.Walkable, Vector2i(0, _terrain))
				if rng.randi_range(1, 100) == 1:
					if _spawnable_items.size() > 0:
						var rand_item = rng.randi_range(0, _spawnable_items.size() - 1)
						GameManager.spawn_pickup(_spawnable_items[rand_item],Vector2(i, j) * TILESIZE + Vector2(16, 16))

	print(_min)
	print(_max)
