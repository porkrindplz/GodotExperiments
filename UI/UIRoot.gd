extends CanvasLayer

@export var all_recipes:ResourceGroup

@onready var player = %Player
@onready var inventory_dialogue = %InventoryDialogue
@onready var crafting_dialogue = %CraftingDialogue

var _all_recipes:Array[Recipe] = []

func _ready():
	all_recipes.load_all_into(_all_recipes)

func _unhandled_input(event):
	if event.is_action_released("Inventory"):
		inventory_dialogue.open(player.inventory)
	
	if event.is_action_released("Crafting"):
		crafting_dialogue.open(_all_recipes,player.inventory)
