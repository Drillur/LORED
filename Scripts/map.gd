extends Area2D

onready var rt = get_owner()
var status = "no"
var dragging = ""
var offset := Vector2()
var mpos := Vector2()
var initpos := Vector2()

var y_off = -200
var height_limit = 500
var scroll_speed := 40

var mouse_in := "no"

var menu_closed_time := 0.0

var pos := {}
var size := {}

func init():
	
	pos["menu"] = rt.get_node("misc/menu").position
	size["menu"] = rt.get_node("misc/menu/ScrollContainer").rect_size

func _input(ev):
	
	mpos = get_global_mouse_position()
	
	# scroll wheel
	if ev is InputEventMouseButton and ev.is_pressed():
		
		var pos_held_window := Vector2(rt.get_node("misc/qol_displays").rect_position.x + rt.instances["qol"]["held"].rect_position.x, rt.get_node("misc/qol_displays").rect_position.y + rt.instances["qol"]["held"].rect_position.y)
		var size_held_window : Vector2 = rt.instances["qol"]["held"].rect_size
		# menu
		if rt.get_node("misc/menu").visible and mpos.x >= rt.get_node("misc/menu").position.x and mpos.x < rt.get_node("misc/menu").position.x + rt.get_node("misc/menu/ScrollContainer").rect_size.x and get_global_mouse_position().y > rt.get_node("misc/menu").position.y and get_global_mouse_position().y < rt.get_node("misc/menu").position.y + rt.get_node("misc/menu/ScrollContainer").rect_size.y:
			# the line above is fucking ridiculous
			
			pass
		
		# screen
		elif mouse_in == "no":
			
			if ev.button_index == BUTTON_WHEEL_UP:
				set_global_position(Vector2(get_global_position().x, min(get_global_position().y + scroll_speed, height_limit)))
			if ev.button_index == BUTTON_WHEEL_DOWN:
				set_global_position(Vector2(get_global_position().x, max(get_global_position().y - scroll_speed, y_off)))
			
			if is_instance_valid($tip.tip) and $tip.tip_filled: $tip.tip.r_tip(true)
		
		#if ev.button_index == BUTTON_WHEEL_UP or ev.button_index == BUTTON_WHEEL_DOWN:
		#	get_node("tip")._call("no")
	
	if Input.is_key_pressed(KEY_DOWN):
		set_global_position(Vector2(get_global_position().x, max(get_global_position().y - scroll_speed, y_off)))
		return
	if Input.is_key_pressed(KEY_UP):
		set_global_position(Vector2(get_global_position().x, min(get_global_position().y + scroll_speed, height_limit)))
		return
	
	# drag map init
	if ev.is_action_pressed("ui_left_mouse_button"):
		
		if rt.get_node("misc/menu").visible and get_global_mouse_position().x >= rt.get_node("misc/menu").position.x and get_global_mouse_position().x < rt.get_node("misc/menu").position.x + rt.get_node("misc/menu/ScrollContainer").rect_size.x and get_global_mouse_position().y > rt.get_node("misc/menu").position.y and get_global_mouse_position().y < rt.get_node("misc/menu").position.y + rt.get_node("misc/menu/ScrollContainer").rect_size.y:
			dragging = "menu"
		elif mouse_in == "no":
			dragging = "self"
		
		var ev_pos = ev.global_position
		var map_pos = Vector2()
		match dragging:
			"self":
				map_pos = get_global_position()
		
		initpos = map_pos
		status = "clicked"
		offset = map_pos - ev_pos
	
	# exit menus
	if status == "clicked":
		
		# menu
		if rt.get_node("misc/menu").visible and mouse_out(Vector2(10,10), Vector2(38,38)) and mouse_out(pos["menu"], size["menu"]):
			rt.get_node("misc/menu").hide()
	
	if status == "clicked" and ev.is_class("InputEventMouseMotion"):
		status = "dragging"
	
	# drag map final
	if status == "dragging" and ev.is_class("InputEventMouseMotion"):
	
		#if ev.is_class("InputEventMouseMotion"):
		match dragging:
				
			"self":
				
				set_global_position(ev.global_position + offset)
				#set_global_position(Vector2(initpos.x, get_global_position().y))
				set_global_position(Vector2(initpos.x, clamp(get_global_position().y, y_off, height_limit)))
		
		if ev.get_button_mask() != BUTTON_LEFT:
			status = "no"

func mouse_out(pos:Vector2, size:Vector2) -> bool:
	if ((mpos.x > pos.x + size.x) or (mpos.x < pos.x)) or ((mpos.y < pos.y) or (mpos.y > pos.y + size.y)):
		return true
	return false

func _physics_process(delta):
	
	if menu_closed_time == 0.0: return
	menu_closed_time -= delta
	if menu_closed_time < 0.0: menu_closed_time = 0.0
