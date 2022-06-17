extends MarginContainer



onready var icon = get_node("v/header/v/h/icon/Sprite")
onready var lored_name = get_node("v/header/v/h/v/name")
onready var lored_level = get_node("v/header/v/h/v/level")
onready var tag_halt = get_node("v/header/v/h/tags/halt")
onready var tag_hold = get_node("v/header/v/h/tags/hold")
onready var gn_jobs = get_node("v/jobs")
onready var gross = get_node("v/stats/h/out/text")
onready var haste = get_node("v/stats/h/haste/text")
onready var crit = get_node("v/stats/h/crit/text")
onready var stats = get_node("v/stats")

var lored: LORED

var jobs: Array



func init(_lored_key: String):
	
	lored = gv.g[_lored_key]
	
	yield(self, "ready")
	
	icon.texture = gv.sprite[_lored_key]
	lored_name.text = lored.name
	if lored.halt:
		tag_halt.show()
	if lored.hold:
		tag_hold.show()
	
	lored_level.self_modulate = lored.color
	
	var i = 0
	for j in lored.jobs:
		jobs.append(gv.SRC["job label"].instance())
		jobs[i].init(j)
		gn_jobs.add_child(jobs[i])
		i += 1
	
	if lored.active:
		stats.show()
	else:
		stats.hide()
	
	# check for halt
	if lored.active:
		lored_level.show()
		i = 0
		for b in lored.b:
			if gv.g[b].hold:
				var bla = get_node("v/warning/v/halt" + str(i))
				bla.get_node("icon/Sprite").texture = gv.sprite[b]
				bla.get_node("name").text = gv.g[b].name
				bla.get_node("name").self_modulate = gv.g[b].color
				bla.get_node("reason").text = " is holding its resources."
				bla.show()
				get_node("v/warning").show()
			if gv.g[b].is_baby(int(lored.stage)):
				var bla = get_node("v/warning/v/baby" + str(i))
				bla.get_node("icon/Sprite").texture = gv.sprite[b]
				bla.get_node("name").text = gv.g[b].name
				bla.get_node("name").self_modulate = gv.g[b].color
				bla.get_node("reason").text = " is below level 5; cannot use."
				bla.show()
				get_node("v/warning").show()
			i += 1
	
	rect_size.y = 0
	
	update()


func update():
	
	while true:
		
		lored_level.text = "Level " + str(lored.level)
		
		if stats.visible:
			gross.text = lored.net(true, true)[0].toString() + "/s"
			haste.text = fval.f(lored.speed.b / lored.speed.t * 100) + "%"
			crit.text = lored.crit.t.toString() + "%"
		
		
		$Timer.start(1)
		yield($Timer, "timeout")
