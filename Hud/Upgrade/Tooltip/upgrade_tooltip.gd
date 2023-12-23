extends MarginContainer



var color: Color:
	set(val):
		color = val
		title_bg.modulate = val
		pending_prestige_background.modulate = val
		pending_prestige_breaker.modulate = val

@onready var title_bg = %"title bg"
@onready var title = %Title
@onready var effect = %effect
@onready var recipients = %recipients
@onready var description = %description
@onready var price = %Price as PriceVico
@onready var unlocked = %Unlocked

@onready var locked = %Locked
@onready var required_upgrade = %required_upgrade
@onready var required_upgrade_title_bg = %"required upgrade title bg"
@onready var random_upgrade_description = %random_upgrade_description

@onready var pending_prestige = %"Pending Prestige"
@onready var pending_prestige_title = %"Pending Prestige Title"
@onready var pending_prestige_description = %"Pending Prestige Description"
@onready var pending_prestige_background = %"Pending Prestige Background"
@onready var pending_prestige_breaker = %breaker

var is_pending_prestige_set := false

var upgrade: Upgrade



func setup(data: Dictionary) -> void:
	upgrade = data["upgrade"]
	if not is_node_ready():
		await ready
	title.text = upgrade.details.name
	color = upgrade.details.color
	
	upgrade.purchased.connect_and_call("changed", purchased_changed)
	upgrade.unlocked.connect_and_call("changed", upgrade_unlocked_changed)
	
	price.setup(upgrade.cost)
	price.color = upgrade.details.color
	
	if upgrade.has_required_upgrade:
		required_upgrade.text = "[center][b][i]" + up.get_icon_and_name_text(upgrade.required_upgrade)
		required_upgrade_title_bg.modulate = up.get_color(upgrade.required_upgrade)
	
	if upgrade.has_description:
		effect.hide()
		recipients.hide()
		var text_length = upgrade.details.description.length()
		description.custom_minimum_size.x = min(250, max(50 + text_length * 2, 100))
		description.text = upgrade.details.description
		description.show()
	else:
		description.hide()
		upgrade.effect.text.changed.connect(update_effect_text)
		recipients.text = upgrade.effect.get_recipients_text()
		update_effect_text()
		recipients.show()
		effect.show()
	
	pending_prestige_changed()
	upgrade.pending_prestige.changed.connect(pending_prestige_changed)
	upgrade.pending_prestige.became_true.connect(pending_prestige_became_true)
	
	match upgrade.type:
		Upgrade.Type.JOHN_PETER_BAIN_TOTALBISCUIT:
			description.text = "[center][i]I am here to ask and answer one simple question:\nWTF is LORED?[/i]"
			description.show()
	
	if up.is_upgrade_purchased(upgrade.type):
		match upgrade.type:
			Upgrade.Type.ITS_SPREADIN_ON_ME, Upgrade.Type.ITS_GROWIN_ON_ME:
				upgrade.effect.value.value.changed.connect(update_dynamic_description)
				update_dynamic_description()
			Upgrade.Type.I_DRINK_YOUR_MILKSHAKE:
				upgrade.effect.value.value.increased.connect(update_dynamic_description)
				update_dynamic_description()
			Upgrade.Type.CAPITAL_PUNISHMENT:
				gv.stage1.prestiged.connect(update_dynamic_description)
				update_dynamic_description()



func update_effect_text() -> void:
	effect.text = "[center]" + upgrade.get_effect_text()


func purchased_changed() -> void:
	price.visible = upgrade.purchased.is_false()


func update_dynamic_description() -> void:
	description.text = upgrade.details.description
	description.text += "\n\n[center]" + upgrade.get_effect_text()


func upgrade_unlocked_changed() -> void:
	if upgrade.unlocked.is_true():
		unlocked.show()
		locked.hide()
	else:
		unlocked.hide()
		locked.show()
		set_random_upgrade_description()


func set_random_upgrade_description() -> void:
	random_upgrade_description.text = up.get_random_upgrade_description()
	var text_length = random_upgrade_description.text.length()
	random_upgrade_description.custom_minimum_size.x = min(280, max(50 + text_length * 2, custom_minimum_size.x))


func pending_prestige_changed() -> void:
	pending_prestige.visible = upgrade.pending_prestige.get_value()
	if upgrade.pending_prestige.is_true():
		if not is_pending_prestige_set:
			is_pending_prestige_set = true
			pending_prestige_title.text = pending_prestige_title.text % up.get_upgrade_menu(upgrade.upgrade_menu).noun
			pending_prestige_description.text = pending_prestige_description.text % up.get_upgrade_menu(upgrade.upgrade_menu).present_verb


func pending_prestige_became_true() -> void:
	gv.flash(pending_prestige, color)




func get_price_node() -> Node:
	return price
