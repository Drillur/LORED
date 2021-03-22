class_name Spell
extends Reference



var key: int # id
var name: String

var has_target := false

var applies_buffs := []

var cost := {}


func _init(_key) -> void:
	
	key = int(_key)
	
	# be sure to leave mana in the final cost index, because it will just make
	# everything smoother. by checking for mana last, the witch will--if she
	# has insufficient mana to cast--collect the needed items before
	# proceeding to grind on other items while waiting for mana to regen
	
	match key:
		gv.SpellID.STIM:
			name = "Stim"
			cost[gv.Item.SHARDS] = Ob.Num.new(1)
			cost[gv.Item.MANA] = Ob.Num.new(2)
		gv.SpellID.HEX:
			name = "Hex"
			has_target = true
			applies_buffs.append(gv.Buff.HEX)
			cost[gv.Item.PARTS] = Ob.Num.new(3)
			cost[gv.Item.MANA] = Ob.Num.new(1)
