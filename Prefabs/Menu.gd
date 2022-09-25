extends MarginContainer


const page_colors = {
	"main": Color(1, 0, 0.380392),
	"save": Color(0.384314, 0.603922, 0.270588),
	"options": Color(0.137255, 0.698039, 0.552941),
	"stats": Color(0.74902, 0.639216, 0.035294),
	"patch": Color(0.996078, 0.443137, 0.172549),
	"tutorial": Color(0.960784, 0.521569, 1),
	"hard reset": Color(1, 0, 0),
}

onready var rt = get_node("/root/Root")
onready var cav_rt = get_node("/root/Cavern")

onready var sc = get_node("sc")

onready var pages = get_node("sc/m/v")
onready var buttons = get_node("sc/m/v/top/v/h")

onready var fps = get_node("sc/m/v/options/v/fps2/button")
onready var notation = get_node("sc/m/v/options/v/notation2/button")
onready var flying_numbers = get_node("sc/m/v/options/v/flying_numbers")
onready var consolidate = get_node("sc/m/v/options/v/consolidate_numbers/button")
onready var crits_only = get_node("sc/m/v/options/v/crits_only/button")
onready var lored_chit_chat = get_node("sc/m/v/options/v/lored chit-chat")
onready var animations = get_node("sc/m/v/options/v/animations")
onready var color_blind = get_node("sc/m/v/options/v/color blind")
onready var deaf = get_node("sc/m/v/options/v/deaf")
onready var tip_halt = get_node("sc/m/v/options/v/halt/button")
onready var tip_hold = get_node("sc/m/v/options/v/hold/button")
onready var tip_fuel = get_node("sc/m/v/options/v/fuel/button")
onready var tip_autobuyer = get_node("sc/m/v/options/v/autobuyer/button")
onready var save_halt = get_node("sc/m/v/save/v/options/halt")
onready var save_hold = get_node("sc/m/v/save/v/options/hold")
onready var cur_session = get_node("sc/m/v/stats/v/cur_session/Label")
onready var stats_run = get_node("sc/m/v/stats/v/run/cont")
onready var patched_alert = get_node("sc/m/v/top/v/h/patch/n/alert")
onready var patch_alert_option = get_node("sc/m/v/patch/v/patch_alert")
onready var tutorial_alert_option = get_node("sc/m/v/tutorial/v/tutorial_alert")
onready var stats_run_1_reset = get_node("sc/m/v/stats/v/run/cont/s1/reset/Label")
onready var stats_run_2_reset = get_node("sc/m/v/stats/v/run/cont/s2/reset/Label")
onready var stats_run_3_reset = get_node("sc/m/v/stats/v/run/cont/s3/reset/Label")
onready var stats_run_4_reset = get_node("sc/m/v/stats/v/run/cont/s4/reset/Label")

onready var max_random_wishes = get_node("sc/m/v/stats/v/quest/cont/max_random_wishes/Label")

#onready var quest_max_tasks = get_node("sc/m/v/stats/v/quest/cont/max tasks/Label")

onready var m = get_node("sc/m")
onready var bg = get_node("sc/m/bg")
onready var bg_shadow = get_node("bg")
onready var fps_display = get_node("sc/m/v/options/v/fps/Label")
onready var notation_display = get_node("sc/m/v/options/v/notation/Label")

onready var hard_reset_confirm = get_node("sc/m/v/hard reset/v/hint/confirm")
onready var hard_reset = get_node("sc/m/v/hard reset/v/h/confirm/button")

onready var save = get_node("save")
onready var save_bar = get_node("sc/m/v/save/v/autosave/bar/f")
onready var save_bar_t = get_node("sc/m/v/save/v/autosave/bar")

onready var hint_html = get_node("sc/m/v/save/v/hint html")

onready var patch = get_node("sc/m/v/patch/v")

var cont := {}
var page := ""
var i := 0



func _ready():
	
	get_node("sc/m/v/main/v/v/version").text = ProjectSettings.get_setting("application/config/Version")
	
	notation.add_item("Engineering notation")
	notation.add_item("Scientific notation")
	notation.add_item("Logarithmic notation")
	fps.add_item("15")
	fps.add_item("30")
	fps.add_item("60")
	
	disable_children("flying_numbers")
	disable_children("hard reset")
	
	for x in gv.PATCH_NOTES:
		cont[x] = gv.SRC["patch version"].instance()
		cont[x].setup(x)
		patch.add_child(cont[x])
	
	switch_page("main")
	
	save_bar.rect_size.x = 0
	
	hint_html.visible = true if gv.PLATFORM == "browser" else false
	
	hide()

func setup():
	
	select_fps(gv.option["FPS"])
	select_notation(gv.option["notation_type"])
	flying_numbers.pressed = gv.option["flying_numbers"]
	_on_flying_numbers_pressed()
	consolidate.pressed = gv.option["consolidate_numbers"]
	_on_consolidate_pressed()
	crits_only.pressed = gv.option["crits_only"]
	_on_crit_pressed()
	lored_chit_chat.pressed = gv.option["chit chat"]
	_on_lored_chitchat_pressed()
	animations.pressed = gv.option["animations"]
	_on_animations_pressed()
	color_blind.pressed = gv.option["color blind"]
	_on_color_blind_pressed()
	deaf.pressed = gv.option["deaf"]
	_on_deaf_pressed()
	tip_halt.pressed = gv.option["tooltip_halt"]
	_on_tip_halt_pressed()
	tip_hold.pressed = gv.option["tooltip_hold"]
	_on_tip_hold_pressed()
	tip_fuel.pressed = gv.option["tooltip_fuel"]
	_on_tip_fuel_pressed()
	tip_autobuyer.pressed = gv.option["tooltip_autobuyer"]
	_on_tip_autobuyer_pressed()
	
	save_halt.pressed = gv.option["on_save_halt"]
	_on_save_halt_pressed()
	save_hold.pressed = gv.option["on_save_hold"]
	_on_save_hold_pressed()
	
	#quest_max_tasks.text = "Max tasks +" + str(taq.max_tasks)
	
	patch_alert_option.pressed = gv.option["patch alert"]
	tutorial_alert_option.pressed = gv.option["tutorial alert"]
	
	update()

func update():
	
	# continuously runs
	
	while true:
		
		stats_run_1_reset.text = "Reset " + str(gv.run1 - 1) + " times"
		stats_run_2_reset.text = "Reset " + str(gv.run2 - 1) + " times"
		stats_run_3_reset.text = "Reset " + str(gv.run3 - 1) + " times"
		stats_run_4_reset.text = "Reset " + str(gv.run4 - 1) + " times"
		
		max_random_wishes.text = "Random Wish Limit: " + str(taq.max_random_wishes)
		
		var t = Timer.new()
		add_child(t)
		t.start(10)
		yield(t, "timeout")
		t.queue_free()




func update_cur_session(duration: int) -> void:
	
	cur_session.text = "Current session duration: " + gv.parse_time(duration)

func disable_children(which: String) -> void:
	
	match which:
		"flying_numbers":
			consolidate.disabled = not flying_numbers.pressed
			crits_only.disabled = not flying_numbers.pressed
			consolidate.mouse_default_cursor_shape = Control.CURSOR_ARROW if consolidate.disabled else Control.CURSOR_POINTING_HAND
			crits_only.mouse_default_cursor_shape = Control.CURSOR_ARROW if crits_only.disabled else Control.CURSOR_POINTING_HAND
		"hard reset":
			hard_reset.disabled = not hard_reset_confirm.pressed
			hard_reset.mouse_default_cursor_shape = Control.CURSOR_ARROW if hard_reset.disabled else Control.CURSOR_POINTING_HAND

func switch_page(which: String) -> void:
	
	if page == which:
		which = "main"
	
	page = which
	
	# display/hide afford nodes which highlight on the tab buttons
	for x in buttons.get_children():
		if x.name == which:
			x.get_node("m/afford").show()
		else:
			x.get_node("m/afford").hide()
	
	bg.self_modulate = page_colors[which]
	bg_shadow.self_modulate = bg.self_modulate
	
	# display/hide margincontainers that hold content of page
	for x in pages.get_children():
		
		if x.name == "top":
			continue
		
		if x.name == which:
			x.show()
		else:
			x.hide()

func select_fps(id: int) -> void:
	
	fps.select(id)
	gv.option["FPS"] = id
	gv.fps = [0.0666, 0.0333, 0.0166][id] # 15, 30, 60
	fps_display.text = "Current target FPS: " + str(round(1 / gv.fps))

func select_notation(id: int) -> void:
	
	notation.select(id)
	gv.option["notation_type"] = id
	notation_display.text = "Current number notation: " + ["Engineering", "Scientific", "Logarithmic"][id]



func _on_Menu_visibility_changed() -> void:
	if not visible:
		switch_page("main")

func _on_m_resized() -> void:
	if sc == null:
		yield(self, "ready")
	sc.rect_min_size.y = m.rect_size.y if m.rect_size.y <= 500 else 500
	rect_min_size.y = sc.rect_min_size.y

func _on_stats_pressed() -> void:
	switch_page("stats")
func _on_save_pressed() -> void:
	switch_page("save")
func _on_options_pressed() -> void:
	switch_page("options")
func _on_hard_reset_pressed() -> void:
	switch_page("hard reset")
func _on_patch_pressed() -> void:
	switch_page("patch")
	if patched_alert.visible:
		patched_alert.hide()
		rt.get_node("m/v/top/h/menu_button/patched_alert").hide()
func _on_tutorial_pressed() -> void:
	switch_page("tutorial")
func _on_hard_reset_back_pressed() -> void:
	switch_page("save")
	hard_reset_confirm.pressed = false
	disable_children("hard reset")

func _on_discord_pressed() -> void:
	OS.shell_open("https://discord.gg/xJeBZxt")
func _on_godot_pressed() -> void:
	OS.shell_open("https://godotengine.org/")
func _on_github_pressed() -> void:
	OS.shell_open("https://github.com/Drillur/LORED")

func _on_flying_numbers_pressed() -> void:
	gv.option["flying_numbers"] = flying_numbers.pressed
	disable_children("flying_numbers")
func _on_hard_reset_confirm_pressed() -> void:
	disable_children("hard reset")
func _on_consolidate_pressed() -> void:
	gv.option["consolidate_numbers"] = consolidate.pressed
func _on_crit_pressed() -> void:
	gv.option["crits_only"] = crits_only.pressed
	

func _on_lored_chitchat_pressed() -> void:
	gv.option["chit chat"] = lored_chit_chat.pressed
func _on_animations_pressed() -> void:
	gv.option["animations"] = animations.pressed
func _on_color_blind_pressed() -> void:
	gv.option["color blind"] = color_blind.pressed
	rt.get_node(rt.gnupcon).r_update()
func _on_deaf_pressed() -> void:
	gv.option["deaf"] = deaf.pressed
func _on_tip_halt_pressed() -> void:
	gv.option["tooltip_halt"] = tip_halt.pressed
func _on_tip_hold_pressed() -> void:
	gv.option["tooltip_hold"] = tip_hold.pressed
func _on_tip_fuel_pressed() -> void:
	gv.option["tooltip_fuel"] = tip_fuel.pressed
func _on_tip_autobuyer_pressed() -> void:
	gv.option["tooltip_autobuyer"] = tip_autobuyer.pressed
func _on_patch_alert_pressed() -> void:
	gv.option["patch alert"] = patch_alert_option.pressed
func _on_tutorial_alert_pressed() -> void:
	gv.option["tutorial alert"] = tutorial_alert_option.pressed
	

func _on_save_halt_pressed() -> void:
	gv.option["on_save_halt"] = save_halt.pressed
func _on_save_hold_pressed() -> void:
	gv.option["on_save_hold"] = save_hold.pressed
func _on_export_pressed() -> void:
	if gv.PLATFORM == "pc":
		$export.popup()
	else:
		rt.e_save("print to console")
func _on_delete_save_pressed() -> void:
	SaveManager.deleteSave(SaveManager.save_path)
	rt.exitToMainMenu()

func _on_stats_run_pressed() -> void:
	
	if stats_run.visible:
		stats_run.hide()
	else:
		stats_run.show()
	
	get_node("sc/m/v/stats/v/run/top/h/Panel/Sprite").rotation_degrees = 180 if stats_run.visible else 0
func _on_tutorial_loreds_pressed() -> void:
	var node = get_node("sc/m/v/tutorial/v/loreds/cont")
	if node.visible:
		node.hide()
	else:
		node.show()
	get_node("sc/m/v/tutorial/v/loreds/top/h/Panel/Sprite").rotation_degrees = 180 * int(node.visible)
func _on_tutorial_loreds_fuel_pressed() -> void:
	var node = get_node("sc/m/v/tutorial/v/loreds/cont/fuel/loreds/cont")
	if node.visible:
		node.hide()
	else:
		node.show()
	get_node("sc/m/v/tutorial/v/loreds/cont/fuel/loreds/top/h/Panel/Sprite").rotation_degrees = 180 * int(node.visible)
func _on_tutorial_loreds_upgrading_pressed() -> void:
	var node = get_node("sc/m/v/tutorial/v/loreds/cont/upgrading/loreds/cont")
	if node.visible:
		node.hide()
	else:
		node.show()
	get_node("sc/m/v/tutorial/v/loreds/cont/upgrading/loreds/top/h/Panel/Sprite").rotation_degrees = 180 * int(node.visible)
func _on_tutorial_loreds_input_pressed() -> void:
	var node = get_node("sc/m/v/tutorial/v/loreds/cont/input/loreds/cont")
	if node.visible:
		node.hide()
	else:
		node.show()
	get_node("sc/m/v/tutorial/v/loreds/cont/input/loreds/top/h/Panel/Sprite").rotation_degrees = 180 * int(node.visible)

func _on_fps_item_selected(index: int) -> void:
	select_fps(index)
func _on_notation_item_selected(index: int) -> void:
	select_notation(index)
func _on_export_file_selected(path: String) -> void:
	rt.e_save("export", path)

func _on_save_timeout() -> void:
	
	i += 1
	save_bar.rect_size.x = (float(i) / 30) * save_bar_t.rect_size.x
	
	if i == 30:
		i = -1
		match gv.active_scene:
			gv.Scene.ROOT:
				SaveManager.save()
func _on_save_now_pressed() -> void:
	save.stop()
	i = 0
	SaveManager.save()
	save.start(1)
	save_bar.rect_size.x = 0


























