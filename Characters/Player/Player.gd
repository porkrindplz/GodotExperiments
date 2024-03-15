extends CharacterBody2D

var walk_speed: float = 75	
var run_multiplier: float = 3
var target_velocity = Vector2.ZERO
var inventory: Inventory = Inventory.new()

@onready var animated_sprite_2d = $AnimatedSprite2D

var isFacingLeft:bool = false



func on_item_picked_up(item:Item):
	inventory.add_item(item)
	
func _physics_process(delta)->void:
	var direction = Vector2.ZERO
	var speed_multiplier = 1
	
	if Input.is_action_pressed("move_up"):
		direction.y -=1
	if Input.is_action_pressed("move_down"):
		direction.y +=1
	if Input.is_action_pressed("move_left"):
		direction.x-=1
	if Input.is_action_pressed("move_right"):
		direction.x+=1
	if direction!= Vector2.ZERO:
		direction = direction.normalized()
		if Input.is_action_pressed("run"):
			speed_multiplier *=run_multiplier
		
	if direction!=Vector2.ZERO:
		animated_sprite_2d.animation = "walk_right"
		animated_sprite_2d.speed_scale=speed_multiplier
	else: animated_sprite_2d.animation = "idle"
		
	if direction.x>0: 
		isFacingLeft = false
		animated_sprite_2d.flip_h=false
	elif direction.x<0: 
		isFacingLeft = true
		animated_sprite_2d.flip_h=true
	

	
	target_velocity = direction*walk_speed*speed_multiplier
	
	velocity = target_velocity
	move_and_slide()
	
	
