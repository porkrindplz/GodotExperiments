extends Camera2D

@onready var player = %Player
var follow_player:bool =false

#CameraControls
@export var MOVE_SPEED  = 20.0
@export var ZOOM_SPEED = 20.0
@export var ZOOM_MARGIN = 0.1
@export var ZOOM_MIN = 0.5
@export var ZOOM_MAX = 3.0

var zoom_factor = 1.0
var zoom_pos=Vector2()
var zooming = false

#MouseControls
var mouse_pos= Vector2()
var mouse_pos_global= Vector2()

var mouse_held: bool
var start= Vector2()
var startV= Vector2()
var end= Vector2()
var endV= Vector2()
@onready var selection_box = %SelectionBox

signal area_selected
signal start_move_selected

func _ready():
	connect("area_selected", Callable(get_parent(), "_on_area_selected"))

func _process(delta):
	#Zoom Controls
	if(!follow_player):
		var input_x = int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left"))
		var input_y = int(Input.is_action_pressed("ui_down"))-int(Input.is_action_pressed("ui_up"))
		position.x = lerp(position.x,position.x + input_x*MOVE_SPEED * zoom.x,MOVE_SPEED*delta)
		position.y = lerp(position.y,position.y + input_y*MOVE_SPEED * zoom.y,MOVE_SPEED*delta)
		
		zoom.x = lerp(zoom.x,zoom.x*zoom_factor,ZOOM_SPEED * delta)
		zoom.y = lerp(zoom.y,zoom.y*zoom_factor,ZOOM_SPEED * delta)
		zoom.x = clamp(zoom.x,ZOOM_MIN,ZOOM_MAX)
		zoom.y = clamp(zoom.y,ZOOM_MIN,ZOOM_MAX)
		
		if !zooming:
			zoom_factor = 1.0
	#FollowPlayer		
	else: position = lerp(position, player.position, 0.1)
	
	if (Input.is_action_just_pressed("SelectMain")):
		start = mouse_pos_global
		startV = mouse_pos
		mouse_held = true
	if mouse_held:
		end = mouse_pos_global
		endV = mouse_pos
		draw_area()
	if (Input.is_action_just_released("SelectMain")):
		if startV.distance_to(mouse_pos) > 20:
			end = mouse_pos_global
			endV = mouse_pos
			mouse_held = false
			draw_area(false)
			emit_signal("area_selected", self)
		else:
			end = start
			mouse_held = false
func _input(event):
	if abs(zoom_pos.x - get_global_mouse_position().x)>ZOOM_MARGIN:
		zoom_factor = 1.0
	if abs(zoom_pos.y - get_global_mouse_position().y)>ZOOM_MARGIN:
		zoom_factor = 1.0
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			zooming = true
			if event.is_action("WheelDown"):
				zoom_factor-=0.01*ZOOM_SPEED
				zoom_pos = get_global_mouse_position()
			if event.is_action("WheelUp"):
				zoom_factor+=0.01*ZOOM_SPEED
				zoom_pos = get_global_mouse_position()
		else: zooming = false
	if event is InputEventMouse:
		mouse_pos = event.position
		mouse_pos_global = get_global_mouse_position()
		
func draw_area(s=true):
	selection_box.size = Vector2(abs(startV.x - endV.x), abs(startV.y - endV.y))
	var pos = Vector2()
	pos.x = min(startV.x, endV.x)
	pos.y = min(startV.y, endV.y)
	selection_box.position = pos
	selection_box.size *= int(s)
	
func _on_area_selected(object):
	pass
