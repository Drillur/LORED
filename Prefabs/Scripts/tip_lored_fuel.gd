extends MarginContainer


onready var rt = get_node("/root/Root")

var lored_key: String

var fps := 0.0
var slow_fps := 0.0

func _ready():
	
	set_process(false)


func setup(key: String):
	
	lored_key = key
	
	static_vals()

func static_vals():
	
	var icon: Texture
	var title: String
	var color: Color
	
	if "bur " in gv.g[lored_key].type:
		icon = gv.sprite["coal"]
		title = "Coal Storage"
		color = gv.g["coal"].color
	
	elif "ele " in gv.g[lored_key].type:
		icon = gv.sprite["jo"]
		title = "Battery"
		color = gv.g["jo"].color
	
	
	$v/h/icon/Sprite.texture = icon
	$v/h/step/title.text = title
	
	$v/h/step/val.add_color_override("font_color", color)
	$v/drain/val.add_color_override("font_color", color)
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
		fps -= get_physics_process_delta_time()
		return
	fps += 0.01
	
	$v/ct/c.rect_size.x = min(gv.g[lored_key].f.f.percent(gv.g[lored_key].f.t) * $v/ct.rect_size.x, $v/ct.rect_size.x)
	$v/h/step/val.text = gv.g[lored_key].f.f.toString() + " / " + gv.g[lored_key].f.t.toString()

func r_slow():
	
	if slow_fps > 0:
		slow_fps -= get_physics_process_delta_time()
		return
	slow_fps += 0.15
	
	var less = Big.new(gv.g[lored_key].fc.t).m(4)
	var drain = Big.new(gv.g[lored_key].fc.t).m(60)
	if gv.g[lored_key].f.f.isLessThan(Big.new(gv.g[lored_key].f.t).s(less)):
		drain.m(2)
	if drain.isLessThan(gv.g[lored_key].fc.t):
		drain = Big.new(gv.g[lored_key].fc.t)
	
	# change to string
	if gv.g[lored_key].f.f.isLessThan(Big.new(gv.g[lored_key].f.t).s(less)):
		drain = drain.toString() + "*"
		get_node("v/less").show()
	else:
		drain = drain.toString()
		get_node("v/less").hide()
		set_process(true)
	
	$v/drain/val.text = drain
	
