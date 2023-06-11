extends MarginContainer


onready var lock = get_node("Lock")
onready var icon = get_node("icon")

var upgrade_key: String

func init(_upgrade_key: String) -> void:
	
	upgrade_key = _upgrade_key
	icon.set_icon(gv.sprite[str(gv.up[upgrade_key].icon)])
	lock.self_modulate = gv.up[upgrade_key].color
	
	update()

func update():
	
	if upgrade_key == "":
		return
	
	if gv.up[upgrade_key].have or gv.up[upgrade_key].requirements():
		icon.show()
		lock.hide()
	else:
		icon.hide()
		lock.show()
