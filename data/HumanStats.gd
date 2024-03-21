class_name HumanStats

@export var id:int = 0
@export var human_name:String = "Succ. Chin. Meal"
@export var age:int = 25
@export var mood:String = "Sad"
@export var hunger:int = 10
@export var energy:int = 75
@export var sanity:int = 100
@export var health:int = 100

func add_hunger(diff: int):
	hunger = clampi(hunger + diff, 0, 100)
	
func add_sanity(diff: int):
	sanity = clampi(sanity + diff, 0, 100)
	
func add_energy(diff: int):
	energy = clampi(energy + diff, 0, 100) 

# Stores a value between -100 and 100 for the opinions of each entity
var relationships:Dictionary = {}
