extends MarginContainer



@onready var tooltip_parent = %Tooltip
@onready var lored_container = %"LORED Container" as LOREDContainer
@onready var upgrade_container = %"Upgrade Container" as UpgradeContainer
@onready var random_wishes = %"Random Wishes"
@onready var main_wishes = %"Main Wishes"
@onready var control = %Control
@onready var menu_button = %"Menu Button" as _MenuButton
@onready var upgrades_button = %"Upgrades Button" as _MenuButton
@onready var wallet = %Wallet as WalletVico
@onready var wallet_button = %"Wallet Button" as _MenuButton
@onready var stage1 = %Stage1 as _MenuButton
@onready var stage2 = %Stage2 as _MenuButton
@onready var stage3 = %Stage3 as _MenuButton
@onready var stage4 = %Stage4 as _MenuButton
@onready var purchasable_upgrade_count = %"Purchasable Upgrade Count"
@onready var offline_report = %"Offline Report"
@onready var fps = %FPS
@onready var screen_area = %ScreenArea
@onready var settings = %Settings
@onready var hotbar = %Hotbar

# DEBUG
@onready var tooltip_position_display = %"Tooltip Position Display"

# RIGHT

@onready var limit_break_vico = %LimitBreakVico

# MENU

@onready var game_section = %"Game Section"
@onready var menu_scroll = %MenuScroll
@onready var menu_container = %MenuContainer
@onready var menu_contents = %"Menu Contents"
@onready var sidebar_background = %"Sidebar Background"
@onready var sidebar_title_background = %"Sidebar Title Background"
@onready var save_game = %"Save Game"
@onready var total_notice_count = %"Total Notice Count"
@onready var upgrade_section = %"Upgrade Section"
@onready var upgrade_vicos = %UpgradeVicos
@onready var settings_button = %"Settings Button"
@onready var statistics_button = %"Statistics Button"
@onready var patch_notes_button = %"Patch Notes Button"

@onready var right_bar = %RightBar as RightBar
@onready var dialogue_balloon = %DialogueBalloon

var upgrade_section_queued := false




func _ready():
	up.get_upgrade(Upgrade.Type.AUTOSHOVELER).effect.applied.changed.connect(update_dlabel)
	if not gv.dev_mode:
		%Dlabel.queue_free()
		tooltip_position_display.queue_free()
		upgrades_button.hide()
		wallet_button.hide()
		$Left/Dev.hide()
	
	call_deferred("window_resized")
	get_tree().root.size_changed.connect(window_resized)
	
	settings_button.pressed.connect(close_menu)
	
	# MENU
	
	wallet_button.hide()
	upgrades_button.hide()
	stage1.hide()
	stage2.hide()
	stage3.hide()
	stage4.hide()
	game_section.hide()
	%"Sidebar Title Background".modulate = gv.game_color
	%"Sidebar Background".modulate = gv.game_color
	menu_scroll.get_v_scroll_bar().modulate = gv.game_color
	update_menu_size_once()
	wallet.color_changed.connect(on_wallet_color_changed)
	wallet_button.color = gv.get_stage_color(Stage.Type.STAGE1)
	
	
	# RIGHTBAR
	
	lored_container.lored_details_requested.connect(right_bar.setup_lored)
	right_bar.dialogue_balloon = dialogue_balloon
	
	wa.wallet_unlocked.changed.connect(display_wallet_button)
	
	up.purchasable_upgrade_count.changed.connect(update_purchasable_upgrade_count)
	up.menu_unlocked_changed.connect(display_upgrades_button)
	up.menu_unlocked_changed.connect(flash_upgrade_button)
	wa.wallet_unlocked.changed.connect(wallet_lock)
	
	update_purchasable_upgrade_count()
	
	gv.tooltip_parent = tooltip_parent
	gv.texts_parent = $"Texts Parent"
	lv.lored_container = lored_container
	up.upgrade_container = upgrade_container
	wi.main_wish_container = main_wishes
	wi.random_wish_container = random_wishes
	wa.wallet = wallet
	
	for i in range(1, 5):
		var stage = gv.get_stage(i) as Stage
		stage.stage_unlocked_changed.connect(display_stage_button)
		if not gv.dev_mode:
			var b = get("stage" + str(i)) as _MenuButton
			b.hide()
	
	upgrade_container.connect("upgrade_menu_tab_changed", update_upgrades_button_color)
	update_upgrades_button_color(0)
	
	gv.root_ready.set_to(true)
	
	lv.start()
	em.start()
	
	if SaveManager.can_load_game():
		SaveManager.load_game()
	else:
		SaveManager.save_file_color = gv.get_random_color()
		gv.update_discord_details("Just began a new game!")
	
	wi.start()
	
	# DEBUG
	if not gv.dev_mode:
		return
	update_fps()
	if not gv.get_stage(2).unlocked:
		gv.unlock_stage(2)
	if not gv.get_stage(3).unlocked:
		gv.unlock_stage(3)
	for lored_type in lv.get_loreds_in_stage(3):
		lv.get_lored(lored_type).unlock()


func update_menu_size_once() -> void:
	await menu_container.resized
	_on_menu_container_resized()
	close_menu()



func _input(event):
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()
		return
	
	var esc_pressed = Input.is_action_just_pressed("ESC")
	var left_clicked = Input.is_action_just_pressed("LeftClick")
	
	if (
		should_hide_a_menu()
		and (
			(left_clicked and event.get("position"))
			or esc_pressed
		)
	):
		var node
		var button
		if menu_contents.visible:
			node = menu_contents
			button = menu_button
		elif offline_report.visible:
			node = offline_report
		elif upgrade_container.visible:
			node = upgrade_container
			button = upgrades_button
		elif wallet.visible:
			node = wallet
			button = wallet_button
		elif settings.visible:
			node = settings
			button = settings_button
		elif dialogue_balloon.visible and dialogue_balloon.content.visible:
			node = dialogue_balloon.content
		
		if (esc_pressed
			or (
				not gv.node_has_point(node, event.position)
				and (
					button == null
					or not gv.node_has_point(button, event.position)
				)
			)
		):
			if node == menu_contents:
				close_menu()
			elif node == dialogue_balloon.content:
				dialogue_balloon.hide_chat()
			else:
				node.hide()
			gv.clear_tooltip()
			return
	
	if esc_pressed and not menu_contents.visible:
		open_menu()
		return
	
	if Input.is_action_just_pressed("Save"):
		SaveManager.save_game()
		return
	
	if Input.is_action_just_pressed("Q"):
		select_upgrade_menu_tab(0)
	elif Input.is_action_just_pressed("W"):
		select_upgrade_menu_tab(1)
	elif Input.is_action_just_pressed("E"):
		select_upgrade_menu_tab(2)
	elif Input.is_action_just_pressed("R"):
		select_upgrade_menu_tab(3)
	elif Input.is_action_just_pressed("A"):
		select_upgrade_menu_tab(4)
	elif Input.is_action_just_pressed("S"):
		select_upgrade_menu_tab(5)
	elif Input.is_action_just_pressed("D"):
		select_upgrade_menu_tab(6)
	elif Input.is_action_just_pressed("F"):
		select_upgrade_menu_tab(7)
	
	if Input.is_action_just_pressed("T"):
		open_wallet(not wallet.visible)
	
	
	if Input.is_action_just_pressed("1"):
		select_stage(1)
	elif Input.is_action_just_pressed("2"):
		select_stage(2)
	elif Input.is_action_just_pressed("3"):
		select_stage(3)
	elif Input.is_action_just_pressed("4"):
		select_stage(4)
	
	
	if Input.is_action_pressed("Shift"):
		if Input.is_action_just_released("Mouse Wheel Up"):
			gv.scroll_tooltip(-1)
		elif Input.is_action_just_released("Mouse Wheel Down"):
			gv.scroll_tooltip(1)
		return
	elif Input.is_action_just_pressed("Mouse Wheel Down"):
		gv.clear_tooltip()
		return
	elif Input.is_action_just_pressed("Mouse Wheel Up"):
		gv.clear_tooltip()
		return


func should_hide_a_menu() -> bool:
	return ((dialogue_balloon.visible and dialogue_balloon.content.visible) and not dialogue_balloon.is_collapsed()) or settings.visible or menu_contents.visible or upgrade_container.visible or wallet.visible or offline_report.visible


func _on_menu_button_pressed():
	if menu_contents.visible:
		close_menu()
	else:
		open_menu()


func close_menu() -> void:
	menu_contents.hide()
	menu_button.set_text_visibility(false)
	sidebar_background.hide()


func open_menu() -> void:
	menu_contents.show()
	menu_button.set_text_visibility(true)
	sidebar_background.show()
	total_notice_count.hide()


func _on_upgrades_button_pressed():
	hide_menus()
	if upgrade_container.visible:
		upgrade_container.hide()
	else:
		upgrade_container.show()


func _on_wallet_button_pressed():
	hide_menus()
	open_wallet(not wallet.visible)



func _on_upgrades_button_visibility_changed():
	if not is_node_ready():
		return
	if upgrades_button.visible:
		gv.flash(upgrades_button, Color(0, 1, 0))



func _on_main_wishes_sort_children():
	if main_wishes.get_child_count() == 0:
		main_wishes.hide()
	else:
		main_wishes.show()


func _on_random_wishes_sort_children():
	if random_wishes.get_child_count() == 0:
		random_wishes.hide()
	else:
		random_wishes.show()



func update_upgrades_button_color(upgrade_menu_tab: int) -> void:
	upgrades_button.color = up.get_menu_color(upgrade_menu_tab)



func update_purchasable_upgrade_count() -> void:
	var count: int = up.purchasable_upgrade_count.get_value()
	purchasable_upgrade_count.count = count
	if not upgrade_container.visible:
		update_notice_count()


func update_notice_count() -> void:
	total_notice_count.count = (
		up.purchasable_upgrade_count.get_value()
		+ 0
	)



func window_resized() -> void:
	call_deferred("fix_screen_size")


func fix_screen_size() -> void:
	var win: Vector2 = get_viewport_rect().size
	size = Vector2(win.x / scale.x, win.y / scale.y)
	
	screen_area.shape.size.x = size.x * 1.1
	screen_area.shape.size.y = size.y * 1.1
	screen_area.position = Vector2(size.x / 2, size.y / 2)
	
	_on_menu_container_resized()


func _on_screen_area_body_exited(body):
	body.queue_free()


func _on_save_and_quit_pressed():
	hide()
	SaveManager.save_game()
	get_tree().quit()


func _on_menu_container_resized():
	if not is_node_ready():
		await ready
	menu_scroll.custom_minimum_size.y = min(menu_container.size.y, gv.menu_container_size)


func on_wallet_color_changed(val: Color) -> void:
	wallet_button.color = val


func _on_stage_1_pressed():
	select_stage(1)


func _on_stage_2_pressed():
	select_stage(2)


func _on_stage_3_pressed():
	select_stage(3)


func _on_stage_4_pressed():
	select_stage(4)


func _on_upgrade_effect_vico_visibility_changed():
	if upgrade_section_queued:
		return
	if not is_node_ready():
		upgrade_section_queued = true
		await ready
	upgrade_section_queued = false
	for child in upgrade_vicos.get_children():
		if child.visible:
			upgrade_section.show()
			return
	upgrade_section.hide()



# - Ref

func update_fps() -> void:
	while true:
		await get_tree().create_timer(1).timeout
		fps.text = "FPS: [i]" + str(Engine.get_frames_per_second())



func display_wallet_button() -> void:
	wallet_button.visible = wa.wallet_unlocked.get_value()
	update_section_visibility(game_section)
	if wallet_button.visible:
		gv.flash(wallet_button, wallet.color)


func update_section_visibility(section: Node) -> void:
	section.visible = section.get_child(0).visible or section.get_child(1).visible


func display_upgrades_button(_menu: int, unlocked: bool) -> void:
	if _menu == UpgradeMenu.Type.NORMAL:
		upgrades_button.visible = unlocked
		update_section_visibility(game_section)


func flash_upgrade_button(_menu: int, unlocked: bool) -> void:
	if unlocked:
		select_upgrade_menu_tab(_menu, false)
		gv.flash(upgrades_button, up.get_menu_color(_menu))


func display_stage_button(stage: int, unlocked: bool) -> void:
	var _stage = gv.get_stage(stage)
	var b = get("stage" + str(stage))
	b.visible = unlocked
	if unlocked:
		if menu_contents.visible:
			gv.flash(menu_button, _stage.details.color)
		else:
			gv.flash(b, _stage.details.color)


func wallet_lock() -> void:
	wallet_button.visible = wa.wallet_unlocked.get_value()
	if wallet_button.visible:
		gv.flash(wallet_button, gv.get_stage_color(1))



# - Actions


func open_wallet(_show: bool) -> void:
	if wa.wallet_unlocked.is_true() or gv.dev_mode:
		hide_menus()
		if _show:
			wallet.show()


func select_upgrade_menu_tab(tab: int, _show = true) -> void:
	if up.is_menu_unlocked(tab) or gv.dev_mode:
		hide_menus()
		if _show:
			upgrade_container.show()
		upgrade_container.select_tab(tab)


func hide_menus() -> void:
	upgrade_container.hide()
	wallet.hide()
	offline_report.hide()
	close_menu()
	gv.clear_tooltip()


func select_stage(stage: int) -> void:
	hide_menus()
	lored_container.select_stage(stage)


func _on_limitbreak_pressed():
	limit_break_vico.visible = not limit_break_vico.visible



# - Dev
func _on_dev_1_pressed():
	wa.add(Currency.Type.COAL, 10)

func _on_dev_2_pressed():
	handbook.new_chat_request()


func _on_dev_3_pressed():
	up.limit_break.add_xp(up.limit_break.xp.get_total())


func _on_dev_4_pressed():
	wa.add(Currency.Type.MALIGNANCY, "1e20")

func update_dlabel():
	%Dlabel.text = str(up.get_upgrade(Upgrade.Type.AUTOSHOVELER).effect.applied.get_value())
