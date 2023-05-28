extends MarginContainer



var lored: int

var buff_ui: Dictionary



func setup(_lored: int):
	
	lored = _lored
	
	var lored_buffs = lv.lored[lored].active_buffs
	
	for buff in lored_buffs:
		buff_ui[buff] = gv.SRC["tooltip/buff tooltip"].instance()
		buff_ui[buff].setup(lored_buffs[buff])
		get_node("%buff ui").add_child(buff_ui[buff])
