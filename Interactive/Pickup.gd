extends Node2D
class_name Pickup

var _item: Item
	
func spawn_item(item):
	_item = item
	print(_item.name)
	var instance = _item.scene.instantiate()
	add_child(instance)

func _on_area_2d_body_entered(body):
	if body.has_method("on_item_picked_up"):
		print("Trying to pick up " + _item.name)
		body.on_item_picked_up(_item)
		queue_free()
