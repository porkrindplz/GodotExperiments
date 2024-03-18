extends CharacterBody2D

@onready var ai = $UtilityAIAgent
@onready var distance_to_player = $UtilityAIAgent/Sensors/DistanceToPlayer
@onready var vision_sensor = $"UtilityAIAgent/Sensors/Vision Sensor"

@export var speed = 500

var current_action

var target_move_position:Vector2
var path_to_target:Array[Vector2] = []

var actionMap = {
	"MoveTowards": _move_towards,
	"Wander": _wander
}

func _physics_process(delta):
	
	ai.evaluate_options(delta)
	ai.update_current_behaviour()
	
	var new_action = ai.get_current_action_node()
	if new_action != current_action and new_action != null:
		current_action = new_action
	
	if current_action == null:
		return
		
	if vision_sensor.num_entities_found > 0:
		target_move_position = vision_sensor.unoccluded_areas[0].global_position
		
	actionMap[current_action.get_name()].call()
	
	move_and_slide()

func _move_towards():
	var dir = (target_move_position - global_position).normalized()
	velocity = dir * speed
	pass
	
func _wander():
	pass
