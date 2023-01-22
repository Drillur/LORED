class_name LOREDManager
extends Node2D

onready var rt = get_node("/root/Root")


var lored: LORED
var vico: MarginContainer



var type: int



func save() -> String:
	return lored.save()
func load(data: Dictionary):
	lored.load(data)


func _init(_type: int):
	
	type = _type
	
	lored = LORED.new(type)
	lored.assignManager(self)
	
	name = lored.name






func assignVico(_vico: MarginContainer):
	vico = _vico
	setupVico()
	setupSignals()
	setupElements()
	watchCost()
	

func setupVico():
	vico.setup(type)
	vico.assignManager(self)

func setupSignals():
	gv.connect("fuelResourceEmpty", self, "fuelResourceEmpty")
	gv.connect("throwFuel", self, "catchFuel")
	gv.connect("exportChanged", self, "exportChanged")

func setupElements():
	
	jobTimer = Timer.new()
	jobTimer.one_shot = true
	add_child(jobTimer)



func justAppearedForTheFirstTime():
	syncAllNow()
	lored.syncJobs_all()
	updatePrimaryResource(getPrimaryResource())
	enterStandby()

func updatePrimaryResource(resource: int):
	
	if resource == -1:
		return
	
	vico.primaryResource = resource
	vico.setIcon(gv.sprite[gv.shorthandByResource[resource]])
	vico.resourceTextColor = gv.COLORS[gv.shorthandByResource[resource]]





func syncAllNow():
	lored.syncAll()
	syncQueue()
func syncQueue():
	
	if lored.queue.size() == 0:
		return
	
	for q in lored.queue:
		match q:
			lv.Queue.OUTPUT:
				lored.syncOutput()
			lv.Queue.INPUT:
				lored.syncInput()
			lv.Queue.COST:
				lored.syncCost()
			lv.Queue.FUEL_STORAGE:
				lored.syncFuelStorage()
			lv.Queue.FUEL_COST:
				lored.syncFuelCost()
			lv.Queue.CRIT:
				lored.syncCrit()
			lv.Queue.HASTE:
				lored.syncHaste()
	
	var minimum = Big.new(lored.fuelCost).m(lored.refuelJob.duration * 2)
	if lored.currentFuel.less(minimum):
		lored.currentFuel = Big.new(minimum)
		if lored.type == lv.Type.COAL:
			if gv.resource[gv.Resource.COAL].less(minimum):
				gv.addToResource(gv.Resource.COAL, minimum)
	
	var newQueue := []
	
	if lored.queue.has(lv.Queue.FUEL_STORAGE):
		lored.setQuarterTank(Big.new(getFuelStorage()).d(4))
	
	if lored.queue.has(lv.Queue.FUEL_COST):
		updateFuelDrain()
		updateRequiredFuelForAllJobs()
	
	if lored.queue.has(lv.Queue.HASTE) or lored.queue.has(lv.Queue.OUTPUT) or lored.queue.has(lv.Queue.INPUT):
		newQueue.append(lv.Queue.UPDATE_PRODUCTION)
	
	lored.queue.clear()
	
	for item in newQueue:
		lored.queue(item)
	
	rt.get_node("global_tip").refresh()



# - - - Getters
# These variables are never assigned a value.
# Instead, they only pull from the LORED class. See: the "lored" var

var level: int setget , getLevel
var levelText: String setget , getLevelText
func getLevel() -> int:
	return lored.level
func getLevelText() -> String:
	return str(getLevel())
var smart: bool setget , getSmart
func getSmart() -> bool:
	return lored.smart
var asleep: bool setget , getAsleep
func getAsleep() -> bool:
	return lored.asleep
var working: bool setget , getWorking
func getWorking() -> bool:
	return lored.working
var unlocked: bool setget , getUnlocked
func getUnlocked() -> bool:
	return lored.unlocked
var purchased: bool setget , getPurchased
func getPurchased() -> bool:
	return lored.purchased

var tab: int setget , getTab
func getTab() -> int:
	return lored.tab
var stage: int setget , getStage
func getStage() -> int:
	return lored.stage

var usedBy: Array setget , getUsedBy
func getUsedBy() -> Array:
	return lored.usedBy


var output: Big setget , getOutput
var outputText: String setget , getOutputText
func getOutput() -> Big:
	return lored.output
func getOutputText() -> String:
	return lored.outputText

var input: Big setget , getInput
var inputText: String setget , getInputText
func getInput() -> Big:
	return lored.input
func getInputText() -> String:
	return lored.inputText


var cost: Dictionary setget , getCost
var costText: Dictionary setget , getCostText
var baseCost: Dictionary setget , getBaseCost
var costModifier: float setget , getCostModifier
var costModifierText: String setget , getCostModifierText
func getCost() -> Dictionary:
	return lored.cost
func getCostText() -> Dictionary:
	return lored.costText
func getBaseCost() -> Dictionary:
	return lored.baseCost
func getCostModifier() -> float:
	return lored.costModifier
func getCostModifierText() -> String:
	return fval.f(getCostModifier())

var hasteBaseRatio: float setget , getHasteBaseRatio
func getHasteBaseRatio() -> float:
	return lored.haste / lored.baseHaste


var fuelCost: Big setget , getFuelCost
var fuelCostText: String setget , getFuelCostText
var fuelResource: int setget , getFuelResource
var fuelResourceText: String setget , getFuelResourceText
func getFuelCost() -> Big:
	return lored.fuelCost
func getFuelCostText() -> String:
	return lored.fuelCostText
func getFuelResource() -> int:
	return lored.fuelResource
func getFuelResourceText() -> String:
	return gv.resourceName[getFuelResource()]


var fuelStorage: Big setget , getFuelStorage
var fuelStorageText: String setget , getFuelStorageText
var currentFuel: Big setget setCurrentFuel, getCurrentFuel
var currentFuelText: String setget , getCurrentFuelText
var currentFuelPercent: float setget , getCurrentFuelPercent
func getFuelStorage() -> Big:
	return lored.fuelStorage
func getFuelStorageText() -> String:
	return lored.fuelStorageText
func setCurrentFuel(val: Big):
	lored.currentFuel = val
func getCurrentFuel() -> Big:
	return lored.currentFuel
func getCurrentFuelText() -> String:
	return lored.currentFuelText
func getCurrentFuelPercent() -> float:
	return lored.currentFuelPercent
func fullFuel() -> bool:
	return lored.currentFuel.greater_equal(lored.fuelStorage)

var quarterTank: Big setget , getQuarterTank
var quarterTankText: String setget , getQuarterTankText
func getQuarterTank() -> Big:
	return lored.quarterTank
func getQuarterTankText() -> String:
	return lored.quarterTankText


var crit: float setget , getCrit
var critText: String setget , getCritText
var critRoll := false setget , getCritRoll
var critCritRoll := false setget , getCritCritRoll
func getCrit() -> float:
	return lored.crit
func getCritText() -> String:
	return lored.critText
func getCritRoll() -> bool:
	if getCrit() == 0:
		return false
	critRoll = rand_range(0, 100) < getCrit()
	return critRoll
func getCritCritRoll() -> bool:
	if stage != 1:
		return false
	if critRoll == false:
		return false
	if not gv.up["the athore coments al totol lies!"].active():
		return false
	critCritRoll = rand_range(0, 100) < 1
	return critCritRoll
func resetCritRolls():
	critRoll = false
	critCritRoll = false


var haste: float setget , getHaste
var hasteText: String setget , getHasteText
func getHaste() -> float:
	return lored.haste
func getHasteText() -> String:
	return lored.hasteText


var color: Color setget , getColor
func getColor() -> Color:
	return lored.color


var icon: Texture setget , getIcon
func getIcon() -> Texture:
	return lored.icon


var shorthandKey: String setget , getShorthandKey
func getShorthandKey():
	return lored.shorthandKey

func getRequiredResource(job: int, resource: int) -> Big:
	return lored.jobs[job].getRequiredResource(resource)
func pronoun(word: String):

	if word in ["he", "she"]:
		return lored.pronoun[0]
	elif word in ["him", "her"]:
		return lored.pronoun[1]
	elif word in ["his", "hers"]:
		return lored.pronoun[2]
	return "i suck"

func getPrimaryResource() -> int:
	return lored.jobs.values()[0].primaryResource

var totalJobTime: float setget , getTotalJobTime
func getTotalJobTime() -> float:
	return lored.totalJobTime

var usedResources: Array setget , getUsedResources
func getUsedResources() -> Array:
	return lored.usedResources

var queue: Array setget , getQueue
func getQueue() -> Array:
	return lored.queue



# - - - Duplicate functions

func editValue(attribute: int, typeOfEdit: int, item: int, amount, index = 0):
	lored.editValue(attribute, typeOfEdit, item, amount, index)

func syncCostModifier():
	lored.syncCostModifier()

func getJobDuration(index: int) -> float:
	return lored.getJobDuration(index)

func setHasteValue(folder: int, item: int, amount):
	lored.setHasteValue(folder, item, amount)
func setOutputValue(folder: int, item: int, amount):
	lored.setOutputValue(folder, item, amount)

func updateOfflineNet(resource: int):
	lored.updateOfflineNet(resource)

func getOfflineEarnings(timeOffline: int):
	lored.getOfflineEarnings(timeOffline)



# - - - Actions

func unlock():
	lored.unlocked = true
	vico.show()
func unlockJobResources():
	# called on load in Root
	for job in lored.jobs.values():
		job.unlockResources()

func sleepUnlocked():
	vico.sleepUnlocked()
func jobsUnlocked():
	vico.jobsUnlocked()

func purchase():
	if canAffordPurchase():
		purchased()
		rt.get_node("global_tip").refresh()
	else:
		if is_instance_valid(rt.get_node("global_tip").tip):
			rt.get_node("global_tip").tip.price_flash()
func forcePurchase():
	lored.purchased()
	syncQueue()

func purchased():
	lored.prePurchase()
	lored.purchased()
	updateVicoCheck()
	vico.levelUpFlash()
	vico.levelUpText()



func asleepClicked(manual := false):
	if getAsleep():
		wakeUp()
	else:
		putToSleep()
		watchSleepTime()
	if manual:
		rt.get_node("global_tip").refresh("lored asleep")
func putToSleep():
	lored.asleep = true
func wakeUp():
	lored.asleep = false


func flashSleep():
	vico.flashSleep()

func reset():
	stopWorking()
	enterStandby()
	lored.reset()
	syncAllNow()
	cleanUp()
	lored.currentFuel = Big.new(lored.fuelStorage)



# - - - Watchers

func watchCost():
	
	var t = Timer.new()
	add_child(t)
	
	while not is_queued_for_deletion():
		
		updateVicoCheck()
		
		t.start(0.25 if mode == lv.Mode.ACTIVE else 1)
		yield(t, "timeout")
	
	t.queue_free()

func updateVicoCheck():
	if canAffordPurchase():
		vico.showCheck()
	else:
		vico.hideCheck()

func watchCurrentFuel():
	
	var t = Timer.new()
	add_child(t)
	
	while not is_queued_for_deletion():
		
		if mode != lv.Mode.ACTIVE:
			break
		
		if getCurrentFuelPercent() < 0.25:
			newAlert(lv.AlertType.LOW_FUEL)
		
		t.start(1)
		yield(t, "timeout")
	
	t.queue_free()

var watchingSleepTime := false
func watchSleepTime():
	
	if lv.AlertType.ASLEEP in alerts:
		return
	
	if watchingSleepTime:
		return
	
	if not getAsleep():
		return
	
	watchingSleepTime = true
	var sleepTime := 0
	
	var t = Timer.new()
	add_child(t)
	
	while not is_queued_for_deletion():
		
		t.start(1)
		yield(t,"timeout")
		
		if not getAsleep():
			break
		
		sleepTime += 1
		
		if sleepTime >= 30:
			newAlert(lv.AlertType.ASLEEP)
			break
	
	watchingSleepTime = false
	t.queue_free()




# - - - Checkers

func canAffordPurchase() -> bool:
	
	var cost = getCost()
	for c in cost:
		if gv.resource[c].less(cost[c]):
			return false
	
	return true

func exportChanged(resource: int):
	if not resource in lored.usedResources:
		return
	if resource in gv.resourcesNotBeingExported:
		newAlert(lv.AlertType.REQUIRED_RESOURCE_NOT_EXPORTING)



# - - - Alerts

var alerts := []
var activeAlert := -1

func newAlert(type: int):
	
	if type in alerts:
		return
	
	alerts.append(type)
	
	if alerts.size() == 1:
		vico.showAlert()
	
	alerts.sort()
	
	if type < activeAlert:
		stopAlertProcess(activeAlert)
	
	startAlertProcess(type)

func stopAlert(type: int):
	
	if not type in alerts:
		return
	
	alerts.erase(type)
	
	if type == activeAlert:
		resumeUnfinishedAlert()

func resumeUnfinishedAlert():
	for alert in alerts:
		startAlertProcess(alert)
		return
	allAlertsGone()

func allAlertsGone():
	activeAlert = -1
	vico.hideAlert()

func startAlertProcess(type: int):
	activeAlert = type
	match type:
		lv.AlertType.ASLEEP:
			alert_asleep()
		lv.AlertType.LOW_FUEL:
			alert_lowFuel()
func stopAlertProcess(type: int):
	match type:
		lv.AlertType.LOW_FUEL:
			alert_lowFuel_stop()

func alert_lowFuel():
	
	vico.alert_lowFuel()
	
	var t = Timer.new()
	add_child(t)
	
	while not is_queued_for_deletion():
		
		if getCurrentFuelPercent() > 0.3:
			stopAlert(lv.AlertType.LOW_FUEL)
			alert_lowFuel_stop()
			break
		
		t.start(1)
		yield(t, "timeout")
	
	t.queue_free()
func alert_lowFuel_stop():
	vico.alert_lowFuel_stop()

func alert_asleep():
	
	vico.alert_asleep()
	
	var t = Timer.new()
	add_child(t)
	
	while not is_queued_for_deletion():
		
		if not getAsleep():
			stopAlert(lv.AlertType.ASLEEP)
			alert_asleep_stop()
			break
		
		t.start(1)
		yield(t, "timeout")
	
	t.queue_free()
func alert_asleep_stop():
	vico.alert_asleep_stop()



# - - - Modes

var mode: int = lv.Mode.HIDDEN

func enterStandby():
	# enters stand-by mode. updates resource count, that's pmuch it
	# called by Vico when it becomes visible.
	mode = lv.Mode.STANDBY
	vico.enterStandby()
	updateFuelDrain(false)
	gv.append(gv.list.lored["unlocked and inactive"], type)

func enterActive():
	gv.list.lored["unlocked and inactive"].erase(type)
	mode = lv.Mode.ACTIVE
	vico.enterActive()
	watchCurrentFuel()
	updateFuelDrain(true)
	findFirstJob()











# - - - Jobs and work

var jobTimer: Timer
var stopWorking := false
func stopWorking():
	stopWorking = true
	jobTimer.start(0.01)
	lored.working = false

func findFirstJob():
	
	if stopWorking:
		stopWorking = false
	
	lookForWork()
	
	var t = Timer.new()
	add_child(t)
	t.start(1)
	yield(t, "timeout")
	
	if not getWorking():
		repeatedlyLookForWork()

func repeatedlyLookForWork():
	while getWorking() == false:
		jobTimer.start(1)
		yield(jobTimer, "timeout")
		
		if getAsleep():
			cleanUpIfAsleep()
			continue
		if canAndShouldRefuel():
			workJob(nextJob)
		else:
			lookForWork()

func lookForWork():
	# mama kicked me outta da house
	for job in lored.jobs.values():
		if canStartJob(job):
			workJob(job)

var reasonWhyCannotStartJob: int
func canStartJob(job: Job) -> bool:
	
	if getCurrentFuelPercent() <= 0.25:
		if type != lv.Type.COAL:
			if job.type != lv.Job.REFUEL:
				reasonWhyCannotStartJob = lv.ReasonCannotBeginJob.LOW_FUEL
				return false
	
	if job.type == lv.Job.REFUEL:
		if getFuelResource() == gv.Resource.COAL:
			if lv.lored[lv.Type.COAL].purchased:
				if lv.lored[lv.Type.COAL].getCurrentFuelPercent() <= 0.5:
					if type != lv.Type.COAL:
						var coloredResourceName = "[color=#" + gv.COLORS[gv.shorthandByResource[getFuelResource()]].to_html() + "]" + gv.resourceName[getFuelResource()] + "[/color]"
						updateStatus("Letting " + coloredResourceName + "\ncatch up.")
						return false
		var requiredFuel = lored.refuelJob.requiredResourcesBits[getFuelResource()].total
		if gv.resource[getFuelResource()].less(getQuarterTank()):
			reasonWhyCannotStartJob = lv.ReasonCannotBeginJob.INSUFFICIENT_FUEL_RESOURCE
			var coloredResourceName = "[color=#" + gv.COLORS[gv.shorthandByResource[getFuelResource()]].to_html() + "]" + gv.resourceName[getFuelResource()] + "[/color]"
			updateStatus("Awaiting " + requiredFuel.toString() + " available " + coloredResourceName + ".")
			updatePrimaryResource(getFuelResource())
			vico.hideProduction()
			return false
	
	if lored.currentFuel.less(job.requiredFuel):
		reasonWhyCannotStartJob = lv.ReasonCannotBeginJob.LOW_FUEL
		return false
	
	if not job.haveAndCanUseRequiredResources():
		# reasonWhyCannotStartJob is set in job.haveAndCanUseRequiredResources()
		if reasonWhyCannotStartJob == lv.ReasonCannotBeginJob.LORED_NOT_EXPORTING:
			updateStatus("Required resource(s) are not being exported.")
		return false
	reasonWhyCannotStartJob = -1
	lored.working = true
	return true

func workJob(job: Job):
	
	highlightJobInTooltip(job)
	
	lored.jobStarted(job)
	
	if job.requiresResource:
		takeRequiredResources(job.requiredResources)
	takeRequiredFuelFromStorage(job.requiredFuel)
	
	var currentTime = OS.get_ticks_msec()
	vico.jobStarted(job.duration, currentTime)
	
	updatePrimaryResource(job.primaryResource)
	if job.type == lv.Job.REFUEL:
		vico.hideProduction()
	else:
		vico.updateProduction()
	updateStatus(job.vicoText)
	
	
	
	jobTimer.start(job.duration)
	yield(jobTimer, "timeout")
	
	stopHighlightJobInTooltip(job)
	
	if stopWorking:
		if lored.lastJob != lv.Job.REFUEL:
			lored.updateGain_zero(lored.jobs[lored.lastJob])
			lored.updateDrain_zero(lored.jobs[lored.lastJob])
		stopWorking = false
		return
	
	
	
	if job.producesResource:
		var critMultiplier = rollForCrit()
		var producedResources = getProducedResourcesDictionary(job, critMultiplier)
		giveProducedResources(producedResources)
		
		if gv.option["loredOutputNumbers"]:
			if not gv.option["loredCritsOnly"] or (gv.option["loredCritsOnly"] and critRoll):
				var outputTextDetails = getOutputTextDetails(producedResources, critMultiplier)
				vico.throwOutputTexts(outputTextDetails)
		
		resetCritRolls()
	
	if job.type == lv.Job.REFUEL:
		lored.currentFuel.a(getQuarterTank())
	
	syncQueue()
	
	if getAsleep():
		quitWorkingForNow()
		return
	
	if canAndShouldRefuel():
		workJob(nextJob)
	elif canStartAnotherJob():
		workJob(nextJob)
	else:
		quitWorkingForNow()

func rollForCrit() -> float:
	var critMultiplier = 1.0
	if getCritRoll():
		critMultiplier *= rand_range(7.5, 12.5)
		if getCritCritRoll():
			critMultiplier *= rand_range(7.5, 12.5)
	return critMultiplier

func getProducedResourcesDictionary(job: Job, critMultiplier: float) -> Dictionary:
	var f := {}
	for resource in job.producedResources:
		f[resource] = Big.new(job.producedResources[resource]).m(critMultiplier)
	return f

func takeRequiredFuelFromStorage(requiredFuel: Big):
	lored.currentFuel.s(requiredFuel)

func takeRequiredResources(_requiredResources: Dictionary):
	for resource in _requiredResources:
		gv.subtractFromResource(resource, _requiredResources[resource])

func giveProducedResources(_producedResources: Dictionary):
	for resource in _producedResources:
		gv.addToResource(resource, _producedResources[resource])
		taq.increaseProgress(gv.Objective.RESOURCES_PRODUCED, str(resource), _producedResources[resource])

func getOutputTextDetails(producedResources: Dictionary, critMultiplier: float) -> Array:
	
	var array := []
	
	for resource in producedResources:
		
		var f := {}
		
		var text: String = "+" + producedResources[resource].toString()
		if critRoll:
			text += " (x" + str(stepify(critMultiplier, 0.1)) + ")"
		
		f["life"] = 10
		f["text"] = text
		f["icon"] = gv.sprite[gv.shorthandByResource[resource]]
		f["color"] = gv.COLORS[gv.shorthandByResource[resource]]
		
		array.append(f)
	
	return array

var nextJob: Job
func canStartAnotherJob() -> bool:
	for job in lored.jobs.values():
		if canStartJob(job):
			nextJob = job
			return true
	return false

func canAndShouldRefuel() -> bool:
	
	if getCurrentFuelPercent() > 0.75:
		return false
	
	if canStartJob(lored.refuelJob):
		nextJob = lored.refuelJob
		updatePrimaryResource(getPrimaryResource())
		return true
	
	return false

func updateRequiredFuelForAllJobs():
	for job in lored.jobs.values():
		job.updateRequiredFuel()

func quitWorkingForNow():
	lored.working = false
	vico.hideProgress()
	repeatedlyLookForWork()
	lored.finishedWorkingForNow()
	cleanUpIfAsleep()

func cleanUpIfAsleep():
	if getAsleep():
		cleanUp()
func cleanUp():
	vico.hideProduction()
	updateStatus("")

func highlightJobInTooltip(job: Job):
	if rt.get_node("global_tip").tip_filled:
		if rt.get_node("global_tip").type == "lored jobs":
			if rt.get_node("global_tip").tip.cont["lored jobs"].lored == type:
				rt.get_node("global_tip").tip.cont["lored jobs"].highlightJob(job)

func stopHighlightJobInTooltip(job: Job):
	if rt.get_node("global_tip").tip_filled:
		if rt.get_node("global_tip").type == "lored jobs":
			if rt.get_node("global_tip").tip.cont["lored jobs"].lored == type:
				rt.get_node("global_tip").tip.cont["lored jobs"].stopHighlightJob(job)



# - - - Status

func updateStatus(text: String):
	vico.setStatusText(text)



# - - - Production

func updateFuelDrain(purchased = getPurchased()):
	if purchased:
		lv.updateFuelDrain(getFuelResource(), type, getFuelCost())
	else:
		lv.updateFuelDrain(getFuelResource(), type, Big.new(0))



# - - - Automation

var autobuying := false setget setAutobuying
func setAutobuying(val):
	autobuying = val
	vico.displayAutobuy(autobuying)

func autoWatch():
	
	if not autobuying:
		return
	
	var t = Timer.new()
	add_child(t)
	
	while not is_queued_for_deletion() and autobuying:
		
		if shouldAutobuy():
			autoBuy()
		
		t.start(0.25)
		yield(t, "timeout")
	
	t.queue_free()

func shouldAutobuy() -> bool:
	
	if inFirstTwoSecondsOfRun():
		return false
	
	if not autobuying:
		return false
	
	if not getPurchased():
		return true
	
	if getAsleep():
		return false
	
	if not canAffordPurchase():
		return false
	
	if autobuy_upgrade_check():
		return true
	
	# if any required resource in any job has a negative net, return false
	for job in lored.jobs.values():
		
		for resource in job.requiredResourcesBits.keys():
			var net = lv.net(resource)
			if net[1] == -1:
				return false
	
	if lored.keyLORED:
		return true
	
	# if any produced resource has a negative net, return true
	for job in lored.jobs.values():
		
		for resource in job.producedResourcesBits.keys():
			var net = lv.net(resource)
			if net[1] == -1:
				return true
	
	return false
	
#	# if ingredient LORED per_sec < per_sec, don't buy
#	for x in b:
#
#		if gv.g[x].hold:
#			return false
#
#		var consm = Big.new(b[x].t).m(d.t).d(speed.t).d(jobs[0].base_duration)
#		# how much this lored consumes from the ingredient lored (x)
#
#		if gv.g[x].halt:
#
#			var consm2 = Big.new(consm).m(2)
#			if consm2.less(gv.g[x].net(true)[0]):
#				if not gv.g[x].cost_check():
#					return false
#
#		else:
#
#			var net = gv.g[x].net()
#
#			if net[0].less(net[1]):
#				return false
#
#			net = Big.new(net[0]).s(net[1])
#			if consm.greater(net):
#				if not gv.g[x].cost_check():
#					return false

func autobuy_upgrade_check() -> bool:
	
	if getStage() == 1 and gv.up["don't take candy from babies"].active() and getLevel() < 5:
		return true
	
	match type:
		lv.Type.MALIGNANCY, lv.Type.IRON, lv.Type.COPPER:
			if gv.up["THE WITCH OF LOREDELITH"].active():
				return true
		lv.Type.IRON_ORE:
			if gv.up["I RUN"].active():
				return true
		lv.Type.COPPER_ORE:
			if gv.up["THE THIRD"].active():
				return true
		lv.Type.COAL:
			if gv.up["wait that's not fair"].active():
				return true
	
	return false

func autoBuy():
	purchased()

func inFirstTwoSecondsOfRun() -> bool:
	return gv.durationSinceLastReset < 2
