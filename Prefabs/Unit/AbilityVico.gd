extends MarginContainer



onready var rt = get_node("/root/Root")
onready var cooldown: MarginContainer = $"%Cooldown"
onready var hotkey_label: Label = $"%hotkey label"
onready var icon: Panel = $"%Lock"
onready var cooldown_progress: TextureProgress = $"MarginContainer/Cooldown/cooldown progress"
onready var cooldown_text: Label = $"%cooldown text"
onready var casting_border: Panel = $"%casting border"

var ability: UnitAbility
var ability_assigned := false

var hotkey: int

#var processing_gcd := false



func _ready() -> void:
	cooldown.hide()
	set_hotkey()
	hide_casting_border()



func _on_mouse_entered() -> void:
	if ability_assigned:
		rt.get_node("global_tip")._call("tooltip/Ability", {"ability": ability})


func _on_mouse_exited() -> void:
	rt.get_node("global_tip")._call("no")


func _on_Button_pressed() -> void:
	if healer.is_targeting_something():
		cast(healer.get_target())
	else:
		lv.lored[lv.Type.BLOOD].cannot_cast_ability(lv.ReasonCannotBeginJob.NO_TARGET)



func setup(_ability: UnitAbility) -> void:
	ability = _ability as UnitAbility
	ability_assigned = true
	ability.vico = self
	icon.set_icon(ability.icon)
	icon.set_modulate(Color(1,1,1))
	gv.connect("global_cooldown", self, "process_gcd")



func set_hotkey():
	assign_hotkey(OS.find_scancode_from_string(name))


func assign_hotkey(key: int) -> void:
	hotkey = key
	hotkey_label.text = OS.get_scancode_string(key)



func cast(target: Unit) -> void:
	if not ability_assigned:
		return
	if not ability.can_afford_to_cast(target):
		return
	if ability.is_on_cooldown():
		if ability.get_cooldown_remaining() < 0.5 and not lv.lored[lv.Type.BLOOD].is_casting():
			lv.lored[lv.Type.BLOOD].queue_cast_ability_at_target(ability, target)
		else:
			lv.lored[lv.Type.BLOOD].cannot_cast_ability(lv.ReasonCannotBeginJob.ABILITY_ON_CD, ability)
		return
	lv.lored[lv.Type.BLOOD].cast_ability_at_target(ability, target)



func process_gcd() -> void:
	if ability.just_cast:
		if ability.is_instant_cast():
			if ability.has_cooldown:
				if ability.cooldown.get_as_float() >= gv.gcd.get_as_float():
					return
	#processing_gcd = true
	process_cooldown()


func process_cooldown() -> void:
	cooldown.show()
	update_cooldown()
	
	var t := Timer.new()
	add_child(t)
	
	while not is_queued_for_deletion() and ability.is_on_cooldown():
		t.start(gv.fps)
		yield(t, "timeout")
		
		update_cooldown()
		
		if ability.is_on_cooldown:
			if ability.get_cooldown_remaining() <= 0.0:
				ability.stop_cooldown()
	
	cooldown.hide()
	t.queue_free()
	
	lv.lored[lv.Type.BLOOD].cast_queued_ability_if_applicable()


func update_cooldown() -> void:
	cooldown_progress.value = ability.get_cooldown_percent() * 100
	var cooldown := ability.get_cooldown_remaining()
	update_cooldown_text_color(cooldown)
	if cooldown >= 3:
		cooldown_text.text = str(floor(cooldown))
	else:
		cooldown_text.text = str(stepify(cooldown, 0.1)).pad_decimals(1)



func update_cooldown_text_color(cd: float) -> void:
	if cd > 3:
		if cooldown_text.modulate != Color(1, 0, 0):
			cooldown_text.modulate = Color(1, 0, 0)
	elif cd > 0.5:
		if cooldown_text.modulate != Color(1, 1, 0):
			cooldown_text.modulate = Color(1, 1, 0)
	else:
		if cooldown_text.modulate != Color(0, 1, 0):
			cooldown_text.modulate = Color(0, 1, 0)



func show_casting_border() -> void:
	casting_border.show()


func hide_casting_border() -> void:
	casting_border.hide()


func flash_casting_border() -> void:
	show_casting_border()
	yield(get_tree().create_timer(0.1), "timeout")
	hide_casting_border()

