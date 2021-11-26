class_name Ability
extends Reference



var type: int

var name: String
var desc := ""

var bbcode_name := ""

var order: Array

var deals_damage := false
var damage: Cav.Damage

var restores_mana := false
var restore_mana: Cav.UnitAttribute

var triggers_nr := true



func _init(_type: int):
	type = _type

func constructFin():
	
	deals_damage = damage != null
	restores_mana = restore_mana != null
	
	assumeBbcodeName()

func assumeBbcodeName():
	if bbcode_name != "":
		return
	if deals_damage:
		if damage.types == 1:
			setBbcodeName(gv.COLORS[gv.damageTypeToStr(damage.type[0])].to_html())

func setBbcodeName(_bbcode_name: String):
	bbcode_name = _bbcode_name

func setOrder(_order: Array):
	order = _order

func getDesc_damage(text: String, dmg_array: Array) -> String:
	
	# can be used by both Buff and Spell
	
	for x in dmg_array.size():
		var dmg = dmg_array[x].toString()
		var dmg_type = gv.damageTypeToStr(damage.type[x])
		var color = "[color=#" + gv.COLORS[dmg_type].to_html() + "]"
		text = text.format({"damage" + str(x): color + dmg + " " + dmg_type + "[/color]"})
	
	return text

func getDesc_other(text: String) -> String:
	
	while "{buff:" in text:
		var key = text.split("buff:")[1].split("}")[0]
		var buff_name = key.replace("_", " ").capitalize()
		text = text.format({"buff:" + key: buff_name})
	
	while "{culmination:" in text:
		var key = text.split("culmination:")[1].split("}")[0]
		var culmination_name = key.replace("_", " ").capitalize()
		text = text.format({"culmination:" + key: culmination_name})
	
	return text

