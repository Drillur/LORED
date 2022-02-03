extends Node2D




onready var hotbar = get_node("m/bot/v/hotbar")
onready var castbar = get_node("m/bot/v/castbar")

onready var mana = get_node("m/top/h/mana/m/v/amount")

var mana_restored := Big.new(0)
var mana_surplus := Big.new(0)
var mana_update_pending := false

onready var t_mana_text = get_node("mana_text")
onready var mana_texts = get_node("m/bot/v/resources/h/mana/texts")

var mana_bar_width: int

var buffs := {}
onready var gn_buffs = get_node("m/bot/v/buffs")



func _ready() -> void:
	castbar.hide()
	sm.castbar = castbar
	sm.hotbar = hotbar
	gv.connect("mana_restored", self, "manaRestored")
	gv.connect("buff_applied", self, "buffApplied")
	gv.connect("buff_renewed", self, "buffRenewed")
	setManaText()
	mana_bar_width = get_node("m/bot/v/resources/h/mana/total").rect_size.x


func save() -> String:
	
	var data := {}
	
	data["hotbar"] = hotbar.save()
	
	return var2str(data)

func load(raw_data: String):
	
	var data = str2var(raw_data)
	
	if "hotbar" in data.keys():
		hotbar.load(data["hotbar"])



func setup():
	hotbar.setup()

func setupUnit():
	
	setResourceVisibility()
	
	gv.warlock.health.setBar(get_node("m/bot/v/resources/h/life/v/health"))
	gv.warlock.barrier.setBar(get_node("m/bot/v/resources/h/life/v/barrier"))
	gv.warlock.mana.setBar(get_node("m/bot/v/resources/h/mana/total"))
	#gv.warlock.stamina.setBar(get_node("m/bot/v/resources/h/m/v/barrier"))
	
	gv.warlock.health.setText(get_node("m/bot/v/resources/h/life/texts/health"))
	gv.warlock.barrier.setText(get_node("m/bot/v/resources/h/life/texts/barrier"))
	gv.warlock.mana.setText(get_node("m/bot/v/resources/h/mana/text"))
	
	gv.warlock.updateVisualComponents()

func setResourceVisibility():
	if gv.warlock.type == Cav.UnitClass.ARCANE_LORED:
		get_node("m/bot/v/resources/op").hide()
		get_node("m/bot/v/resources/h/life/texts/barrier").hide()
		get_node("m/bot/v/resources/h/life/v/barrier").hide()
	else:
		get_node("m/bot/v/resources/op").show()
		get_node("m/bot/v/resources/h/life/texts/barrier").show()
		get_node("m/bot/v/resources/h/life/v/barrier").show()




func input(ev):
	
	# called from _Root.gd
	
	if ev.is_action_pressed("ui_cancel"):
		if gv.warlock.isCasting():
			castbar.cancelCast()
			return
	
	if ev.is_class("InputEventMouseButton"):
		return
	
	hotbar.input(ev)



func setManaText():
	mana.text = gv.r["mana"].toString()


func manaRestored(x: Big, surplus: bool):
	
	if surplus:
		setManaText()
		mana_surplus.a(x)
	else:
		mana_restored.a(x)
	
	if mana_update_pending:
		return
	
	if not t_mana_text.is_stopped():
		mana_update_pending = true
		yield(t_mana_text, "timeout")
		mana_update_pending = false
	
	t_mana_text.start()
	prepManaText()

func prepManaText():
	
	var text := ""
	
	if mana_restored.greater(0):
		text += "+" + mana_restored.toString()
		mana_restored = Big.new(0)
	
	if mana_surplus.greater(0):
		if text.length() > 0:
			text += " "
		text += "(+" + mana_surplus.toString() + ")"
		mana_surplus = Big.new(0)
	
	displayManaText(text)

func displayManaText(text: String):
	
	if text == "":
		return
	
	var data := {
		"text": text,
		"color": gv.COLORS["mana"],
		#"icon": gv.sprite["mana"]
	}
	var d = gv.SRC["flying text"].instance()
	d.init(data)
	mana_texts.add_child(d)
	d.rect_position = Vector2(
		(mana_bar_width / 2) - (d.rect_size.x / 2),
		0
	)



func buffRenewed(buff: int, duration: float):
	
	buffs[buff].updateDuration(duration) #note2trying to make buffs throbBorder() when cast

func buffApplied(target: Unit, data: Dictionary):
	#zBuffApplied
	buffs[[target, data["type"]]] = gv.SRC["cavern/buff"].instance()
	buffs[[target, data["type"]]].init(data)
	gn_buffs.add_child(buffs[[target, data["type"]]])
	
	bm.createBuffVicoReference(target, data["type"], buffs[[target, data["type"]]])

func buffExpired(buff: int):
	buffs.erase(buff)






func reset(tier: int):
	
	gv.warlock.clearBuffs()
	castbar.cancelCast()
	mana_restored = Big.new(0)
	gv.warlock = Unit.new(Cav.UnitClass.ARCANE_LORED)
	setupUnit()
	
	hotbar.reset(tier)



func _on_Button_pressed() -> void:
	# for testing 
	setupUnit()
	hotbar.setSpell("0/5", Cav.Spell.CORE_RIFT)
	hotbar.setSpell("0/6", Cav.Spell.ARCANE_FOCUS) #z02
	hotbar.setSpell("0/7", Cav.Spell.VITALIZE)
	hotbar.setSpell("0/8", Cav.Spell.ARCANE_FLOW)


func _on_Button2_pressed() -> void:
	Cav.reset(3)
