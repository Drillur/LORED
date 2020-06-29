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
	
	if rt.menu.option["resource_bar_net"]:
		text = rt.get_node("map/loreds").lored[my_lored].get_node("net").text
	else:
		text = fval.f(gv.g[my_lored].r)
	
	if not rt.menu.option["status_color"]: return
	
	self.add_color_override("font_color", rt.get_node("map/loreds").lored[my_lored].r_status_indicator("resource bar"))
	#if text == "0": text = ""

