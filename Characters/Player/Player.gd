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
var current_id_path:Array[Vector2i]
var target_position

func _ready():
	set_selected(selected)

func set_selected(value):
	selected = value
	selection_box.visible = value
	
func _input(event):
	if event.is_action_pressed("SelectSecondary"):
		follow_cursor = true
		var id_path = pathfinding.get_id_path(position,target).slice(1)
		if id_path.is_empty()==false:
			print(id_path)
			current_id_path = id_path
	if event.is_action_released("SelectSecondary"):
		follow_cursor = false

func on_item_picked_up(item: Item):
	inventory.add_item(item)
	
func _physics_process(delta) -> void:
	if mouse_control: handle_mouse_control()
	else: handle_keyboard_control()
	
func handle_mouse_control():
	if follow_cursor:
		if selected:
			target = get_global_mouse_position()
		if current_id_path.is_empty(): return
		var target_position = pathfinding.get_target_position(current_id_path.front())
		var direction = position.direction_to(target_position)
		velocity = direction * walk_speed
		if position.distance_to(target_position)<1:
			current_id_path.pop_front()
		animated_sprite_2d.animation = "walk_right"
		if position.distance_to(target) > 15:
			move_and_slide()
		else:
			animated_sprite_2d.animation = "idle"
		return

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
