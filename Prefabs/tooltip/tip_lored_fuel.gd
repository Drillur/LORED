extends MarginContainer


onready var rt = get_node("/root/Root")

var lored_key: String

var fps := 0.0


func setup(key: String):
	
	lored_key = key
	
	static_vals()
	
	r_update()

func static_vals():
	
	var icon: Texture
	var title: String
	var color: Color
	
	if "bur " in gv.g[lored_key].type:
		icon = gv.sprite["coal"]
		title = "Coal Storage"
		color = rt.r_lored_color("coal")
	
	elif "ele " in gv.g[lored_key].type:
		icon = gv.sprite["jo"]
		title = "Battery"
		color = rt.r_lored_color("jo")
	
	
	$v/h/icon/Sprite.texture = icon
	$v/h/step/title.text = title
	
	$v/h/step/val.add_color_override("font_color", color)
	$v/drain/val.add_color_override("font_color", color)
	$v/ct.modulate = color
	get_parent().get_node("bg").self_modulate = color
	
	
	var total_fuel: Big = Big.new(gv.g[lored_key].f.t)
	if gv.g[lored_key].type[1] in gv.overcharge_list:
		total_fuel.m(gv.overcharge)
	var less = Big.new(gv.g[lored_key].fc.t).m(4)
	var drain = Big.new(gv.g[lored_key].fc.t).m(60).m(gv.g[lored_key].less_from_full(gv.g[lored_key].f.f, total_fuel))
	if gv.g[lored_key].f.f.isLessThan(Big.new(total_fuel).s(less)):
		drain.m(2)
	if drain.isLessThan(gv.g[lored_key].fc.t):
		drain = Big.new(gv.g[lored_key].fc.t)
	
	# change to string
	if gv.g[lored_key].f.f.isLessThan(Big.new(total_fuel).s(less)):
		drain = drain.toString() + "*"
	else:
		drain = drain.toString()
	
	$v/drain/val.text = drain



func _physics_process(delta: float) -> void:
	
	fps += delta
	if fps < rt.FPS:
		return
	fps -= rt.FPS
	
	r_update()


func r_update():
	
	var present_fuel: Big
	var total_fuel: Big
	
	present_fuel = Big.new(gv.g[lored_key].f.f)
	total_fuel = Big.new(gv.g[lored_key].f.t)
	if gv.g[lored_key].type[1] in gv.overcharge_list:
		total_fuel.m(gv.overcharge)
	
	$v/ct/c.rect_size.x = min(present_fuel.percent(total_fuel) * $v/ct.rect_size.x, $v/ct.rect_size.x)
	$v/h/step/val.text = present_fuel.toString() + " / " + total_fuel.toString()
