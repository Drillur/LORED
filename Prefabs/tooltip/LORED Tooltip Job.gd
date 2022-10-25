extends MarginContainer

onready var info = get_node("%info")
onready var duration = get_node("%duration")
onready var requiredFuel = get_node("%requiredFuel")
onready var requiredFuelIcon = get_node("%requiredFuelIcon")



func setup(job: Job):
	
	yield(self,"ready")
	
	get_node("%dot").self_modulate = lv.lored[job.lored].color
	requiredFuelIcon.modulate = gv.COLORS[gv.shorthandByResource[lv.lored[job.lored].fuelResource]]
	
	match job.producedResources.size():
		2:
			get_node("%offline1").show()
		3:
			get_node("%offline2").show()
	
	if not job.producesResource:
		get_node("%offline").hide()
	
	loop(job)


func loop(job: Job):
	
	var t = Timer.new()
	add_child(t)
	
	while not is_queued_for_deletion():
		
		updateNodes(job)
		
		t.start(1)
		yield(t,"timeout")
	
	t.queue_free()

func updateNodes(job: Job):
	info.bbcode_text = job.jobText
	duration.text = job.durationText + " sec"
	var offlineGainText = job.gainText
	var i = 0
	for resource in offlineGainText:
		get_node("%offline" + str(i)).text = offlineGainText[resource]
		i += 1
	requiredFuel.text = job.requiredFuelText
