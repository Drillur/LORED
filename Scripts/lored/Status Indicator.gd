extends Panel

enum status {HIDE, FINE, BAD, GOOD, HALT}
var status_colors := [Color(0,0,0,0.0), Color(1,1,0,1), Color(1,0,0, 1), Color(0.0, 0.0, 0.0, 0.0)]

var key: String



func _ready() -> void:
	self_modulate = status_colors[status.HIDE]


func init(_key: String, halt_color: Color) -> void:
	
	if _key == "":
		return
	key = _key
	status_colors.append(Color(halt_color))



func _update(net):
	
	self_modulate = get_status_color(net)

func get_status_color(net: Array) -> Color:
	
	# inactive
	if not gv.g[key].active:
		return status_colors[status.HIDE]
	
	if gv.g[key].halt:
		return status_colors[status.HALT]
	
	# bad
	if true:
		
		if net[1].greater(Big.new(net[0]).m(2)):
			return status_colors[status.BAD]
		
		if net[1].greater(net[0]):
			if gv.r[key].less_equal(Big.new(gv.g[key].d.t).m(100)) and Big.new(net[1]).s(net[0]).less(Big.new(gv.g[key].d.t).m(0.01)):
				return status_colors[status.BAD]
	
	# possibly fine
	if true:
		
		if net[1].greater(net[0]):
			return status_colors[status.FINE]
		
		if gv.r[key].less_equal(Big.new(gv.g[key].d.t).m(2)) and Big.new(net[0]).s(net[1]).less(Big.new(gv.g[key].d.t).m(0.01)):
			return status_colors[status.FINE]
	
	# good
	return status_colors[status.GOOD]
