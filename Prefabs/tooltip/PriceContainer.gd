extends MarginContainer


onready var v = get_node("h/v")
onready var time = get_node("%time")

var key: int

var cont := {}

func setup(_key: int, cost: Dictionary):
	
	key = _key
	
	var i := 0
	for x in cost:
		
		cont[x] = gv.SRC["price"].instance()
		
		cont[x].setup(cost[x], x)
		
		
		# alternate backgrounds
		#if i % 2 == 1:
		#	cont[x].get_node("bg").show()
		#	#cont[x].get_node("bg").self_modulate = gv.COLORS[x]
		
		v.add_child(cont[x])
		
		i += 1
	
	time()

func time():
	
	var t = Timer.new()
	add_child(t)
	
	while not is_queued_for_deletion():
		
		var longest_time = Big.new(0)
		for x in cont:
			var bla = time_remaining_in_seconds(x, cont[x].totalCost)
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


func time_remaining_in_seconds(resource: int, total_amount: Big):
	
	if lv.lored[key].asleep:
		return Big.new(0)
	
	var netArray = lv.net(resource)
	var net = netArray[0]
	var netSign = netArray[1]
	
	if netSign == -1 or netSign == 0:
		return Big.new(0)
	
	
	var delta: Big = Big.new(total_amount).s(gv.resource[resource])
	var incoming_amount := Big.new(0)
	
	if lv.lored[key].working:
		incoming_amount.a(lv.lored[key].output)
	
	return Big.new(delta).s(incoming_amount).d(net)


func flash():
	for ent in cont:
		cont[ent].flash()
