extends VBoxContainer


onready var gn_count = get_node("m/v/h/count")

onready var rt = get_node("/root/Root")

var cont := {}

func _ready():
	
	gv.connect("new_unholy_body", self, "new_unholy_body")
	
	manage()

func new_unholy_body(amount: Big):
	
	var key = gv.ub_count
	gv.ub_count += 1
	
	gv.unholy_bodies[key] = Unholy_Body.new(key, amount)
	
	cont["ubmb"] = gv.SRC["unholy body manager bar"].instance()
	cont["ubmb"].init(gv.unholy_bodies[key])
	get_node("bars").add_child(cont["ubmb"])

func manage():
	
	while gv.r["unholy body"].greater_equal(1):
		
		var erase_queue := []
		for x in gv.unholy_bodies:
			
			# decrements each unholy body's own life variable and generates terror
			if not gv.unholy_bodies[x].is_dead():
				gv.unholy_bodies[x].eat()
				continue
			
			erase_queue.append(x)
			get_node("bars").get_child(0).queue_free()
		
		for x in erase_queue:
			gv.unholy_bodies.erase(x)
		
		ref()
		
		var t = Timer.new()
		add_child(t)
		t.start(gv.fps)
		yield(t, "timeout")
		t.queue_free()
	
	hide()
	
	var t = Timer.new()
	add_child(t)
	t.start(1)
	yield(t, "timeout")
	t.queue_free()
	
	manage()

func ref():
	
	if gv.r["unholy body"].equal(0):
		return
	
	show()
	
	gn_count.text = gv.r["unholy body"].toString()


func _on_mouse_entered() -> void:
	rt.get_node("global_tip")._call("unholy bodies tip")


func _on_mouse_exited() -> void:
	rt.get_node("global_tip")._call("no")
