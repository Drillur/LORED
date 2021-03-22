extends MarginContainer


onready var rt = get_node("/root/Root")

var lored_key: String

var fps := 0.0
var slow_fps := 0.0

var gn_drain = 0

func _ready():
	
	set_process(false)


func setup(key: String):
	
	lored_key = key
	
	gn_drain = get_node("v/drain/val")
	
	static_vals()

func static_vals():
	
	var icon: Texture
	var title: String
	var color: Color
	var fuel_source = gv.g[lored_key].fuel_source
	
	icon = gv.sprite[fuel_source]
	color = gv.COLORS[fuel_source]
	
	match fuel_source:
		"coal":
			title = "Coal Storage"
		"jo":
			title = "Battery"
		"water":
			title = "Thirst"
		"blood":
			title = "Blood"
			get_node("v/drain/desc").text = "Gain per second"
		"mana":
			title = "Mana"
			get_node("v/drain/desc").text = "Gain per second"
	
	
	$v/h/icon/Sprite.texture = icon
	$v/h/step/title.text = title
	
	$v/h/step/val.add_color_override("font_color", color)
	gn_drain.add_color_override("font_color", color)
	$v/ct.modulate = color
	get_parent().get_node("bg").self_modulate = color
	
	r_slow()
	
	r_update()


func _process(delta: float) -> void:
	rect_size.y = 0
	set_process(false)

func _physics_process(delta: float) -> void:
	
	r_update()
	r_slow()


func r_update():
	
	if fps > 0:
		fps -= gv.fps
		return
	fps += 0.01
	
	$v/ct/c.rect_size.x = min(gv.g[lored_key].f.f.percent(gv.g[lored_key].f.t) * $v/ct.rect_size.x, $v/ct.rect_size.x)
	$v/h/step/val.text = gv.g[lored_key].f.f.toString() + " / " + gv.g[lored_key].f.t.toString()

func r_slow():
	
	if slow_fps > 0:
		slow_fps -= gv.fps
		return
	slow_fps += 0.15
	
	var drain = Big.new(gv.g[lored_key].fc.t)
	if gv.g[lored_key].f.f.less(gv.g[lored_key].f.t) and not gv.g[lored_key].smart:
		drain.m(2)
	if drain.less(gv.g[lored_key].fc.t):
		drain = Big.new(gv.g[lored_key].fc.t)
	
	# change to string
	if gv.g[lored_key].f.f.less(gv.g[lored_key].f.t) and not gv.g[lored_key].smart:
		drain = drain.toString() + "*"
		get_node("v/less").show()
	else:
		drain = drain.toString()
		get_node("v/less").hide()
		set_process(true)
	
	gn_drain.text = drain
	
