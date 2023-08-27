extends MarginContainer



@onready var rewards_title_bg = %"rewards title bg"
@onready var face = %face
@onready var giver = %giver
@onready var text = %text
@onready var rewards = %Rewards
@onready var reward_details = %RewardDetails
@onready var info = %Info
@onready var lucky_multiplier = %lucky_multiplier
@onready var info_title_bg = %"info title bg"

var color: Color:
	set(val):
		color = val
		if wish.has_rewards():
			rewards_title_bg.modulate = val
		if not wish.is_main_wish():
			info_title_bg.modulate = val

var wish: Wish



func setup(data: Dictionary) -> void:
	wish = data["wish"]
	if not is_node_ready():
		await ready
	
	color = wish.get_color()
	giver.text = lv.get_lored(wish.giver).colored_name
	face.modulate = lv.get_color(wish.giver)
	
	set_text(wish.help_text)
	set_face(wish.help_icon)
	setup_reward_text()
	
	if not wish.ready_to_turn_in:
		wish.became_ready_to_turn_in.connect(set_to_thank_text)
	else:
		set_to_thank_text()
	
	if wish.is_main_wish():
		info.queue_free()
	else:
		lucky_multiplier.text = "[center][i]Lucky multiplier: [b]" + Big.get_float_text(wish.lucky_multiplier)


func set_to_thank_text() -> void:
	set_text(wish.thank_text)
	set_face(wish.thank_icon)


func setup_reward_text() -> void:
	if not wish.has_rewards():
		rewards.queue_free()
		return
	for _text in wish.get_reward_texts():
		var x = gv.label.instantiate()
		x.text = _text
		reward_details.add_child(x)


func set_text(_text: String) -> void:
	if _text == "":
		text.hide()
	else:
		text.show()
		text.text = "[i]" + _text
		text.custom_minimum_size.x = min(250, max(50 + text.text.length() * 2, 100))


func set_face(icon: Texture) -> void:
	face.texture = icon
