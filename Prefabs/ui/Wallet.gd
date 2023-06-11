extends MarginContainer



onready var stage1 = get_node("%resources1")
onready var stage2 = get_node("%resources2")
onready var stage3 = get_node("%resources3")
onready var stage4 = get_node("%resources4")

onready var tab_container = get_node("%TabContainer") as TabContainer

enum Sort {
	RESOURCE_ASCENDING,
	RESOURCE_DESCENDING,
	AMOUNT_ASCENDING,
	AMOUNT_DESCENDING,
	INCOME_ASCENDING,
	INCOME_DESCENDING,
}

var resource: Dictionary

var sort := -1 setget set_sort
func set_sort(val: int):
	sort = val
	sort_resources(tab_container.current_tab + 1)



func _ready():
	
	gv.connect("tab_unlocked", self, "tab_unlocked")
	gv.connect("stats_unlockResource", self, "resource_unlocked")
	
	lock_all_tabs()
	
	yield(get_tree().create_timer(0.1), "timeout")
	remove_from_group("Resources")
	
	sort_by_resource()


func _on_visibility_changed() -> void:
	if visible:
		connect_resources_in_tab(tab_container.current_tab + 1)
		sort_resources(tab_container.current_tab + 1)
	else:
		disconnect_resources()


func _on_TabContainer_tab_changed(tab: int) -> void:
	disconnect_resources()
	connect_resources_in_tab(tab + 1)
	sort_resources(tab + 1)


func _on_sort_resource_button_down() -> void:
	sort_by_resource()


func _on_sort_amount_button_down() -> void:
	sort_by_amount()


func _on_sort_income_button_down() -> void:
	sort_by_income()



func lock_all_tabs():
	tab_container.set_tab_hidden(1, true)
	tab_container.set_tab_hidden(2, true)
	tab_container.set_tab_hidden(3, true)


func connect_resources_in_tab(tab: int):
	if visible:
		get_tree().call_group("Resources", "connect_net_updated", tab)
		get_tree().call_group("Resources", "connect_resourceChanged", tab)


func disconnect_resources():
	get_tree().call_group("Resources", "disconnect_net_updated")
	get_tree().call_group("Resources", "disconnect_resourceChanged")



func tab_unlocked(_tab: int):
	
	var tab: int = _tab - gv.Tab.S1 + 1 # if Stage 2, will be 2.
	
	tab_container.set_tab_hidden(tab - 1, false)
	
	if tab == 2:
		display_tabs()


func display_tabs():
	tab_container.tabs_visible = true
	tab_container.current_tab = 2
	tab_container.current_tab = 1


func resource_unlocked(_resource: int):
	
	resource[_resource] = gv.SRC["WalletResource"].instance()
	resource[_resource].setup(_resource)
	
	var tab: int = 4
	
	if _resource in gv.list["stage 3 resources"]:
		tab = 3
	elif _resource in gv.list["stage 2 resources"]:
		tab = 2
	elif _resource in gv.list["stage 1 resources"]:
		tab = 1
	
	get("stage" + str(tab)).add_child(resource[_resource])
	
	if visible:
		sort_resources(tab)



func sort_resources(tab: int):
	
	var tab_node = get("stage" + str(tab))
	var sorted_nodes: Array = tab_node.get_children()
	
	sorted_nodes.sort_custom(self, "sort")
	
	for node in tab_node.get_children():
		tab_node.remove_child(node)
	
	for node in sorted_nodes:
		tab_node.add_child(node)


func sort(a: Node, b: Node):
	match sort:
		Sort.RESOURCE_ASCENDING:
			return a.name.naturalnocasecmp_to(b.name) < 0
		Sort.RESOURCE_DESCENDING:
			return a.name.naturalnocasecmp_to(b.name) > 0
		Sort.AMOUNT_ASCENDING:
			return gv.resource[a.resource].greater(gv.resource[b.resource])
		Sort.AMOUNT_DESCENDING:
			return gv.resource[a.resource].less(gv.resource[b.resource])
		Sort.INCOME_ASCENDING, Sort.INCOME_DESCENDING:
			var a_net = lv.net(a.resource)
			var b_net = lv.net(b.resource)
			if a_net[1] < 0 and b_net[1] < 0:
				if sort == Sort.INCOME_ASCENDING:
					return a_net[0].less(b_net[0])
				else:
					return a_net[0].greater(b_net[0])
			elif a_net[1] < 0:
				if sort == Sort.INCOME_ASCENDING:
					return false
				return true
			elif b_net[1] < 0:
				if sort == Sort.INCOME_ASCENDING:
					return true
				return false
			else:
				return a_net[0].greater(b_net[0])



func sort_by_resource():
	hide_all_sorts_except("WalletSortResource")
	if sort == Sort.RESOURCE_ASCENDING:
		flip_sorts("WalletSortResource")
		set_sort(Sort.RESOURCE_DESCENDING)
	elif sort == Sort.RESOURCE_DESCENDING:
		flip_sorts("WalletSortResource")
		set_sort(Sort.RESOURCE_ASCENDING)
	else:
		set_sort(Sort.RESOURCE_ASCENDING)
	reset_all_sorts_except("WalletSortResource")


func sort_by_amount():
	hide_all_sorts_except("WalletSortAmount")
	if sort == Sort.AMOUNT_ASCENDING:
		flip_sorts("WalletSortAmount")
		set_sort(Sort.AMOUNT_DESCENDING)
	elif sort == Sort.AMOUNT_DESCENDING:
		flip_sorts("WalletSortAmount")
		set_sort(Sort.AMOUNT_ASCENDING)
	else:
		set_sort(Sort.AMOUNT_ASCENDING)
	reset_all_sorts_except("WalletSortAmount")


func sort_by_income():
	hide_all_sorts_except("WalletSortIncome")
	if sort == Sort.INCOME_ASCENDING:
		flip_sorts("WalletSortIncome")
		set_sort(Sort.INCOME_DESCENDING)
	elif sort == Sort.INCOME_DESCENDING:
		flip_sorts("WalletSortIncome")
		set_sort(Sort.INCOME_ASCENDING)
	else:
		set_sort(Sort.INCOME_ASCENDING)
	reset_all_sorts_except("WalletSortIncome")


func flip_sorts(_sort: String):
	get_tree().call_group(_sort, "flip")


func hide_all_sorts_except(visible_sort: String):
	
	for group in ["WalletSortResource", "WalletSortAmount", "WalletSortIncome"]:
		
		if group == visible_sort:
			get_tree().call_group(group, "show")
			continue
		
		get_tree().call_group(group, "hide")


func reset_all_sorts_except(this_one: String):
	
	for group in ["WalletSortResource", "WalletSortAmount", "WalletSortIncome"]:
		
		if group == this_one:
			continue
		
		get_tree().call_group(group, "reset")
