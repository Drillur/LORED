extends MarginContainer



@onready var tooltip_parent = %Tooltip
@onready var lored_container = $"LORED Container" as LOREDContainer
@onready var upgrade_container = $"Upgrade Container" as UpgradeContainer
@onready var random_wishes = %"Random Wishes"
@onready var main_wishes = %"Main Wishes"
@onready var control = $Control
@onready var menu = $Menu
@onready var menu_button = %"Menu Button" as IconButton
@onready var upgrades_button = %"Upgrades Button" as IconButton
@onready var wallet = $Wallet as WalletVico
@onready var wallet_button = %"Wallet Button" as IconButton
@onready var stage1 = %Stage1 as IconButton
@onready var stage2 = %Stage2 as IconButton
@onready var stage3 = %Stage3 as IconButton
@onready var stage4 = %Stage4 as IconButton
@onready var purchasable_upgrade_count = %"Purchasable Upgrade Count"
@onready var offline_report = $"Offline Report"

@onready var tooltip_position_display = $"Control/Tooltip/Tooltip Position Display"



func _ready():
	if not gv.dev_mode:
		tooltip_position_display.queue_free()
		upgrades_button.hide()
		wallet_button.hide()
	
	wa.wallet_unlocked_changed.connect(display_wallet_button)
	
	up.purchasable_upgrade_count_changed.connect(update_purchasable_upgrade_count)
	up.menu_unlocked_changed.connect(display_upgrades_button)
	up.menu_unlocked_changed.connect(flash_upgrade_button)
	wa.wallet_unlocked_changed.connect(wallet_lock)
	
	update_purchasable_upgrade_count(0)
	
	gv.tooltip_parent = tooltip_parent
	gv.texts_parent = control
	lv.lored_container = lored_container
	up.upgrade_container = upgrade_container
	wi.main_wish_container = main_wishes
	wi.random_wish_container = random_wishes
	wa.wallet = wallet
	
	for i in range(1, 5):
		var b = get("stage" + str(i)) as IconButton
		b.remove_optionals()
		var stage = gv.get_stage(i) as Stage
		b.set_icon(stage.icon)
		b.button.modulate = stage.color
		stage.stage_unlocked_changed.connect(display_stage_button)
		if not gv.dev_mode:
			b.hide()
	
	menu_button.color = gv.game_color
	menu_button.set_icon(load("res://Sprites/Hud/Menu.png"))
	menu_button.remove_optionals()
	
	upgrades_button.color = up.get_menu_color(UpgradeMenu.Type.NORMAL)
	upgrades_button.set_icon(load("res://Sprites/Hud/upgrades.png"))
	upgrades_button.remove_optionals()
	upgrade_container.connect("upgrade_menu_tab_changed", update_upgrades_button_color)
	
	wallet_button.color = gv.get_stage_color(1)
	wallet_button.set_icon(load("res://Sprites/Hud/ResourceViewer.png"))
	wallet_button.remove_optionals()
	gv.connect("stage_changed", stage_changed)
	
	gv.root_ready = true
	
	lv.start()
	em.start()
	
	if SaveManager.can_load_game():
		SaveManager.load_game()
	else:
		SaveManager.save_file_color = gv.get_random_color()
		gv.update_discord_details("Just began a new game!")
	
	wi.start()



func _input(event):
	if Input.is_action_just_pressed("Tilde"):
		up.get_upgrade(Upgrade.Type.GRINDER).refund()
	
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
		if menu.visible:
			node = menu
			button = menu_button
		elif offline_report.visible:
			node = offline_report
		elif upgrade_container.visible:
			node = upgrade_container
			button = upgrades_button
		elif wallet.visible:
			node = wallet
			button = wallet_button
		
		if (esc_pressed
			or (
				not gv.node_has_point(node, event.position)
				and (
					button == null
					or not gv.node_has_point(button, event.position)
				)
			)
		):
			node.hide()
			gv.clear_tooltip()
			return
	
	if esc_pressed and not menu.visible:
		menu.show()
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
	return menu.visible or upgrade_container.visible or wallet.visible or offline_report.visible


func _on_menu_button_pressed():
	if menu.visible:
		menu.hide()
	else:
		menu.show()


func _on_upgrades_button_pressed():
	if upgrade_container.visible:
		upgrade_container.hide()
	else:
		upgrade_container.show()


func _on_wallet_button_pressed():
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



# - Signal Shit

func update_upgrades_button_color(upgrade_menu_tab: int) -> void:
	upgrades_button.modulate = up.get_menu_color(upgrade_menu_tab)


func stage_changed(stage: int) -> void:
	wallet_button.modulate = gv.get_stage_color(stage)


func update_purchasable_upgrade_count(count: int) -> void:
	purchasable_upgrade_count.visible = count != 0
	purchasable_upgrade_count.text = "[rainbow freq=0.2 sat=1.0 val=1.0][wave amp=40 freq=1.0]" + str(count)




# - Ref

func display_wallet_button(unlocked: bool) -> void:
	wallet_button.visible = unlocked
	if unlocked:
		gv.flash(wallet_button, wallet.color)


func display_upgrades_button(_menu: int, unlocked: bool) -> void:
	if _menu == UpgradeMenu.Type.NORMAL:
		upgrades_button.visible = unlocked


func flash_upgrade_button(_menu: int, unlocked: bool) -> void:
	if unlocked:
		select_upgrade_menu_tab(_menu, false)
		gv.flash(upgrades_button, up.get_menu_color(_menu))


func display_stage_button(stage: int, unlocked: bool) -> void:
	var _stage = gv.get_stage(stage)
	var b = get("stage" + str(stage))
	b.visible = unlocked
	if unlocked:
		gv.flash(b, _stage.color)


func wallet_lock(unlocked: bool) -> void:
	wallet_button.visible = unlocked
	if wallet_button.visible:
		gv.flash(wallet_button, gv.get_stage_color(1))



# - Actions

func open_wallet(_show: bool) -> void:
	if wa.wallet_unlocked or gv.dev_mode:
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
	menu.hide()
	wallet.hide()
	offline_report.hide()
	gv.clear_tooltip()


func select_stage(stage: int) -> void:
	hide_menus()
	lored_container.select_stage(stage)



# - Get


@onready var dev_text = $Left/Dev/RichTextLabel
func _on_dev_pressed():
	wa.add(Currency.Type.STONE, 10)
	wa.add(Currency.Type.COAL, 10)
	if lv.is_lored_unlocked(LORED.Type.IRON):
		lv.get_lored(LORED.Type.IRON).purchase()
		lv.get_lored(LORED.Type.COPPER).purchase()
		lv.get_lored(LORED.Type.COPPER_ORE).purchase()
		lv.get_lored(LORED.Type.IRON_ORE).purchase()

var test_data: String
func _on_dev_2_pressed():
	gv.reset(1)
	pass

func _on_dev_4_pressed():
	pass # Replace with function body.

func _on_dev_3_pressed():
	gv.reset(2)
	pass

func _on_dev_5_pressed():
	pass # Replace with function body.



