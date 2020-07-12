extends Label

var my_lored : String
var fps = 0.0
onready var rt = get_node("/root/Root")

func init(x : String) -> void:
	
	# x will equal a lored's short variable like "coal" or "jo"
	
	$sprite.set_texture(gv.sprite[x])
	add_color_override("font_color", rt.r_lored_color(x))
	my_lored = x
	text = ""

func _physics_process(delta):
	
	# catches
	if not rt.get_node("map/loreds").lored[my_lored].visible: return
	if not get_parent().visible or not visible: return
	
	fps += delta
	if fps < rt.FPS: return
	fps -= rt.FPS
	
	if gv.menu.option["resource_bar_net"]:
		text = rt.get_node("map/loreds").lored[my_lored].get_node("net").text
	else:
		text = gv.g[my_lored].r.toString()
	
	if not gv.menu.option["status_color"]: return
	
	var color = rt.get_node("map/loreds").lored[my_lored].get_node("status").modulate
	if color == Color(1,0,0,0):
		color = Color(.5,.5,.5,1)
	elif color == Color(1,0,0,0.5):
		color = Color(1,0,0, 1)
	elif color == Color(1,1,0,0.5):
		color = Color(1,1,0,1)
	
	add_color_override("font_color", color)

