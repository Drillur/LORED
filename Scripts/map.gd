extends Area2D

onready var rt = get_owner()

onready var earningsReport = rt.get_node("%Earnings Report")

var status = "no"
var offset := Vector2()
var mpos := Vector2()
var initpos := Vector2()

var y_off = -200
var height_limit = 500
var scroll_speed := 80

var mouse_in := "no"


func _ready() -> void:
	set_physics_process(false)

func _input(ev):
	
	# drag map init
	if ev.is_action_pressed("ui_left_mouse_button"):
		status = "clicked"
	
	# exit menus
	if status == "clicked":
		
		mpos = get_global_mouse_position()
		
		# menu
		if rt.menu.visible and mouse_out(rt.get_node("%menuButton").rect_global_position, rt.get_node("%menuButton").rect_size) and mouse_out(rt.menu.rect_position, rt.menu.rect_size):
			rt.menu.hide()
		
		# upgrades
		var upcon = rt.get_node(rt.gnupcon)
		if rt.get_node(rt.gnupcon).visible and mouse_out(rt.get_node("%upgradesTab").rect_global_position, rt.get_node("%upgradesTab").rect_size) and mouse_out(upcon.rect_global_position, upcon.rect_size * rt.scale):
			rt.get_node(rt.gnupcon).hide()
			rt.get_node(rt.gnupcon).go_back()
		
		 # earnings report
		if earningsReport.visible and mouse_out(earningsReport.rect_global_position, earningsReport.rect_size):
			earningsReport.close()
		
		# save menu
		if rt.get_node("%SaveMenu").visible and mouse_out(rt.get_node("%SaveMenu").rect_global_position, rt.get_node("%SaveMenu").rect_size):
			rt.get_node("%SaveMenu").hide()
		
		# options menu
		if rt.get_node("%OptionsMenu").visible and mouse_out(rt.get_node("%OptionsMenu").rect_global_position, rt.get_node("%OptionsMenu").rect_size):
			rt.get_node("%OptionsMenu").hide()
		
		# stats menu
		if rt.get_node("%StatsMenu").visible and mouse_out(rt.get_node("%StatsMenu").rect_global_position, rt.get_node("%StatsMenu").rect_size):
			rt.get_node("%StatsMenu").hide()
		
		# PatchNotesMenu
		if rt.get_node("%PatchNotesMenu").visible and mouse_out(rt.get_node("%PatchNotesMenu").rect_global_position, rt.get_node("%PatchNotesMenu").rect_size):
			rt.get_node("%PatchNotesMenu").hide()
		
		# LogContainer
		if rt.get_node("%LogContainer").visible and mouse_out(rt.get_node("%LogContainer").rect_global_position, rt.get_node("%LogContainer").rect_size):
			rt.get_node("%LogContainer").hide()
		
		status = "no"

func mouse_out(_pos:Vector2, _size:Vector2) -> bool:
	return ((mpos.x > _pos.x + _size.x) or (mpos.x < _pos.x)) or ((mpos.y < _pos.y) or (mpos.y > _pos.y + _size.y))
