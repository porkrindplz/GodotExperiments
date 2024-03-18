extends CharacterBody2D

var isFacingLeft: bool = false
var walk_speed: float = 75
var run_multiplier: float = 3
var target_velocity = Vector2.ZERO
var inventory: Inventory = Inventory.new()
var mouse_control = true

@onready var animated_sprite_2d = $AnimatedSprite2D

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
	
	if follow_cursor:
		if selected:
			target = get_global_mouse_position()
	
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
