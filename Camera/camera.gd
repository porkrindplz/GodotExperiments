extends Node2D

@onready var player = %Player

func _process(delta):
   position = lerp(position,player.position,0.1)
