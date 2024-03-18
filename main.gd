extends Node2D

var beings=[]

func _ready():
	beings = get_tree().get_nodes_in_group("Beings")

func _on_area_selected(object):
	var start = object.start
	var end = object.end
	var area = []
	area.append(Vector2(min(start.x,end.x),min(start.y,end.y)))
	area.append(Vector2(max(start.x,end.x),max(start.y,end.y)))
	var ut = get_units_in_area(area)
	for b in beings:
		b.set_selected(false)
	for b in ut:
		b.set_selected(!b.selected)
	
func get_units_in_area(area):
	var u = []
	for unit in beings:
		if (unit.position.x>area[0].x) and (unit.position.x<area[1].x):
			if (unit.position.y>area[0].y) and (unit.position.y<area[1].y):
				u.append(unit)
	return u
