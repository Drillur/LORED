class_name CavernEnums # aka Cav
extends Node




signal spell_target_confirmed(target, nearby_units) # -> SpellButton.gd



var unlocked_buffs := []
var unlocked_buff_effects := []


var spell := {}
var buff := {}

var warlock_unlocked := false

var cav: Node2D





class UnitResource:
	
	var print_mode := 0
	
	var current: Big setget setCurrent # current value
	
	var a := Big.new(0)
	var m := Big.new()
	
	var add_from_intellect := Big.new(0)
	
	var base: Big setget setBase # base
	var total: Big # total after upgrades/buffs
	
	var bar: Panel
	var bar_set := false
	var text: Label
	var text_set := false
	
	var has_regen := false
	var base_regen: Big
	var regen: Big
	var regen_rate := 0.1
	var regen_rest := 0 # time before regen kicks in
	var stop_regen := false
	
	func _init(_base = 1.0):
		
		base = Big.new(_base)
		
		sync()
		
		current = Big.new(total)
		restrictCurrent()
	
	func print() -> String:
		match print_mode:
			Cav.PrintMode.CURRENT:
				return current.toString()
			Cav.PrintMode.CURRENT_AND_TOTAL:
				return current.toString + "/" + total.toString()
			Cav.PrintMode.TOTAL:
				return total.toString()
			Cav.PrintMode.BASE_AND_TOTAL:
				return total.toString() + " (" + base.toString() + ")"
		
		return "oops"
	
	func setBase(new_val: Big):
		base = new_val
		sync()
	
	func setBaseRegen(x):
		base_regen = Big.new(x)
		setRegen(x)
		has_regen = true
	
	func setRegen(x):
		regen = Big.new(x)
	
	func stopRegen():
		stop_regen = true
	
	func setCurrent(new_val: Big):
		current = new_val
		restrictCurrent()
		update()
	
	func setBar(_bar: Panel):
		bar = _bar
		bar_set = true
	
	func setText(_text: Label):
		text = _text
		text_set = true
	
	func update():
		updateBar()
		updateText()
	
	func updateBar():
		if not bar_set:
			return
		bar.get_node("current").rect_size.x = min(current.percent(total) * bar.rect_size.x, bar.rect_size.x)
	
	func updateText():
		if not text_set:
			return
		text.text = self.print()
	
	func sync():
		
		# first, set total to base
		# then adjust total
		
		total = Big.new(base)
		
		total.a(a)
		total.a(add_from_intellect)
		
		total.m(m)
	
	func restrictCurrent():
		if current.less(0):
			current = Big.new(0)
		if current.greater(total):
			current = Big.new(total)
	
	func report():
		
		# prints every value;
		# useful in finding errors
		
		print_debug("--REPORT::")
		print_debug("current: ", current.toString())
		print_debug("a: ", a.toString())
		print_debug("m: ", m.toString())
		print_debug("base: ", base.toString())
		print_debug("total: ", total.toString())

class UnitAttribute:
	
	var print_mode: int = Cav.PrintMode.TOTAL
	
	var a := Big.new(0)
	var m := Big.new()
	
	var m_from_intellect := Big.new(1)
	
	var base: Big setget setBase # base
	var total: Big # total after upgrades/buffs
	
	func _init(_base = 1.0):
		base = Big.new(_base)
		sync()
	
	func print(mode = print_mode) -> String:
		match mode:
			Cav.PrintMode.TOTAL:
				return total.toString()
			Cav.PrintMode.BASE_AND_TOTAL:
				return total.toString() + " (" + base.toString() + ")"
		
		return "oops"
	
	func setBase(new_val: Big):
		base = new_val
		sync()
	
	func sync():
		
		# first, set total to base first
		total = Big.new(base)
		
		# then, begin modifying total
		total.a(a)
		
		total.m(m)
		
		total.m(m_from_intellect)
	
	func report():
		
		# prints every value;
		# useful in finding errors
		
		print_debug("--REPORT::")
		print_debug("a: ", a.toString())
		print_debug("m: ", m.toString())
		print_debug("base: ", base.toString())
		print_debug("total: ", total.toString())

class UnitResistances:
	
	var res := {
		Cav.DamageType.PHYSICAL: Cav.UnitAttribute.new(Cav.UnitResist.NONE),
		Cav.DamageType.FIRE: Cav.UnitAttribute.new(Cav.UnitResist.NONE),
		Cav.DamageType.FROST: Cav.UnitAttribute.new(Cav.UnitResist.NONE),
		Cav.DamageType.AIR: Cav.UnitAttribute.new(Cav.UnitResist.NONE),
		Cav.DamageType.EARTH: Cav.UnitAttribute.new(Cav.UnitResist.NONE),
		Cav.DamageType.BLEED: Cav.UnitAttribute.new(Cav.UnitResist.NONE),
	}
	
	func _init():
		for r in res:
			res[r].print_mode = Cav.PrintMode.TOTAL_AND_PERCENT
	
	func sync():
		for r in res:
			res[r].sync()
	
	func interpretIncomingDamage(val: Big, type: int) -> Big:
		val.m(res[type].total)
		return val
	
	func print() -> Dictionary:
		# returns an array dict
		var data := {}
		for x in res:
			data[x] = res[x].print()
		
		return data

class Cooldown:
	
	var available := true
	
	var base: float setget setBase
	
	var s: float
	var m_from_haste := 1.0
	
	var total: float
	
	func _init(_base: float):
		setBase(_base)
	
	func setBase(val: float):
		base = val
		sync()
	
	func sync():
		total = base
		total -= s
		total *= m_from_haste
	
	func isAvailable() -> bool:
		return available
	
	func setAvailable():
		available = true
	
	func spellCast():
		available = false

class Damage:
	
	var dmg: Array
	var type: Array
	
	var types: int
	
	func _init(_dmg_preset: int, _type: int) -> void:
		addDamage(_dmg_preset, _type)
	
	func addDamage(_dmg_preset: int, _type: int):
		
		setDmg(_dmg_preset)
		type.append(_type)
		
		setTypes()
	
	func setDmg(_dmg_preset):
		match _dmg_preset:
			Cav.DamagePreset.LIGHT:
				dmg.append(Big.new(1))
			Cav.DamagePreset.MEDIUM:
				dmg.append(Big.new(2))
			Cav.DamagePreset.HEAVY:
				dmg.append(Big.new(4))
			Cav.DamagePreset.MASSIVE:
				dmg.append(Big.new(8))
	
	func setTypes():
		types = dmg.size()
	
	func report() -> String:
		
		var text: String
		
		for x in types:
			text += dmg[x].toString() + " " + gv.damageTypeToStr(type[x])
		
		return text
	
	func sync():
		for d in dmg:
			d.sync()







const UnitResist = {
	NONE = 1,
	SLIGHT = .9,
	MODERATE = .75,
	HEAVY = .5,
	MAJOR = .25,
	TOTAL = 0,
}

enum AbilityAction {
	DEAL_DAMAGE,
	APPLY_BUFF,
	RESTORE_HEALTH,
	RESTORE_MANA,
	CONSIDER_SPECIAL_EFFECTS,
}

enum PrintMode {
	CURRENT,
	CURRENT_AND_TOTAL,
	TOTAL,
	BASE_AND_TOTAL,
	TOTAL_AND_PERCENT,
}

enum UnitClass {
	ARCANE_LORED,
	WARLOCK,
	CORE_CRYSTAL,
	WISP,
	KOBOLD,
	GOBLIN,
	ADDICT,
	FANATIC,
	DJINN,
	TROLL,
	GOLEM,
	WYRM,
}

enum Spell {
	ARCANE_FOCUS,
	CORE_RIFT,
	
	SCORCH,
	EXPLODE,
	BUCKLE,
	FANNED_FLAME,
#	CHILBLAINS,
#	SHATTER,
#	FREEZE,
#	MELT,
#	RUST,
#	ERODE,
#	COMBUSTION,
#	COLD_FATE,
#	SHOCKWAVE,
}

enum Buff {
	RIFT,
	
	SCORCHING,
	BURNING,
	CHILLED,
	BATTERED,
	OXIDIZED,
	BUCKLED,
	FANNED_FLAME,
}

enum DamagePreset {
	LIGHT,
	MEDIUM,
	HEAVY,
	MASSIVE,
}

enum DamageType {
	PHYSICAL,
	FIRE,
	FROST,
	AIR,
	EARTH,
	BLEED,
}

enum SpecialEffect { # see: # special effects
	BECOME_SPLASH,
	APPLY_BUFF,
}
enum SpecialEffectRequirement {
	STACK_LIMIT,
}



func reset(tier := 3):
	
	cav.reset(tier)
