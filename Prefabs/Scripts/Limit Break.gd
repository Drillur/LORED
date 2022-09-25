extends MarginContainer



const gnxpf := "v/xp/f"
const gnxpt := "v/xp/t"
const gnct := "v/ct xp"
const gncf := "v/ct xp/c"
const gnd := "v/h/d"


func _ready():
	
	hide()
	
	gv.connect("limit_break_leveled_up", self, "levelUp")


func update():
	
	var t = Timer.new()
	add_child(t)
	
	while gv.active_scene == gv.Scene.ROOT:
		
		var percent = clamp(gv.lb_xp.f.percent(gv.lb_xp.t), 0, 1)
		
		get_node(gncf).rect_size.x = min(percent * get_node(gnct).rect_size.x, get_node(gnct).rect_size.x)
		
		get_node(gnxpf).text = gv.lb_xp.f.toString()
		get_node(gnxpt).text = gv.lb_xp.t.toString()
		
		get_node(gnd).text = gv.up["Limit Break"].effects[0].effect.t.toString() + "x"
		
		
		
		t.start(gv.fps)
		yield(t, "timeout")
	
	t.queue_free()

func levelUp():
	
	var gay = gv.SRC["flash"].instance()
	add_child(gay)
	gay.flash(Color(1,1,1))
	
	setColors()



func setColors():
	
	var color = get_color_by_key(floor(gv.up["Limit Break"].effects[0].effect.t.toFloat()))
	
	get_node(gncf).modulate = color
	get_node(gnd).self_modulate = color
	get_node(gnxpf).self_modulate = color
	get_node(gnxpt).self_modulate = get_color_by_key(floor(gv.up["Limit Break"].effects[0].effect.t.toFloat() + 1))

func get_color_by_key(key: int) -> Color:
	
	if key == -1:
		key += 15
	
	key = max(0, key)
	
	key = key % 15
	return gv.LIMIT_BREAK_COLORS[key]
