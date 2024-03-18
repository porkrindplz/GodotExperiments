class_name Inventory

var _content:Array[ItemStack] = []

func add_item(item:Item):
	for ite in _content:
		if ite.Item.name == item.name && ite.get_count() < ite.max_size:
			ite.add_item()
			return
	var p = ItemStack.new(item, 1, 64)
	_content.append(p)
	
func remove_item(item:Item):
	for ite in _content:
		if ite.Item.name == item.name:
			if ite.get_count() == 1:
				_content.erase(ite)
				return
			ite.remove_item()
	
func get_items() ->Array[ItemStack]:
	return _content

func has_all(items:Array[ItemStack]) ->bool:
	var correct = 0
	for item in items:
		for c in _content:
			if item.Item.name == c.Item.name && c.get_count() >= item.get_count():
				correct += 1
		
	return correct == items.size()
