extends Area2D

onready var rt = get_owner()
var status = "no"
var offset := Vector2()
var mpos := Vector2()
var initpos := Vector2()

var y_off = -200
var height_limit = 500
var scroll_speed := 80

var mouse_in := "no"

var pos := {}
var size := {}

func init():
	
	pos["menu"] = rt.get_node("misc/menu").position
	size["menu"] = rt.get_node("misc/menu/ScrollContainer").rect_size
	
	var bla = rt.get_node("m/v/top/h/menu_button")
	pos["menu button"] = bla.rect_global_position
	size["menu button"] = bla.rect_size
	
	pos["upgrade button"] = rt.get_node("misc/tabs/v/upgrades").rect_global_position# + rt.get_node("misc/tabs/v").rect_position + rt.get_node("misc/tabs").rect_position
	size["upgrade button"] = rt.get_node("misc/tabs/v/upgrades").rect_size

func _input(ev):
	
	# drag map init
	if ev.is_action_pressed("ui_left_mouse_button"):
		status = "clicked"
	
	# exit menus
	if status == "clicked":
		
		mpos = get_global_mouse_position()
		
		# menu
		if rt.get_node("misc/menu").visible and mouse_out(pos["menu button"], size["menu button"]) and mouse_out(pos["menu"], size["menu"]):
			rt.get_node("misc/menu").hide()
		
		var upcon = rt.get_node(rt.gnupcon)
		if rt.get_node(rt.gnupcon).visible and mouse_out(pos["upgrade button"], size["upgrade button"]) and mouse_out(upcon.rect_global_position, upcon.rect_size):
			rt.get_node(rt.gnupcon).hide()
			rt.get_node(rt.gnupcon).go_back()
		
		status = "no"

func mouse_out(pos:Vector2, size:Vector2) -> bool:
	if ((mpos.x > pos.x + size.x) or (mpos.x < pos.x)) or ((mpos.y < pos.y) or (mpos.y > pos.y + size.y)):
		return true
	return false
