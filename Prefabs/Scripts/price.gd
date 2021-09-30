extends MarginContainer



var key: String
var _owner: String

var total: Big

onready var icon = get_node("m/h/icon/Sprite")
onready var resource = get_node("m/h/resource")
onready var lored_name = get_node("m/h/name")
onready var check = get_node("m/h/p/CheckBox")


func _ready() -> void:
	set_physics_process(false)

func setup(__owner: String, _key, _name = "", _color = ""):
	
	key = _key
	_owner = __owner
	
	yield(self, "ready")
	
	# text
	if true:
		
		if _name == "":
			_name = gv.g[key].name
		lored_name.text = _name
		
		if _owner in gv.g.keys():
			total = gv.g[_owner].cost[key].t
		elif _owner in gv.up.keys():
			total = gv.up[_owner].cost[key].t
		elif _owner == "cac":
			total = gv.cac_cost[key]
	
	# texture
	icon.texture = gv.sprite[key]
	
	# color
	if typeof(_color) == TYPE_STRING:
		_color = gv.g[key].color
	resource.self_modulate = _color
	
	updateLoop()

func updateLoop():
	
	while true:
		
		resource.text = gv.r[key].toString() + "/" + total.toString()
		check.pressed = gv.r[key].greater_equal(total)
		
		var t = Timer.new()
		add_child(t)
		t.start(gv.fps)
		yield(t, "timeout")
		t.queue_free()

var cont := {}
func flash():
	
	cont["flash"] = gv.SRC["flash"].instance()
	add_child(cont["flash"])
	cont["flash"].flash(Color(1,0,0))
