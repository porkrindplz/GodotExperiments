extends StaticBody2D

@export var item_to_extract:Item
@export var quantity_to_extract:int

var total_time = 5
var current_time
var units = 0
@onready var progress_bar = %ProgressBar
@onready var timer = %Timer

const PICKUP = preload("res://Interactive/Pickup.gd")

var smooth_progress: bool = true

func _ready():
	current_time = total_time
	progress_bar.max_value = total_time
	
func _process(delta):
	progress_bar.value= current_time
	if current_time <= 0:
		fully_extracted()
		
func _on_work_area_body_entered(body):
	if (body is CharacterBody2D) and (body.is_in_group("Beings")):
		units += 1
		start_extracting()	

func fully_extracted():
	for qty in quantity_to_extract:
		GameManager.spawn_pickup(item_to_extract,position)
	queue_free()
func start_extracting():
	timer.start()

func _on_work_area_body_exited(body):
	if (body is CharacterBody2D) and (body.is_in_group("Beings")):
		units-=1
		if units<=0:
			timer.stop()

func _on_timer_timeout():
	current_time -= 1 * units
	if smooth_progress:
		var tween = get_tree().create_tween()
		tween.tween_property(progress_bar, "value", current_time,0.5).set_trans(tween.TRANS_LINEAR)
