extends MarginContainer



var color: Color:
	set(val):
		color = val
		title_bg.modulate = val

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
		recipients.text = upgrade.get_effected_loreds_text()
		if upgrade.effect.effect != null:
			upgrade.effect.effect.connect("changed", update_effect_text) 
		update_effect_text()
		recipients.show()
		effect.show()
	
	match upgrade.type:
		Upgrade.Type.JOHN_PETER_BAIN_TOTALBISCUIT:
			description.text = "[center][i]I am here to ask and answer one simple question:\nWTF is LORED?[/i]"
			description.show()
	
	if up.is_upgrade_purchased(upgrade.type):
		match upgrade.type:
			Upgrade.Type.ITS_GROWIN_ON_ME:
				upgrade.effect.effect.increased.connect(update_dynamic_description)
				upgrade.effect.effect2.increased.connect(update_dynamic_description)
				update_dynamic_description()
			Upgrade.Type.I_DRINK_YOUR_MILKSHAKE:
				upgrade.effect.effect.increased.connect(update_dynamic_description)
				update_dynamic_description()



func update_effect_text() -> void:
	effect.text = upgrade.get_effect_text()


func purchased_changed() -> void:
	price.visible = upgrade.purchased.is_false()


func update_dynamic_description() -> void:
	description.text = upgrade.details.description 
	description.text += "\n\n" + upgrade.effect.get_dynamic_text()


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


func get_price_node() -> Node:
	return price
