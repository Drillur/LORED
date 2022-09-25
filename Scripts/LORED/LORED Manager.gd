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

func setupElements():
	
	jobTimer = Timer.new()
	jobTimer.one_shot = true
	add_child(jobTimer)



func justAppearedForTheFirstTime():
	syncAll()
	lored.syncJobs_all()
	updatePrimaryResource(lored.jobs.values()[0])
	enterStandby()

func updatePrimaryResource(job: Job):
	
	vico.setIcon(job.primaryResourceIcon)
	vico.primaryResource = job.primaryResource
	vico.resourceTextColor = job.primaryResourceColor





func syncAll():
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
	
	var newQueue := []
	
	if lored.queue.has(lv.Queue.FUEL_STORAGE):
		setQuarterTank(Big.new(getFuelStorage()).d(4))
	
	if lored.queue.has(lv.Queue.FUEL_COST):
		updateFuelDrain()
		updateRequiredFuelForAllJobs()
	
	if lored.queue.has(lv.Queue.HASTE) or lored.queue.has(lv.Queue.OUTPUT) or lored.queue.has(lv.Queue.INPUT):
		newQueue.append(lv.Queue.UPDATE_PRODUCTION)
	
	lored.queue.clear()
	
	for item in newQueue:
		lored.queue(item)



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
var exporting: bool setget , getExporting
func getExporting() -> bool:
	return lored.exporting
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
var quarterTank: Big setget setQuarterTank
var quarterTankText: String setget , getQuarterTankText
var quarterTankUpdated := true
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
func setQuarterTank(val: Big):
	quarterTank = val
	quarterTankUpdated = true
func getQuarterTankText() -> String:
	if quarterTankUpdated:
		setQuarterTankText()
	return quarterTankText
func setQuarterTankText():
	quarterTankUpdated = false
	quarterTankText = quarterTank.toString()


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

func pronoun(index: int):
	return lored.pronoun[index]



# - - - Duplicate functions

func syncCostModifier():
	lored.syncCostModifier()

func getJobDuration(index: int) -> float:
	return lored.getJobDuration(index)



# - - - Actions

func unlock():
	lored.unlocked = true
	vico.show()

func purchase():
	if canAffordPurchase():
		lored.prePurchase()
		lored.purchased()
		rt.get_node("global_tip").refresh()
		vico.levelUpFlash()
		vico.levelUpText()
	else:
		rt.get_node("global_tip").tip.price_flash()
func forcePurchase():
	lored.purchased()
	syncQueue()


func switchExport():
	if getExporting():
		stopExport()
	else:
		resumeExport()
func stopExport():
	lored.stopExport()
func resumeExport():
	lored.resumeExport()



# - - - Watchers

func watchCost():
	
	var t = Timer.new()
	add_child(t)
	
	while not is_queued_for_deletion():
		
		if canAffordPurchase():
			vico.check.show()
		else:
			vico.check.hide()
		
		t.start(0.25 if mode == lv.Mode.ACTIVE else 1)
		yield(t, "timeout")
	
	t.queue_free()

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



# - - - Checkers

func canAffordPurchase() -> bool:
	
	var cost = getCost()
	for c in cost:
		if gv.resource[c].less(cost[c]):
			return false
	
	return true



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



# - - - Modes

var mode: int = lv.Mode.HIDDEN

func enterStandby():
	# enters stand-by mode. updates resource count, that's pmuch it
	# called by Vico when it becomes visible.
	mode = lv.Mode.STANDBY
	vico.enterStandby()

func enterActive():
	mode = lv.Mode.ACTIVE
	vico.enterActive()
	watchCurrentFuel()
	updateFuelDrain(true)
	findFirstJob()










# - - - Jobs and work

var jobTimer: Timer

func findFirstJob():
	
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
		if gv.resource[getFuelResource()].less(quarterTank):
			reasonWhyCannotStartJob = lv.ReasonCannotBeginJob.INSUFFICIENT_FUEL_RESOURCE
			var coloredResourceName = "[color=#" + gv.COLORS[gv.shorthandByResource[getFuelResource()]].to_html() + "]" + gv.resourceName[getFuelResource()] + "[/color]"
			updateStatus("Awaiting " + getQuarterTankText() + " available " + coloredResourceName + ".")
			return false
	
	if lored.currentFuel.less(job.requiredFuel):
		reasonWhyCannotStartJob = lv.ReasonCannotBeginJob.LOW_FUEL
		return false
	
	if not job.haveAndCanUseRequiredResources():
		# reasonWhyCannotStartJob is set in job.haveAndCanUseRequiredResources()
		return false
	
	reasonWhyCannotStartJob = -1
	lored.working = true
	return true

func workJob(job: Job):
	
	lored.jobStarted(job)
	
	if job.requiresResource:
		takeRequiredResources(job.requiredResources)
		updateDrainForRequiredResources(job.drainRate)
	takeRequiredFuelFromStorage(job.requiredFuel)
	
	if job.type == lv.Job.REFUEL:
		gv.subtractFromResource(job.primaryResource, quarterTank)
	
	var currentTime = OS.get_ticks_msec()
	vico.jobStarted(job.duration, currentTime)
	
	updatePrimaryResource(job)
	vico.updateProduction()
	updateStatus(job.actionText)
	
	
	
	jobTimer.start(job.duration)
	yield(jobTimer, "timeout")
	
	
	
	if job.producesResource:
		var critMultiplier = rollForCrit()
		var producedResources = getProducedResourcesDictionary(job, critMultiplier)
		giveProducedResources(producedResources)
		var outputTextDetails = getOutputTextDetails(producedResources, critMultiplier)
		vico.throwOutputTexts(outputTextDetails)
		
		resetCritRolls()
	
	if job.type == lv.Job.REFUEL:
		lored.currentFuel.a(quarterTank)
	
	syncQueue()
	
	if canAndShouldRefuel():
		workJob(nextJob)
	elif canStartAnotherJob():
		workJob(nextJob)
	else:
		lored.working = false
		vico.hideProgress()
		repeatedlyLookForWork()
		lored.finishedWorkingForNow()

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
func updateDrainForRequiredResources(drainRate: Dictionary):
	for resource in drainRate:
		lv.updateDrain(resource, type, drainRate[resource])

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
		return true
	
	return false

func updateRequiredFuelForAllJobs():
	for job in lored.jobs.values():
		job.updateRequiredFuel()



# - - - Status

func updateStatus(text: String):
	vico.setStatusText(text)



# - - - Production

func updateFuelDrain(purchased = getPurchased()):
	if purchased:
		lv.updateFuelDrain(getFuelResource(), type, getFuelCost())
