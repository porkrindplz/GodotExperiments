extends Node2D

class_name ProcMapGen

#Tile Data
@onready var walkable: TileMap = %Walkable
@onready var non_walkable: TileMap = %NonWalkable

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
				_max += 1
				non_walkable.set_cell(0, Vector2i(i, j), 0, Vector2i(1, 2))
			elif _val > 0.3:
				_max += 1
				non_walkable.set_cell(0, Vector2i(i, j), 0, Vector2i(2, 2))
			else:
				walkable.set_cell(0, Vector2i(i, j), 0, Vector2i(3, 0))
				if rng.randi_range(1, 100) == 1:
					if _spawnable_items.size() > 0:
						var rand_item = rng.randi_range(0, _spawnable_items.size() - 1)
						var pickup:Pickup =PICKUP.instantiate()
						pickup.spawn_item(_spawnable_items[rand_item])
						pickup.position = Vector2(i, j) * TILESIZE + Vector2(16, 16)
						get_parent().get_node("Items").add_child.call_deferred(pickup)

	print(_min)
	print(_max)