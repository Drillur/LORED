extends MarginContainer



var key: String
var _owner: String

var fps = FPS.new(0.01, true)



const gn := {
	icon = "h/icon/Sprite",
	val = "h/v/val",
	time = "h/time",
	name = "h/v/type",
}


func _ready() -> void:
	get_node(gn.time).hide()

func setup(__owner: String, _key, _name = "", _color = ""):
	
	key = _key
	_owner = __owner
	
	# text
	if _name == "":
		_name = gv.g[key].name
	get_node(gn.name).text = _name
	
	# texture
	get_node(gn.icon).texture = gv.sprite[key]
	
	# color
	if typeof(_color) == TYPE_STRING:
		_color = gv.g[key].color
	get_node(gn.val).self_modulate = _color
	get_node(gn.time).self_modulate = _color
	
	if _owner != "cac":
		get_node(gn.time).show()


func _physics_process(delta: float) -> void:
	
	if not fps.process(delta):
		return
	
	
	
	var total: Big
	if _owner in gv.g.keys():
		total = gv.g[_owner].cost[key].t
	elif _owner in gv.up.keys():
		total = gv.up[_owner].cost[key].t
	elif _owner == "cac":
		total = gv.cac_cost[key]
	
	get_node(gn.val).text = gv.r[key].toString() + " / " + total.toString()
	
	# visibility
	if gv.r[key].isLargerThan(total):
		get_node(gn.time).hide()
		get_node("h/check").show()
	else:
		get_node("h/check").hide()
		if _owner == "cac":
			return
		get_node(gn.time).show()
		get_node(gn.time).text = gv.time_remaining(key, gv.r[key], total, false)
