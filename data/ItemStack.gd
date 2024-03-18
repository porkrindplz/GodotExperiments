extends Resource
class_name ItemStack

var Item:Item
var _count:int
var max_size:int = 64

func _init(item:Item, count:int, size:int):
	Item = item
	_count = count
	max_size = size

func get_count() -> int:
	return _count
	
func add_item():
	if _count < max_size:
		_count += 1
		
func remove_item():
	if _count >= 1:
		_count -= 1
