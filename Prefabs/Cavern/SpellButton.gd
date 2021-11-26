extends MarginContainer



onready var rt = get_node("/root/Root")
onready var bg = get_node("bg")
onready var cooldown = get_node("cooldown")
onready var bar = get_node("cooldown/bar")
onready var bar_flair = get_node("cooldown/bar/flair")
onready var hotkey_text = get_node("hotkey/text")
onready var icon = get_node("m/icon/Sprite")


var spell := -1
var caster: Unit

var using_cd := true # false if using gcd_cd

var cd: float
var timer: Timer

var gcd_cd: float
var gcd_timer: Timer




func _ready() -> void:
	
	gv.connect("new_gcd", self, "newGCD")
	
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	
	gcd_timer = Timer.new()
	gcd_timer.one_shot = true
	add_child(gcd_timer)



func spellAssigned() -> bool:
	return spell >= 0


func cast():
	
	if not spellAssigned():
		return
	
	if gv.warlock.casting:
		return
	
	if not Cav.spell[spell].requires_target:
		
		gv.warlock.cast(spell, gv.warlock)
		
		return
	
	var target = yield(Cav, "spell_target_confirmed")
	
	if typeof(target) == TYPE_BOOL:
		# canceling the cast will return FALSE
		# successfully selecting a target 
		return
	
	caster.cast(spell, target)

func setHotkeyText(_text: String):
	hotkey_text.text = _text

func _on_bar_value_changed(value: float) -> void:
	
	if value <= 0:
		cooldown.hide()
		return
	
	bar_flair.value = value + 1

func setSpell(type: int):
	spell = type
	setIcon()
	setBorderColor()

func setIcon(type: int = spell):
	if type == -1:
		icon.hide()
		hotkey_text.hide()
		return
	icon.set_texture(Cav.spell[type].getIcon())
	icon.show()
	hotkey_text.show()

func setBorderColor():
	if not spellAssigned():
		bg.self_modulate = Color(0,0,0)
		return
	bg.self_modulate = gv.getSpellBorderColor(spell)



func spellCast(duration: float):
	
	cd = duration
	startTimer(timer, duration)

func newGCD(duration: float):
	
	if not spellAssigned():
		return
	
	if timer.is_stopped():
		startTimer(gcd_timer, duration)
		return
	
	var timer_time_left = timer.time_left
	
	if timer_time_left > duration:
		return
	
	if timer_time_left > 0 and timer_time_left < duration:
		startTimer(gcd_timer, duration)

func startTimer(_timer: Timer, duration: float):
	
	if _timer == timer:
		using_cd = true
		cd = duration
	else:
		using_cd = false
		gcd_cd = duration
	
	_timer.start(duration)
	
	bar.value = 100
	bar_flair.value = 100
	
	cooldown.show()
	
	var _max = cd if using_cd else gcd_cd
	
	var t = Timer.new()
	add_child(t)
	
	while _timer.time_left > 0:
		
		t.start(gv.fps)
		yield(t, "timeout")
		
		if (_timer == timer and using_cd) or (_timer == gcd_timer and not using_cd):
			bar.value = _timer.time_left / _max * 100
	
	#_timer.stop() # un-comment if timer isn't automatically stopped at the end of its timer
	t.queue_free()



func _on_select_mouse_entered() -> void:
	if not spellAssigned():
		hotkey_text.show()
		return
	
	rt.get_node("global_tip")._call("spell tooltip", {"spell": spell, "caster": gv.warlock, "color": bg.self_modulate})

func _on_select_mouse_exited() -> void:
	if not spellAssigned():
		hotkey_text.hide()
	rt.get_node("global_tip")._call("no")


func _on_select_pressed() -> void:
	cast()
