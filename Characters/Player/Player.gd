extends CharacterBody2D

var isFacingLeft: bool = false
var walk_speed: float = 75
var run_multiplier: float = 3
var target_velocity = Vector2.ZERO
var inventory: Inventory = Inventory.new()
var mouse_control = true

@onready var animated_sprite_2d = $AnimatedSprite2D

# Stats
@export var id:int = 0
@export var human_name:String = "Succ. Chin. Meal"
@export var age:int = 25
@export var hunger:int = 10
@export var energy:int = 75
@export var health:int = 100

# Stores a value between -100 and 100 for the opinions of each entity
var relationships:Dictionary = {}

# AI
@onready var ai = $UtilityAIAgent
@onready var pickup_sensor = $UtilityAIAgent/Sensors/PickupSensor

#Mousecontrol
@export var selected = false
@onready var selection_box = %SelectionBox
@onready var target = position
var follow_cursor = false

#Pathfinding
@onready var pathfinding = get_node("/root/Main/Pathfinding")
var current_path:PackedVector2Array
var target_position

func _ready():
	set_selected(selected)

func set_selected(value):
	selected = value
	selection_box.visible = value
	
func _input(event):
	if event.is_action_pressed("SelectSecondary") and selected:
		follow_cursor = true
		target = get_global_mouse_position()
		var path = pathfinding.get_path_between(position,target)
		if path.is_empty()==false:
			print(path)
			current_path = path
	if event.is_action_released("SelectSecondary") and selected:
		follow_cursor = false

func on_item_picked_up(item: Item):
	inventory.add_item(item)
	
func _physics_process(delta) -> void:
	if mouse_control: handle_mouse_control()
	else: handle_keyboard_control()
	
func handle_mouse_control():
	if follow_cursor and selected:
		target = get_global_mouse_position()
	_move()

func _move():
	if !current_path.is_empty():
		var target_position = current_path[0]
		var direction = position.direction_to(target_position)
		velocity = direction * walk_speed
		if position.distance_to(target_position)<1:
			current_path.remove_at(0)
		animated_sprite_2d.animation = "walk_right"
	else:
		velocity = Vector2.ZERO
		animated_sprite_2d.animation = "idle"
	move_and_slide()

func handle_keyboard_control():
	var direction = Vector2.ZERO
	var speed_multiplier = 1
	
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		if Input.is_action_pressed("run"):
			speed_multiplier *= run_multiplier
		
	if direction != Vector2.ZERO:
		animated_sprite_2d.animation = "walk_right"
		animated_sprite_2d.speed_scale = speed_multiplier
	else: animated_sprite_2d.animation = "idle"
		
	if direction.x > 0:
		isFacingLeft = false
		animated_sprite_2d.flip_h = false
	elif direction.x < 0:
		isFacingLeft = true
		animated_sprite_2d.flip_h = true
	
	target_velocity = direction * walk_speed * speed_multiplier
	
	velocity = target_velocity
	move_and_slide()


func _on_sleep_timer_timeout():
	energy = max(0, energy-1)

func _on_hunger_timer_timeout():
	hunger = max(0, hunger-1)

func _on_age_timer_timeout():
	age += 1
