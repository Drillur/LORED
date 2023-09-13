extends MarginContainer



@onready var title_bg = %"title bg"
@onready var title = %Title
@onready var description = %description

var color: Color:
	set(val):
		color = val
		title_bg.modulate = val

var menu: UpgradeMenu



func setup(data: Dictionary) -> void:
	menu = up.get_upgrade_menu(data["menu"])
	if not is_node_ready():
		await ready
	color = menu.color
	description.text = get_prestige_description()


func get_prestige_description() -> String:
	var text := ""
	match menu.type:
		UpgradeMenu.Type.MALIGNANT:
			if gv.stage2.unlocked:
				var t = up.get_upgrade_menu(UpgradeMenu.Type.NORMAL).colored_name
				var s = gv.get_stage(Stage.Type.STAGE1).colored_name
				var m = wa.get_colored_currency_name(Currency.Type.MALIGNANCY)
				text = "Resets %s LOREDs, all %s, and all %s currencies except for %s." % [s, t, s, m]
			else:
				var t = up.get_upgrade_menu(UpgradeMenu.Type.NORMAL).colored_name
				var m = wa.get_colored_currency_name(Currency.Type.MALIGNANCY)
				text = "Resets all LOREDs, all %s, and all currencies except for %s." % [t, m]
	
	return text
