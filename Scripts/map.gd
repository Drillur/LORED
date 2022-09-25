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


func _ready() -> void:
	set_physics_process(false)


func init():
	
	var bla = rt.get_node("misc/tabs/v/menu")
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
		if rt.menu.visible and mouse_out(pos["menu button"], size["menu button"]) and mouse_out(rt.menu.rect_position, rt.menu.rect_size):
			rt.menu.hide()
		
		var upcon = rt.get_node(rt.gnupcon)
		if rt.get_node(rt.gnupcon).visible and mouse_out(pos["upgrade button"], size["upgrade button"]) and mouse_out(upcon.rect_global_position, upcon.rect_size * rt.scale):
			rt.get_node(rt.gnupcon).hide()
			rt.get_node(rt.gnupcon).go_back()
		
		status = "no"

func mouse_out(_pos:Vector2, _size:Vector2) -> bool:
	return ((mpos.x > _pos.x + _size.x) or (mpos.x < _pos.x)) or ((mpos.y < _pos.y) or (mpos.y > _pos.y + _size.y))
