extends PanelContainer

@onready var texture_rect:TextureRect = %TextureRect

func display(item: ItemStack):
	texture_rect.texture = item.Item.icon
	%AmountLabel.text = str(item.get_count())

func display_single(item: Item):
	texture_rect.texture = item.icon
	%AmountLabel.text = 1
