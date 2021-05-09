extends Node2D

onready var rt = get_parent().get_owner()

var prefabs := {}

var content := {}
var set_blah := {}
var fps := {}

onready var gn := {
	save = get_node("ScrollContainer/MarginContainer/VBoxContainer/save/CenterContainer/VBoxContainer/autosave/bar"),
	save_f = get_node("ScrollContainer/MarginContainer/VBoxContainer/save/CenterContainer/VBoxContainer/autosave/bar/f"),
	save_label = get_node("ScrollContainer/MarginContainer/VBoxContainer/save/CenterContainer/VBoxContainer/autosave/Label"),
}



func _ready():
	
	hide()
	
	# work
	if true:
		
		content["resource_text"] = {}
		
		prefabs["resource_text"] = preload("res://Prefabs/menu/resource_text.tscn")
		
		fps["run_text"] = 0.0
		fps["resource_text"] = 0.0
		fps["base"] = 0.0
		
		var node = $ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/fps
		node.add_item("15 fps")
		node.add_item("30 fps")
		node.add_item("60 fps")
		node.select(gv.menu.option["FPS"])
		_on_fps_item_selected(gv.menu.option["FPS"])
		
		node = $ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/notation_type
		node.add_item("engineering") # 0
		node.add_item("scientific") # 1
		node.add_item("logarithmic") # 2
		node.select(gv.menu.option["notation_type"])
	
	# ref
	if true:
		
		if gv.PLATFORM == "pc":
			get_node("ScrollContainer/MarginContainer/VBoxContainer/copyright").hide()
			get_node("ScrollContainer/MarginContainer/VBoxContainer/line2").hide()
		
		$ScrollContainer/MarginContainer/VBoxContainer/stats/CenterContainer/VBoxContainer/b_runs.hide()
		$ScrollContainer/MarginContainer/VBoxContainer/version.text = ProjectSettings.get_setting("application/config/Version")
		$ScrollContainer/MarginContainer/VBoxContainer/save.hide()
		
		$ScrollContainer/MarginContainer/VBoxContainer/stats.hide()
		$ScrollContainer/MarginContainer/VBoxContainer/stats/CenterContainer/VBoxContainer/runs.hide()
		
		$ScrollContainer.rect_size.y = 390
		_on_ScrollContainer_resized()
		#position = Vector2(10, 10)#10 + 38 + 10)
		position = Vector2(get_viewport_rect().size.x / 2 - $ScrollContainer.rect_size.x / 2, get_viewport_rect().size.y / 2 - $ScrollContainer.rect_size.y / 2)
		$ScrollContainer/MarginContainer/VBoxContainer/options.hide()
		$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/tooltips.hide()
		if gv.PLATFORM == "browser":
			gv.menu.option["flying_numbers"] = false
			$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/flying_numbers.pressed = false
			$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/flying_numbers.hide()
		if not $ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/flying_numbers.pressed:
			$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/crits_only.hide()
		
		
		if "browser" in gv.PLATFORM:
			$ScrollContainer/MarginContainer/VBoxContainer/save/CenterContainer/VBoxContainer/import_save.hide()
			$ScrollContainer/MarginContainer/VBoxContainer/save/CenterContainer/VBoxContainer/export_save.hide()
		elif "pc" in gv.PLATFORM:
			$ScrollContainer/MarginContainer/VBoxContainer/save/CenterContainer/VBoxContainer/b_print_save.hide()
func init(f: Dictionary) -> void:
	
	# resources
	for x in gv.g:
		content["resource_text"][x] = prefabs["resource_text"].instance()
		$ScrollContainer/MarginContainer/VBoxContainer/stats/CenterContainer/VBoxContainer/resources/CenterContainer/VBoxContainer.add_child(content["resource_text"][x])
		content["resource_text"][x].add_color_override("font_color", gv.g[x].color)
	
	# fps
	$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/fps.select(f["FPS"])
	
	# notation_type
	$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/notation_type.select(f["notation_type"])
	
	# performance // save cpu
	if gv.PLATFORM != "browser":
		$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/perf.pressed = f["performance"]
	else:
		$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/perf.hide()
	
	# flying_numbers
	$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/flying_numbers.pressed = f["flying_numbers"]
	$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/crits_only.visible = f["flying_numbers"]
	
	# crits_only
	$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/crits_only/CenterContainer/crits_only.pressed = f["crits_only"]
	
	# animations
	$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/animations.pressed = f["animations"]
	
	# zoom
	if "zoom" in f:
		get_node("ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/Zoom").value = f["zoom"]
	
	
	
	
	# on_save
	if true:
		
		# halt
		$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/on_save/CenterContainer/VBoxContainer/halt.pressed = f["on_save_halt"]
		
		# hold
		$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/on_save/CenterContainer/VBoxContainer/hold.pressed = f["on_save_hold"]
		
		# menu options
		$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/on_save/CenterContainer/VBoxContainer/menu_options.pressed = f["on_save_menu_options"]
	
	# tooltip_halt
	$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/tooltips/CenterContainer/VBoxContainer/halt.pressed = f["tooltip_halt"]
	
	# tooltip_hold
	$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/tooltips/CenterContainer/VBoxContainer/hold.pressed = f["tooltip_hold"]
	
	# tooltip_fuel
	$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/tooltips/CenterContainer/VBoxContainer/fuel.pressed = f["tooltip_fuel"]
	
	# color blind
	$'ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/color blind'.pressed = f["color blind"]
	color_blind(f["color blind"])
	
	# tooltip_autobuyer
	$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/tooltips/CenterContainer/VBoxContainer/autobuyer.pressed = f["tooltip_autobuyer"]
	get_node("ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/tooltips/CenterContainer/VBoxContainer/cost only").visible = not f["tooltip_autobuyer"]
	get_node("ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/tooltips/CenterContainer/VBoxContainer/cost only/crits_only").pressed = f["tooltip_cost_only"]
	
	# ref
	if true:
		
		$ScrollContainer/MarginContainer/VBoxContainer/stats/CenterContainer/VBoxContainer/runs/CenterContainer/VBoxContainer/s1count.add_color_override("font_color", gv.COLORS["malig"])
		$ScrollContainer/MarginContainer/VBoxContainer/stats/CenterContainer/VBoxContainer/runs/CenterContainer/VBoxContainer/s1time.add_color_override("font_color", gv.COLORS["malig"])
		$ScrollContainer/MarginContainer/VBoxContainer/stats/CenterContainer/VBoxContainer/runs/CenterContainer/VBoxContainer/s1last_time.add_color_override("font_color", gv.COLORS["malig"])
		$ScrollContainer/MarginContainer/VBoxContainer/stats/CenterContainer/VBoxContainer/runs/CenterContainer/VBoxContainer/s2count.add_color_override("font_color", gv.COLORS["tum"])
		$ScrollContainer/MarginContainer/VBoxContainer/stats/CenterContainer/VBoxContainer/runs/CenterContainer/VBoxContainer/s2time.add_color_override("font_color", gv.COLORS["tum"])
		$ScrollContainer/MarginContainer/VBoxContainer/stats/CenterContainer/VBoxContainer/runs/CenterContainer/VBoxContainer/s2last_time.add_color_override("font_color", gv.COLORS["tum"])
		
		$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/on_save.hide()

func _physics_process(delta):
	
	# catches
	if not visible: return
	
	if $ScrollContainer/MarginContainer/VBoxContainer/stats/CenterContainer/VBoxContainer/resources.visible:
		fps["resource_text"] += delta
		if fps["resource_text"] >= gv.fps:
			fps["resource_text"] -= gv.fps
			r_resource_text()
	
	if $ScrollContainer/MarginContainer/VBoxContainer/stats/CenterContainer/VBoxContainer/runs.visible:
		fps["run_text"] += delta
		if fps["run_text"] >= 1.0:
			fps["run_text"] -= 1
			r_runs()
	
	if not $ScrollContainer/MarginContainer/VBoxContainer/save.visible: return
	
	fps["base"] += delta
	if fps["base"] < gv.fps: return
	fps["base"] -= gv.fps
	
	r_save_bar()

func r_resource_text() -> void:
	
	for x in gv.g:
		if not rt.get_node(rt.gnLOREDs).cont[x].visible:
			content["resource_text"][x].hide()
			continue
		content["resource_text"][x].text = gv.stats.r_gained[x].toString() + " " + gv.g[x].name
		if not content["resource_text"][x].visible: content["resource_text"][x].show()
func r_runs() -> void:
	
	var node = $ScrollContainer/MarginContainer/VBoxContainer/stats/CenterContainer/VBoxContainer/runs/CenterContainer/VBoxContainer/s1count
	node.text = "S1: on run " + fval.f(gv.stats.run[0])
	
	node = $ScrollContainer/MarginContainer/VBoxContainer/stats/CenterContainer/VBoxContainer/runs/CenterContainer/VBoxContainer/s1time
	node.text = "S1 run duration: " + int_to_time(gv.stats.last_reset_clock[0])
	
	node = $ScrollContainer/MarginContainer/VBoxContainer/stats/CenterContainer/VBoxContainer/runs/CenterContainer/VBoxContainer/s1last_time
	node.text = "Last S1 run:\n" + int_to_time(gv.stats.last_run_dur[0], false)
	
	node = $ScrollContainer/MarginContainer/VBoxContainer/stats/CenterContainer/VBoxContainer/runs/CenterContainer/VBoxContainer/s2count
	node.text = "S2: on run " + fval.f(gv.stats.run[1])
	
	node = $ScrollContainer/MarginContainer/VBoxContainer/stats/CenterContainer/VBoxContainer/runs/CenterContainer/VBoxContainer/s2time
	node.text = "S2 run duration: " + int_to_time(gv.stats.last_reset_clock[1])
	
	node = $ScrollContainer/MarginContainer/VBoxContainer/stats/CenterContainer/VBoxContainer/runs/CenterContainer/VBoxContainer/s2last_time
	node.text = "Last S2 run:\n" + int_to_time(gv.stats.last_run_dur[1], false)
func int_to_time(clock, diff:=true) -> String:
	
	if clock == 0: return "~"
	
	var dif = rt.cur_clock - clock
	if not diff: dif = clock
	
	if dif > 3600 * 24 * 365:
		var years := int(dif /60 / 60 / 24 / 365)
		return str(years) + " years"
	if dif > 3600 * 24:
		var days:= int(dif /60 / 60 / 24)
		return str(days) + " days"
	if dif > 3600:
		var hours := int(dif / 60 / 60)
		return str(hours) + " hours"
	if dif > 60:
		var minutes := int(dif / 60)
		var sec := int(dif - (minutes * 60))
		return str(minutes) + " min, " + str(sec) + " sec"
	
	return String(int(dif)) + " sec"
func _on_button_down():
	rt.get_node("map").status = "no"

func _on_b_options_pressed():
	b_open_or_close_menu($ScrollContainer/MarginContainer/VBoxContainer/options)
func _on_b_tooltips_pressed():
	b_open_or_close_menu($ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/tooltips)
func _on_flying_numbers_pressed():
	b_open_or_close_menu($ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/crits_only)
	b_option_pressed("flying_numbers", $ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/flying_numbers)
func _on_b_pressed(extra_arg_0):
	b_open_or_close_menu(get_node(extra_arg_0))
	if "er/runs" in extra_arg_0:
		if get_node(extra_arg_0).visible:
			r_runs()
	if "delete" in extra_arg_0:
		if not get_node(extra_arg_0).visible:
			hide_cascading_save_buttons()

func b_open_or_close_menu(node) -> void:
	if node.visible:
		node.hide()
	else:
		node.show()

func w_display_run(upgrade_complete: bool) -> void:
	if not upgrade_complete: return
	$ScrollContainer/MarginContainer/VBoxContainer/stats/CenterContainer/VBoxContainer/b_runs.show()

func _on_menu_hide():
	
	#$misc/menu/g/save/g/t0/g/textedit.text = ""
	#$misc/menu/g/save/g/t1/g/textedit.text = ""
	pass # Replace with function body.


func _on_fps_item_selected(id):
	gv.menu.option["FPS"] = id
	match id:
		0: gv.fps = 0.0666 # 15
		1: gv.fps = 0.0333 # 30
		2: gv.fps = 0.0166 # 60
func _on_notation_type_item_selected(id):
	gv.menu.option["notation_type"] = id

func _on_crits_only_pressed():
	b_option_pressed("crits_only", $ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/crits_only/CenterContainer/crits_only)
func _on_animations_pressed():
	b_option_pressed("animations", $ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/animations)
func _on_halt_pressed():
	b_option_pressed("tooltip_halt", $ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/tooltips/CenterContainer/VBoxContainer/halt)
func _on_hold_pressed():
	b_option_pressed("tooltip_hold", $ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/tooltips/CenterContainer/VBoxContainer/hold)
func _on_fuel_pressed():
	b_option_pressed("tooltip_fuel", $ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/tooltips/CenterContainer/VBoxContainer/fuel)
func _on_option_pressed(option: String, node_path: String):
	b_option_pressed(option, get_node(node_path))

func b_option_pressed(option: String, node) -> void:
	
	gv.menu.option[option] = node.pressed
	
	match option:
		"color blind":
			color_blind(node.pressed)
		"tooltip_autobuyer":
			get_node("ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/tooltips/CenterContainer/VBoxContainer/cost only").visible = not node.pressed
		"performance":
			if gv.PLATFORM != "browser":
				OS.set_low_processor_usage_mode(node.pressed)

func _on_ScrollContainer_resized():
	$bg.rect_size = $ScrollContainer.rect_size

func _on_Label_ready(extra_arg_0, extra_arg_1):
	set_blah[extra_arg_1] = extra_arg_0

func _on_menu_visibility_changed():
	if not visible:
		hide_cascading_save_buttons()
		return
	if not $ScrollContainer/MarginContainer/VBoxContainer/save.visible: return
	r_save_bar()

func r_save_bar() -> void:
	gn.save_f.rect_size.x = min(rt.save_fps / 30 * gn.save.rect_size.x, gn.save.rect_size.x)

func _on_b_save_now_pressed():
	rt.save_fps = 0.0
	rt.e_save()

func _on_delete_pressed():
	
	rt.reset(0)
	rt.b_tabkey(KEY_ESCAPE)
	rt.b_tabkey(KEY_1)
	rt.save_fps = 0.0
	
	var save_file = File.new()
	if save_file.file_exists(rt.SAVE.MAIN):
		var dir = Directory.new()
		dir.remove(rt.SAVE.MAIN)

func hide_cascading_save_buttons()->void:
	
	$ScrollContainer/MarginContainer/VBoxContainer/save/CenterContainer/VBoxContainer/b_delete_save_now3.hide()
	$ScrollContainer/MarginContainer/VBoxContainer/save/CenterContainer/VBoxContainer/b_delete_save_now4.hide()
	$ScrollContainer/MarginContainer/VBoxContainer/save/CenterContainer/VBoxContainer/b_delete_save_now5.hide()
	$ScrollContainer/MarginContainer/VBoxContainer/save/CenterContainer/VBoxContainer/delete.hide()


func _on_b_print_save_pressed():
	rt.e_save("print to console")



func _on_export_save_pressed() -> void:
	$FileDialog.popup()
func _on_import_save_pressed() -> void:
	$Import.popup()

func _on_FileDialog_file_selected(path: String) -> void:
	rt.e_save("export", path)
func _on_Import_file_selected(path: String) -> void:
	
	rt._ready_define_loreds(0)
	
	rt.game_start(rt.e_load(path))
	
	rt.get_tree().reload_current_scene()
	
	rt.e_save()


func _on_Discord_pressed() -> void:
	OS.shell_open("https://discord.gg/xJeBZxt")




func _on_Zoom_value_changed(value: float):#, ignore_conversion = false) -> void:
	gv.menu.option["zoom"] = value
	match int(value):
		0: value = 0.75
		10: value = 0.8
		20: value = 0.85
		30: value = 0.9
		40: value = 0.95
		50: value = 1.00
		60: value = 1.05
		70: value = 1.1
		80: value = 1.15
		90: value = 1.2
		100: value = 1.25
	get_node("ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/zoom_flair").text = "Zoom: " + str(value) + "x"
	rt.scale = Vector2(value, value)
	rt.r_window_size_changed()

func update_cur_session(duration: int):
	
	if get_node("ScrollContainer/MarginContainer/VBoxContainer/stats").visible:
		var time = convert_int_to_time(duration)
		get_node("ScrollContainer/MarginContainer/VBoxContainer/stats/CenterContainer/VBoxContainer/cur_session").text = "Current session duration: " + time

func convert_int_to_time(val: int) -> String:
	if val < 60:
		return str(val)
	
	if val < 3600:
		var remainder = val % 60
		val = floor(val / 60)
		return str(val) + ":" + str("%02d" % remainder)
	
	var _min = (val % 3600) / 60 # minutes
	val = floor(val / 3600) # hours
	return str(val) + ":" + str("%02d" % _min)

func color_blind(_set: bool) -> void:
	for x in gv.g:
		gv.g[x].manager.color_blind.visible = _set
	rt.get_node(rt.gnupcon).r_update()
