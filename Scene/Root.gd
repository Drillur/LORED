extends MarginContainer



@onready var tooltip_parent = %Tooltip
@onready var lored_container = $"LORED Container" as LOREDContainer
@onready var upgrade_container = $"Upgrade Container" as UpgradeContainer
@onready var random_wishes = %"Random Wishes"
@onready var main_wishes = %"Main Wishes"
@onready var control = $Control
@onready var menu = $Menu
@onready var menu_button = %"Menu Button"
@onready var upgrades_button = %"Upgrades Button"



func _ready():
	gv.tooltip_parent = tooltip_parent
	gv.texts_parent = control
	lv.lored_container = lored_container
	up.upgrade_container = upgrade_container
	wi.main_wish_container = main_wishes
	wi.random_wish_container = random_wishes
	
	menu_button.modulate = gv.game_color
	menu_button.set_icon(preload("res://Sprites/Hud/Menu.png"))
	menu_button.remove_check().remove_icon_shadow()
	
	upgrades_button.modulate = up.get_menu_color(UpgradeMenu.Type.NORMAL)
	upgrades_button.set_icon(preload("res://Sprites/Hud/upgrades.png"))
	upgrades_button.remove_check().remove_icon_shadow()
	upgrade_container.connect("upgrade_menu_tab_changed", update_upgrades_button_color)
	
	if SaveManager.can_load_game():
		load_game()
	else:
		new_game()
	
	display_and_repeatedly_flash_upgrades_button()



func _input(event):
	if Input.is_action_just_pressed("Tilde"):
		up.get_upgrade(Upgrade.Type.GRINDER).refund()
	
	var esc_pressed = Input.is_action_just_pressed("ESC")
	var left_clicked = Input.is_action_just_pressed("LeftClick")
	
	if (left_clicked and event.get("position")) or esc_pressed:
		if menu.visible:
			if esc_pressed or (not gv.node_has_point(menu, event.position) and not gv.node_has_point(menu_button, event.position)):
				menu.hide()
				gv.clear_tooltip()
				return
		elif upgrade_container.visible:
			if esc_pressed or (not gv.node_has_point(upgrade_container, event.position) and not gv.node_has_point(upgrades_button, event.position)):
				upgrade_container.hide()
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
	
	if Input.is_action_just_pressed("Mouse Wheel Down"):
		gv.clear_tooltip()
		return
	if Input.is_action_just_pressed("Mouse Wheel Up"):
		gv.clear_tooltip()
		return



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



func _on_upgrades_button_visibility_changed():
	if not is_node_ready():
		return
	if upgrades_button.visible:
		gv.flash(upgrades_button, Color(0, 1, 0))




# - Signal Shit

func update_upgrades_button_color(upgrade_menu_tab: int) -> void:
	upgrades_button.modulate = up.get_menu_color(upgrade_menu_tab)



# - Ref

func display_and_repeatedly_flash_upgrades_button() -> void:
	if not up.is_menu_unlocked(UpgradeMenu.Type.NORMAL):
		upgrades_button.hide()
		while true:
			var _menu = await up.menu_unlocked
			upgrades_button.show()
			select_upgrade_menu_tab(_menu, false)
			gv.flash(upgrades_button, up.get_menu_color(_menu))



# - Actions

func new_game() -> void:
	lv.new_game_start()
	wi.new_game_start()
	em.new_game_start()


func load_game() -> void:
	#loreds
	#upgrades
	#wi.load
	#em.load
	
	# after all autoload nodes have loaded, start all of them.
	lv.loaded_game_start()
	wi.loaded_game_start()
	em.loaded_game_start()



func select_upgrade_menu_tab(tab: int, _show = true) -> void:
	if up.is_menu_unlocked(tab) or gv.dev_mode:
		if _show:
			upgrade_container.show()
			menu.hide()
		upgrade_container.select_tab(tab)



# - Get






var i = 0
func _on_dev_pressed():
	i += 1
#	wa.add(Currency.Type.STONE, 10)
#	wa.add(Currency.Type.COAL, 10)

func _on_dev_2_pressed():
	lv.get_lored(LORED.Type.IRON).purchase()
	lv.get_lored(LORED.Type.COPPER).purchase()
	lv.get_lored(LORED.Type.COPPER_ORE).purchase()
	lv.get_lored(LORED.Type.IRON_ORE).purchase()

func _on_dev_3_pressed():
	wi.find_new_random_wish()

