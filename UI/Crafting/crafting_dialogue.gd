class_name CraftingDialogue
extends PanelContainer

@export var slot_scene:PackedScene

@onready var recipe_list:ItemList = %RecipeList
@onready var ingredients_container:GridContainer = %IngredientsContainer
@onready var results_container:GridContainer = %ResultsContainer
@onready var craft_button = %CraftButton

var _inventory:Inventory
var _selected_recipe:Recipe

func open(recipes:Array[Recipe],inventory: Inventory):
	_inventory=inventory
	if visible: 
		_on_close_button_pressed()
		return
	show()
	Input.mouse_mode =Input.MOUSE_MODE_VISIBLE
	
	recipe_list.clear()
	for recipe in recipes:
		var index = recipe_list.add_item(recipe.name)
		recipe_list.set_item_metadata(index, recipe)
		
	recipe_list.select(0)
	_on_recipe_list_item_selected(0)
		
func _on_recipe_list_item_selected(index):
	_selected_recipe = recipe_list.get_item_metadata(index)
	ingredients_container.display(_selected_recipe.ingredients)
	results_container.display(_selected_recipe.results)	
	
	craft_button.disabled = not _inventory.has_all(_selected_recipe.ingredients)

func _on_close_button_pressed():
	hide()

func _on_craft_button_pressed():
	for item in _selected_recipe.ingredients:
		_inventory.remove_item(item)
	for item in _selected_recipe.results:
		_inventory.add_item(item)
		
	craft_button.disabled = not _inventory.has_all(_selected_recipe.ingredients)
