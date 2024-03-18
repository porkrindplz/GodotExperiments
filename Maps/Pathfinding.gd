extends Node2D

class_name Pathfinding

var astar : AStarGrid2D
var collisionLayer : int = 1
var isInBuildMode : bool = true

func _ready()->void:
	var size = %TileMap.get_used_rect().size
	astar = AStarGrid2D.new()
	astar.size = size
	astar.cell_size = Vector2(32,32)
	astar.update()
	initialize_cells(size)
	
	astar.get_point_path(Vector2i(10,10), Vector2i(20,20))
	
	
func get_path_between(start_world: Vector2, end_world : Vector2):
	var start_pos = %TileMap.local_to_map(%TileMap.to_local(start_world))
	var end_pos = %TileMap.local_to_map(%TileMap.to_local(end_world))
	return astar.get_point_path(start_pos, end_pos)

func initialize_cells(size : Vector2i):
		for x in size.x:
			for y in size.y:
				var id = Vector2i(x,y)
				if %TileMap.get_cell_source_id(1, id) >= 0:
					astar.set_point_solid(Vector2i(x,y))

func _physics_process(delta):
	pass
			
