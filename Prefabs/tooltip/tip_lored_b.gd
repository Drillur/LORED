extends MarginContainer

#onready var rt = get_node("/root/Root")



func setup_b(key: String, used_by_key: String, used_by_net: Big, color: Color):
	
	var actual = Big.new(gv.g[used_by_key].d.t).multiply(gv.g[used_by_key].b[key].t).toString()
	var per_sec = Big.new(used_by_net).multiply(gv.g[used_by_key].b[key].t).toString()
	
	$v/h/v/val.text = actual + " (" + per_sec + "/s)"
	
	setup(key, color)
	
	b_hold(key)
	baby(key)


func setup_used_by(key: String, b_key: String, b_net: Big, color: Color):
	
	var actual = Big.new(gv.g[b_key].d.t).multiply(gv.g[b_key].b[key].t).toString()
	var per_sec = Big.new(b_net).multiply(gv.g[b_key].b[key].t).toString()
	
	$v/h/v/val.text = actual + " (" + per_sec + "/s)"
	
	setup(b_key, color)
	
	halt(b_key)


func setup(key: String, color: Color):
	
	$v/h/icon/Sprite.texture = gv.sprite[key]
	$v/h/v/name.text = gv.g[key].name
	$v/h/v/val.add_color_override("font_color", color)


func halt(key):
	
	if not gv.g[key].halt:
		return
	
	$v/tags/halt.show()
	$v/tags.show()


func b_hold(key):
	
	if not gv.g[key].hold:
		return
	
	$v/tags/hold.show()
	$v/tags.show()


func baby(key):
	
	if not gv.g[key].is_baby(int(gv.g[key].type[1])):
		return
	
	$v/tags/baby.show()
	$v/tags.show()

