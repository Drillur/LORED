extends MarginContainer


onready var v = get_node("v")
onready var time = get_node("p/h/time")

var cont := {}

func setup(key: String, cost: Dictionary):
	
	var i := 0
	for x in cost:
		
		cont[x] = gv.SRC["price"].instance()
		
		var _name = ""
		var _color = ""
		if key == "cac":
			_name = x.capitalize()
			_color = Color(1,0,0)
		cont[x].setup(key, x, _name, _color)
		
		
		# alternate backgrounds
		if i % 2 == 1:
			cont[x].get_node("bg").show()
			#cont[x].get_node("bg").self_modulate = gv.COLORS[x]
		
		v.add_child(cont[x])
		
		i += 1
	
	time()

func time():
	
	while true:
		
		var longest_time = Big.new(0)
		for x in cont:
			var bla = gv.time_remaining_in_seconds(cont[x].key, gv.r[cont[x].key], cont[x].total)
			if bla.greater(longest_time):
				longest_time = Big.new(bla)
		
		var time_text = gv.parse_time(longest_time)
		if time_text == "!":
			time.hide()
		else:
			time.show()
			time.text = time_text
		
		var t = Timer.new()
		add_child(t)
		t.start(1)
		yield(t, "timeout")
		t.queue_free()
