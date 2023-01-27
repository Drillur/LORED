extends MarginContainer


onready var timer = get_node("Timer")
onready var dot = get_node("v/intent/v/dot")
onready var logic = get_node("v/logic")
onready var intent = get_node("v/intent/v/val")
onready var inactive = get_node("v/logic/inactive")
onready var level = get_node("v/logic/level")
onready var key = get_node("v/logic/key")
onready var upgrade = get_node("v/logic/upgrade")
onready var ingredient_net = get_node("v/logic/ingredient net")
onready var net = get_node("v/logic/net")
onready var ingredient_dot = get_node("v/logic/ingredient net/dot")
onready var net_dot = get_node("v/logic/net/dot")
onready var key_check = get_node("v/logic/key status/v/h/check")

var looping := false
var lored: LORED


func setup(_lored: int) -> void:
	
	lored = lv.lored[_lored]
	
	if lored.key_lored:
		get_node("v/logic/key status/v/default").text = "By default, I am a key LORED."
	else:
		get_node("v/logic/key status/v/default").text = "By default, I am not a key LORED."
	
	display()
	loop()

func display() -> void:
	
	hide_all()
	
	if not gv.option["tooltip_cost_only"] and not gv.option["tooltip_autobuyer"]:
		return
	else:
		logic.show()
	
	key_check.pressed = lored.key_lored
	
	if not lored.active:
		inactive.show()
		return
	
	if lored.stage == 1 and lored.level < 5 and gv.up["don't take candy from babies"].active():
		level.show()
	else:
		if lored.key_lored:
			key.show()
		else:
			if upgrade_check():
				upgrade.show()
	
	if lored.b.size() > 0:
		ingredient_net.show()
	
	if not inactive.visible and not level.visible and not key.visible and not upgrade.visible:
		net.show()
	
	_update()


func hide_all():
	
	logic.hide()
	inactive.hide()
	level.hide()
	key.hide()
	upgrade.hide()
	ingredient_net.hide()
	net.hide()
	
	$Timer2.start(0.05)
	yield($Timer2, "timeout")
	
	rect_size = Vector2.ZERO
	get_parent().get_parent().rect_size = Vector2.ZERO

func loop():
	
	if looping:
		return
	
	looping = true
	
	while true:
		
		timer.start(1)
		yield(timer, "timeout")
		
		_update()
		
		if level.visible:
			if lored.level >= 5:
				display()

func _update():
	
	var autobuy = lored.autobuy()
	
	dot.self_modulate = Color(0, 1, 0) if autobuy else Color(1, 0, 0)
	intent.text = "Upgrade ASAP" if autobuy else "Wait"
	
	if not gv.option["tooltip_autobuyer"]:
		return
	
	if ingredient_net.visible:
		ingredient_dot.self_modulate = Color(0, 1, 0) if ingredient_net() else Color(1, 0, 0)
	
	var _net = lored.net()
	
	if net.visible:
		net_dot.self_modulate = Color(1, 0, 0) if _net[0].greater_equal(_net[1]) else Color(0, 1, 0)

func ingredient_net() -> bool:
	
	for x in lored.b:
		
		if gv.g[x].hold:
			return false
		
		var consm = Big.new(lored.b[x].t).m(lored.d.t).d(lored.speed.t).d(lored.jobs[0].base_duration)
		# how much this lored consumes from the ingredient lored (x)
		
		if gv.g[x].halt:
			
			var consm2 = Big.new(consm).m(2)
			if consm2.less(gv.g[x].net(true)[0]):
				if not gv.g[x].cost_check():
					return false
		
		else:
			
			var _net = gv.g[x].net()
			
			if _net[0].less(_net[1]):
				return false
			
			_net = Big.new(_net[0]).s(_net[1])
			if consm.greater(_net):
				if not gv.g[x].cost_check():
					return false
	
	return true

func upgrade_check() -> bool:
	
	if not lored.key in ["malig", "coal","iron","cop","irono","copo"]:
		return false
	
	var x: String
	match lored.key:
		"malig", "cop", "iron":
			x = "THE WITCH OF LOREDELITH"
		"coal":
			x = "wait that's not fair"
		"irono":
			x = "I RUN"
		"copo":
			x = "THE THIRD"
	
	if gv.up[x].active():
		get_node("v/logic/upgrade/icon/Sprite").texture = gv.sprite[gv.up[x].icon]
		get_node("v/logic/upgrade/v/Label").bbcode_text = "[i]" + x + "[/i] is owned, so I want to upgrade!"
	else:
		return false
	
	return true

func _input(_event: InputEvent) -> void:
	
	if Input.is_key_pressed(KEY_K):
		define_key()

func define_key() -> void:
	
	if not gv.option["tooltip_autobuyer"]:
		return
	
	if lored.key_lored:
		lored.key_lored = false
	else:
		lored.key_lored = true
	
	display()
