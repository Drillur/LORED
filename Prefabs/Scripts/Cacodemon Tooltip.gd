extends MarginContainer


var fps := {
	"level": FPS.new(1, true),
	"xp": FPS.new(0.1, true),
}

var gn := {
	bonus = 0,
	name = 0,
	level = 0,
	d = 0,
}

var key: int


func set_nodes():
	gn.bonus = get_node("v/bonus/text")
	gn.name = get_node("v/title/h/v/name")
	gn.level = get_node("v/title/h/v/level")
	gn.d = get_node("v/h/consumed spirits/d")

func setup(_key: int):
	
	set_nodes()
	
	key = _key
	
	# ref
	gn.bonus.text = bonus()
	
	gn.name.text = gv.cac[key].type + " " + gv.cac[key].name
	gn.name.self_modulate = gv.cac[key].color
	

func _process(_delta: float) -> void:
	
	level()
	xp()
	
	set_process(false)

func _physics_process(delta: float) -> void:
	
	for x in fps:
		if fps[x].process(delta):
			call(x)


func level():
	
	gn.level.text = "Level " + gv.cac[key].level.toString()
	gn.d.text = "+" + gv.cac[key].consumed_spirit_gain().toString()
	get_node("v/xp/text t").text = gv.cac[key].xp.t.toString()

func xp():
	
	get_node("v/xp/f").rect_size.x = gv.cac[key].xp.f.percent(gv.cac[key].xp.t) * get_node("v/xp").rect_size.x
	get_node("v/xp/text f").text = gv.cac[key].xp.f.toString() + " xp"

func bonus() -> String:
	match gv.cac[key].type:
		"Barghest":
			return "An eclectic horror."
		"Cacodemon":
			return "Specializes in terror."
		"Wendigo":
			return "Amasses flesh."
		"Devil":
			return "Corpses in His wake."
		"Dybbuk":
			return "Nearly-dead tell tales."
	return ""
