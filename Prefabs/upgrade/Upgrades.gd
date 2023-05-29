extends MarginContainer



var tab: int



func setup(_tab: int):
	
	tab = _tab
	
	name = gv.Tab.keys()[tab].capitalize()
	
	for upgrade_tab in get_node("%Delete Incorrect Children").get_children():
		if upgrade_tab.name != str(tab):
			upgrade_tab.queue_free()
