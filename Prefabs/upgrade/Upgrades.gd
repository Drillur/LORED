extends MarginContainer



onready var tab_container: TabContainer = get_node("%TabContainer")
var up_con: UpgradeContainer

var color: Color setget set_colors
var stripes := {}



func _ready() -> void:
	
	if gv.active_scene == gv.Scene.ROOT:
		up_con = get_node("/root/Root").get_node(get_node("/root/Root").gnupcon)
		tab_container.set_tab_hidden(1, true)
		tab_container.set_tab_hidden(2, true)
		tab_container.set_tab_hidden(3, true)
		tab_container.set_tab_hidden(4, true)
		tab_container.set_tab_hidden(5, true)
		tab_container.tabs_visible = false
		for x in 8:
			tab_container.set_tab_title(x, gv.Tab.keys()[x].capitalize())
	elif gv.active_scene == gv.Scene.MAIN_MENU:
		get_node("%sub").hide()
		get_node("%ROUTINE").get_parent().queue_free()
	
	gv.connect("upgrade_purchased", self, "upgrade_purchased")



func _on_TabContainer_tab_changed(tab: int) -> void:
	
	gv.open_tab = tab
	set_colors(gv.COLORS[str(tab)])
	update_max_count()
	update_current_count()
	
	if gv.active_scene == gv.Scene.ROOT:
		up_con.tab_changed(tab)



func setup():
	update_upgrades(0)
	_on_TabContainer_tab_changed(0)



func update_current_count():
	
	var owned: int = gv.list.upgrade["owned " + str(tab_container.current_tab)].size()
	get_node("%current count").text = str(owned)


func update_max_count():
	
	var total = gv.list.upgrade[str(tab_container.current_tab)].size()
	
	if tab_container.current_tab == gv.Tab.MALIGNANT:
		total -= 1
	
	get_node("%max count").text = "/" + str(total)



func upgrade_purchased(key: String, _routine: Array):
	if gv.up[key].tab == tab_container.current_tab:
		update_current_count()


func update_upgrades(tab: int):
	for hbox in get_node("%" + str(tab) + "/MarginContainer/Upgrades").get_children():
		for u in hbox.get_children():
			u.r_update()



func set_colors(_color: Color) -> void:
	
	color = _color
	get_node("%count").modulate = color
	tab_container.self_modulate = color
	get_stripes(tab_container.current_tab).modulate = color


func get_stripes(tab: int):
	if not tab in stripes.keys():
		stripes[tab] = get_node("%" + str(tab_container.current_tab) + "/MarginContainer/Stripes")
	return stripes[tab]


func unlock_tab(tab: int):
	
	tab_container.set_tab_hidden(tab, false)
	if tab == 1:
		tab_container.tabs_visible = true
	
	connect_resource_signal_for_upgrades_in_tab(tab)


func lock_tab(tab: int):
	tab_container.set_tab_hidden(tab, true)
	disconnect_resource_signal_for_upgrades_in_tab(tab)


func connect_resource_signal_for_upgrades_in_tab(tab: int):
	for upgrade in gv.list.upgrade[str(tab)]:
		if not gv.up[upgrade].active():
			gv.up[upgrade].manager.connect_resource_signal()

func disconnect_resource_signal_for_upgrades_in_tab(tab: int):
	for upgrade in gv.list.upgrade[str(tab)]:
		gv.up[upgrade].manager.disconnect_resource_signal()


func select_tab(tab: int):
	tab_container.current_tab = tab

func get_tab() -> int:
	return tab_container.current_tab


func unlock_upgrade(key: String):
	# main menu only
	get_node("%" + key).check_the_checkbox_from_the_main_menu()
func lock_upgrade(key: String):
	# main menu only
	get_node("%" + key).uncheck_the_checkbox_from_the_main_menu()


func randomize_starting_upgrades() -> void:
	# main menu only
	for tab in tab_container.get_children():
		for hbox in tab.get_node("MarginContainer/Upgrades").get_children():
			for upgrade in hbox.get_children():
				var roll = randi() % 2
				if roll == 0:
					diff.unlock_upgrade(upgrade.name)
				else:
					diff.lock_upgrade(upgrade.name)
