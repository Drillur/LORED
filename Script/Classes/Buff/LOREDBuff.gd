class_name LOREDBuff
extends Buff



enum Type {
	WITCH,
}


var type: Type
var key: String

var name: String

var lored: LORED



func _init(_type: Type, _lored: LORED.Type) -> void:
	type = _type
	key = Type.keys()[type]
	lored = lv.get_lored(_lored)
	
	ticked.connect(tick)
	ended.connect(erase_self)
	
	
	match type:
		Type.WITCH:
			name = "Aurus' Bounty"
			set_ticks(-1)
			set_tick_rate(5 / lored.haste.get_as_float())
			lored.haste.changed.connect(update_tick_rate)
	
	
	lored.buffs.append(self) # stored in memory so it doesnt get deleted
	
	super() # at bottom



# - Action


func erase_self() -> void:
	# wave goodbye!
	lored.buffs.erase(self)


func tick() -> void:
	match type:
		Type.WITCH:
			pass



# - WITCH

func update_tick_rate() -> void:
	tick_rate.set_to(5 / lored.haste.get_as_float())



# - Get
