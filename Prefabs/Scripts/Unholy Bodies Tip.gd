extends MarginContainer

onready var gn_val = get_node("v/gain/val")

func _ready():
	
	ref()

func ref():
	
	while true:
		
		var tps = Big.new(0)
		for x in gv.unholy_bodies:
			tps.a(gv.unholy_bodies[x].terror_generation)
		gn_val.text = tps.m(60).toString()
		
		var t = Timer.new()
		add_child(t)
		t.start(1)
		yield(t, "timeout")
		t.queue_free()
