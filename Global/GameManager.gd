extends Node

const PICKUP = preload ("res://Interactive/Pickup.tscn")

func spawn_pickup(item: Item, pos: Vector2) -> Pickup:
	var pickup: Pickup = PICKUP.instantiate()
	pickup.spawn_item(item)
	pickup.position = pos
	add_child.call_deferred(pickup)
	return pickup
