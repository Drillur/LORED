extends MarginContainer

onready var jobName = get_node("%jobName")
onready var duration = get_node("%duration")
onready var requiredFuel = get_node("%requiredFuel")
onready var requiredFuelIcon = get_node("%requiredFuelIcon")

#onready var entry = preload()

var loredColor: Color


func setup(job: Job):
	
	hideNodes()
	
	loredColor = lv.lored[job.lored].color
	
	yield(self,"ready")
	
	jobName.text = job.name
	
	jobEffects(job)
	
	if jobProducesResources(job):
		
		get_node("%output").show()
		
		
		for x in job.producedResourcesBits.size():
			setText(job, x, "output")
			get_node("%output" + str(x)).show()
	
	if jobRequiresResources(job):
		
		for x in job.requiredResourcesBits.size():
			setText(job, x, "input")
			get_node("%input" + str(x)).show()
	
	#if job.type != lv.Job.REFUEL:
	setFuelConsumptionText(job)
	
	get_node("%glow").self_modulate = loredColor
	get_node("%separator0").self_modulate = loredColor
	get_node("%separator1").self_modulate = loredColor
	loop(job)

func hideNodes():
	for x in 3:
		get_node("%output" + str(x)).hide()
		get_node("%input" + str(x)).hide()
	get_node("%effects").hide()

func jobProducesResources(job: Job) -> bool:
	return job.producedResourcesBits.size() > 0
func jobRequiresResources(job: Job) -> bool:
	return job.requiredResourcesBits.size() > 0

func setText(job: Job, index: int, inputOrOutput: String):
	
	var amount: Big
	var amountText: String
	var resource: int
	var resourceName: String
	var icon: Texture
	var rate: String
	var node: String = "%" + inputOrOutput + str(index)
	
	if inputOrOutput == "input":
		amount = Big.new(job.requiredResources.values()[index])
		resource = job.requiredResources.keys()[index]
		if job.type == lv.Job.REFUEL:
			amount.a(job.requiredFuel)
	else:
		amount = Big.new(job.producedResources.values()[index])
		resource = job.producedResources.keys()[index]
	
	resourceName = gv.resourceName[resource]
	icon = gv.sprite[gv.shorthandByResource[resource]]
	amountText = ("-" if inputOrOutput == "input" else "+") + amount.toString()
	rate = amount.d(job.duration).toString()
	
	get_node(node + "/amount").text = amountText
	get_node(node + "/icon/Sprite").texture = icon
	get_node(node + "/icon/Sprite/shadow").texture = get_node(node + "/icon/Sprite").texture
	get_node(node + "/resource").text = resourceName
	get_node(node + "/rate").text = "(" + rate + "/s)"

func setFuelConsumptionText(job: Job):
	
	var node: String = "%fuel"
	
	get_node(node + "/icon").modulate = gv.COLORS[gv.shorthandByResource[lv.lored[job.lored].fuelResource]]
	get_node(node + "/amount").text = "-" + job.getRequiredFuelText()
	get_node(node + "/percent").text = "(-" + fval.f(job.getRequiredFuel().percent(lv.lored[job.lored].fuelStorage) * 100) + "%)"
	
	get_node(node).show()

func jobEffects(job: Job):
	if job.type == lv.Job.REFUEL:
		get_node("%effectRefuel").show()
		get_node("%effectRefuel/icon").modulate = gv.COLORS[gv.shorthandByResource[lv.lored[job.lored].fuelResource]]
		get_node("%effectRefuel/amount").text = "+" + job.requiredResourcesText.values()[0]
	else:
		return
	
	get_node("%effects").show()


func loop(job: Job):
	
	var t = Timer.new()
	add_child(t)
	
	while not is_queued_for_deletion():
		
		updateNodes(job)
		
		t.start(1)
		yield(t,"timeout")
	
	t.queue_free()

func updateNodes(job: Job):
	#info.bbcode_text = job.jobText
	#requiredFuel.text = job.requiredFuelText
	duration.text = job.durationText + " sec"# (" + fval.f(job.durationBits.base) + " base)"
#	var offlineGainText = job.gainText
#	var i = 0
#	for resource in offlineGainText:
#		get_node("%offline" + str(i)).text = offlineGainText[resource]
#		i += 1

func glow():
	get_node("%glow").show()
func stopGlow():
	get_node("%glow").hide()
