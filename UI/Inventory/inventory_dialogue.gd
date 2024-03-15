class_name InventoryDialogue
extends PanelContainer

@export var slot_scene:PackedScene
@onready var grid_container :ItemGrid= %GridContainer

func open(inventory: Inventory):
	if visible: 
		_on_close_button_pressed()
		return
	show()
	Input.mouse_mode =Input.MOUSE_MODE_VISIBLE
	
	grid_container.display(inventory.get_items())

func _on_close_button_pressed():
	hide()

