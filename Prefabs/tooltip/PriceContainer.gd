extends MarginContainer


onready var v = get_node("h/v")
onready var time = get_node("%time")

var forUpgrade := false
var key = 0

var cont := {}

func setupUpgrade(_key, cost: Dictionary):
	forUpgrade = true
	key = _key
	for x in cost:
		cont[x] = gv.SRC["price"].instance()
		cont[x].setup(cost[x].t, x)
		v.add_child(cont[x])
	time()

func setup(_key, cost: Dictionary):
	
	key = _key
	
	for x in cost:
		
		cont[x] = gv.SRC["price"].instance()
		
		cont[x].setup(cost[x], x)
		
		v.add_child(cont[x])
	
	time()

func time():
	
	var t = Timer.new()
	add_child(t)
	
	while not is_queued_for_deletion():
		
		var longest_time = Big.new(0)
		for x in cont:
			var bla = gv.seconds_until(x, cont[x].totalCost)
			if bla.greater(longest_time):
				longest_time = Big.new(bla)
		
		var time_text = gv.parse_time(longest_time)
		if time_text == "!":
			time.hide()
		else:
			time.show()
			time.text = time_text
		
		t.start(1)
		yield(t, "timeout")
	
	t.queue_free()


func flash():
	for ent in cont:
		cont[ent].flash()
