class_name LimitBreak
extends MarginContainer


onready var current_xp = get_node("%current xp")
onready var total_xp = get_node("%total xp")
onready var value = get_node("%value")
onready var current_progress = get_node("%current")
#onready var progress_edge = get_node("%edge")



func _ready():
	
	hide()
	
	gv.connect("limit_break_leveled_up", self, "levelUp")


func update():
	
	var t = Timer.new()
	add_child(t)
	
	while gv.active_scene == gv.Scene.ROOT:
		
		var percent = clamp(gv.lb_xp.f.percent(gv.lb_xp.t), 0, 1)
		
		current_progress.rect_size.x = min(percent * rect_size.x, rect_size.x)
		
		current_xp.text = gv.lb_xp.f.toString()
		total_xp.text = gv.lb_xp.t.toString()
		
		value.text = gv.up["Limit Break"].effects[0].effect.t.toString() + "x"
		
		
		
		t.start(gv.fps)
		yield(t, "timeout")
	
	t.queue_free()

func levelUp():
	
	var gay = gv.SRC["flash"].instance()
	add_child(gay)
	gay.flash(Color(1,1,1))
	
	setColors()



func setColors():
	
	var color = get_color_by_key(int(floor(gv.up["Limit Break"].effects[0].effect.t.toFloat())))
	
	current_progress.modulate = color
	value.self_modulate = color
	current_xp.self_modulate = color
	total_xp.self_modulate = get_color_by_key(int(floor(gv.up["Limit Break"].effects[0].effect.t.toFloat() + 1)))

static func get_color_by_key(key: int) -> Color:
	
	if key == -1:
		key += 15
	
	key = int(max(0, key))
	
	key = key % 15
	return gv.LIMIT_BREAK_COLORS[key]
