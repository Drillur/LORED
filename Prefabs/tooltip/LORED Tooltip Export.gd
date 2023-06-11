extends MarginContainer


func setup(resource: int):
	if gv.resource_is_locked(resource):
		get_node("%top text").text = "Locked"
		get_node("%icon").set_icon(gv.sprite["Lock"])
		get_node("%text_locked").show()
	else:
		get_node("%top text").text = "Unlocked"
		get_node("%icon").set_icon(gv.sprite["Unlock"])
		get_node("%text_unlocked").show()
