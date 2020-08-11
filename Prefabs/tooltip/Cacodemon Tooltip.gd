extends MarginContainer

const gn_name := "v/title/h/v/name"
const gn_level := "v/title/h/v/level"
const gn_d := "v/consumed spirits/d"

var fps := {
	"level": FPS.new(1, true),
	"xp": FPS.new(0.1, true),
}

var key: int


func setup(_key: int):
	
	
	key = _key
	
	
	# ref
	get_node(gn_name).text = gv.cac[key].type + " " + gv.cac[key].name
	get_node(gn_name).self_modulate = gv.cac[key].color
	
	r_level()


func _physics_process(delta: float) -> void:
	
	for x in fps:
		
		if fps[x].f > 0:
			fps[x].f -= delta
		
		if not fps[x].set:
			continue
		
		fps[x].f = fps[x].t
		fps[x].set = fps[x].always_set
		
		match x:
			"level":
				r_level()
			"xp":
				r_xp()


func r_level():
	
	get_node(gn_level).text = "Level " + gv.cac[key].level.toString()
	get_node(gn_d).text = "+" + gv.cac[key].consumed_spirit_gain().toString()
	get_node("v/xp/text t").text = gv.cac[key].xp.t.toString()

func r_xp():
	
	get_node("v/xp/f").rect_size.x = gv.cac[key].xp.f.percent(gv.cac[key].xp.t) * get_node("v/xp").rect_size.x
	get_node("v/xp/text f").text = gv.cac[key].xp.f.toString()
