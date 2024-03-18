class_name Recipe
extends Resource

@export var name:String
@export var ingredients:Array[Item] = []
@export var results:Array[Item] = []

var _ingredients_stacked:Array[ItemStack] = []
var _results_stacked:Array[ItemStack] = []

func get_results_stacked() -> Array[ItemStack]:
	if _results_stacked == []:
		_results_stacked = group_items_into_stacks(results)
	return _results_stacked
	
func get_ingredients_stacked() -> Array[ItemStack]:
	if _ingredients_stacked == []:
		_ingredients_stacked = group_items_into_stacks(ingredients)
	return _ingredients_stacked
	

func group_items_into_stacks(items: Array[Item]):
	var stacks = {}
	for item in items:
		if stacks.has(item):
			stacks[item] += 1
		else:
			stacks[item] = 1
	var itemstacks:Array[ItemStack] = []
	for key in stacks:
		itemstacks.append(ItemStack.new(key, stacks[key], 64))
	return itemstacks
