class_name Cacodemon
extends "res://Scripts/classes/Purchasable.gd"



var level := Big.new(1)

var d := Num.new(0.1)
var misc_d := Num.new(1)
var inhand := Big.new(1)
var xp := Num.new(4)
var xp_gain := Num.new(1)
var color: Color

var consumed_spirits := Big.new(0)
var cs_peak: Big

var production := {
	"flesh": Big.new(0.7),
	"nearly dead": Big.new(0.7),
	"terror": Big.new(0.7),
	"corpse": Big.new(0.7),
}
var production_mod := Big.new(1)

var progress := Float.new(5)
var progress_gain := 1.0

var active := false
var host := false
var dead := false




func _init(_key: int) -> void:
	
	key = _key
	
	type = get_type() # color gets set here, too
	
	setup()
	
	name = get_name()


func setup():
	
	inhand = Big.new(d.t)
	
	match type:
		"Wendigo":
			production["flesh"].m(2)
		"Cacodemon":
			production["terror"].m(2)
		"Devil":
			production["corpse"].m(2)
		"Dybbuk":
			production["nearly dead"].m(2)
		"Barghest":
			for x in production:
				production[x] = Big.new(0.875)


func sync():
	
	d.sync()
	misc_d.sync()
	progress.sync()
	if progress.t > 43200:
		progress.t = 43200.0
	xp.sync()
	xp_gain.sync()
	
	production_mod = Big.new(level).m(level).d(5)
	if production_mod.less(1):
		production_mod = Big.new(1)

func start_task():
	
	inhand = Big.new(d.t)

func finish_task():
	
	xp()
	consumed_spirits.a(consumed_spirit_gain(inhand))
	
	for x in production:
		
		var roll = Big.new(production[x]).m(rand_range(0.5,1.5)).roundDown()
		if roll.less(1):
			continue
		
		gv.r[x].a(roll)
		gv.emit_signal("item_produced", x)

func killed():
	gv.emit_signal("amount_updated", "spirit")
	gv.emit_signal("cac_slain", key)
	active = false
	dead = true

func consumed_spirit_gain(base: Big = d.t) -> Big:
	
	var gain: Big = Big.new(base).d(10)
	
	gain.a(max(base.exponent + 1, 1))
	gain.d(10)
	
	return gain

func xp():
	
	xp.f.a(xp_gain.t)
	
	if xp.f.less(xp.t):
		return
	
	level_up()

func level_up():
	
	level.a(1)
	
	xp.f.s(xp.t)
	xp.m.m(1.25)
	
	d.m.m(2)
	var output_increase = rand_range(1.08, 1.12)
	d.m.m(output_increase)
	
	misc_d.m.m(1.1)
	
	progress.m *= 1.03
	
	sync()
	
	gv.emit_signal("cac_leveled_up", key)


func get_name() -> String:
	
	var name: String
	
	var roll := int(rand_range(0, 18))
	
	# first letter
	match roll:
		0: name = "A"
		1: name = "B"
		2: name = "C"
		3: name = "D"
		4: name = "H"
		5: name = "K"
		6: name = "L"
		7: name = "M"
		8: name = "N"
		9: name = "P"
		10: name = "R"
		11: name = "S"
		12: name = "T"
		13: name = "V"
		14: name = "W"
		15: name = "X"
		16: name = "Y"
		17: name = "Z"
	
	roll = int(rand_range(0, 20))
	
	match roll:
		0: name += "a"
		1: name += "e"
		2: name += "i"
		3: name += "o"
		4: name += "u"
		5: name += "y"
		6: name += "aa"
		7: name += "ci"
		8: name += "t"
		9: name += "ch"
		10: name += "m"
		11: name += "n"
		12: name += "io"
		13: name += "ui"
		14: name += "aa"
		15: name += "or"
		16: name += "x"
		17: name += "xx"
		18: name += "z"
		19: name += "zz"
	
	if name in ["Zz", "Zzz", "Cci", "Tt", "Cxx", "Aa", "Aaa"]:
		roll = int(rand_range(0, 10))
		var replace_Z: String
		match roll:
			0: replace_Z = "Ba"
			1: replace_Z = "Ab"
			2: replace_Z = "Ra"
			3: replace_Z = "Rab"
			4: replace_Z = "Ta"
			5: replace_Z = "Tor"
			6: replace_Z = "To"
			7: replace_Z = "Na"
			8: replace_Z = "No"
			9: replace_Z = "Non"
		name = name.replace(name[0], replace_Z)
	
	roll = int(rand_range(0, 20))
	
	match roll:
		0: name += "alozz"
		1: name += "amon"
		2: name += "ador"
		3: name += "ada"
		4: name += "adan"
		5: name += "akan"
		6: name += "off"
		7: name += "oth"
		8: name += "ath"
		9: name += "ith"
		10: name += "eth"
		11: name += "yth"
		12: name += "yst"
		13: name += "ysk"
		14: name += "ist"
		15: name += "isk"
		16: name += "ont"
		17: name += "ide"
		18: name += "ade"
		19: name += "att"
	
	if "aaa" in name:
		
		var triple := "a"
		
		var with: String
		
		roll = int(rand_range(0, 8))
		
		match roll:
			0: with = "t"
			1: with = "d"
			2: with = "b"
			3: with = "t"
			4: with = "q"
			5: with = "p"
			6: with = "r"
			7: with = "z"
		
		name = name.replace("aaa", triple + with + triple)
	
	return name

func get_type() -> String:
	
	var roll = int(rand_range(0, 4))
	
	if gv.cacodemons == 0:
		roll = key
	
	match roll:
		0:
			color = Color(0.7184, 0.857422, 0.395218)
			return "Wendigo"
		1:
			color = Color(0.717647, 0.941176, 0.92549)
			return "Barghest"
		2:
			color = Color(0.636784, 0.590706, 0.927734)
			return "Dybbuk"
		_:
			color = Color(1, 0.494118, 0)
			return "Cacodemon"


func selected_as_host():
	
	cs_peak = Big.new(consumed_spirits)
	host = true
