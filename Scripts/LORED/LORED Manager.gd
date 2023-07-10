class_name LOREDManager
extends Node2D



onready var rt = get_node("/root/Root")



var lored: LORED
var vico: LOREDVico



var type: int



func _ready() -> void:
	gv.connect("limit_break_leveled_up", self, "limit_break_level_up")
	if type == lv.Type.BLOOD:
		cast_timer = Timer.new()
		add_child(cast_timer)



func _init(_type: int):
	
	type = _type
	lored = LORED.new(type)
	lored.assignManager(self)
	
	store_produced_and_required_resources()
	
	name = lored.name
	
	if type == lv.Type.COPPER_ORE:
		nextEmote = EmoteManager.Type.COPPER_ORE0
	
	if type == lv.Type.BLOOD:
		gv.connect("unit_status_effect_applied", self, "add_status_effects_to_unit_tooltip")



func assignVico(_vico: MarginContainer):
	vico = _vico
	setupVico()
	setupSignals()
	setupElements()
	watchCost()
	autoWatch()

func setupVico():
	vico.setup(type)
	vico.assignManager(self)

func setupSignals():
	gv.connect("exportChanged", self, "exportChanged")

func setupElements():
	
	jobTimer = Timer.new()
	jobTimer.one_shot = true
	add_child(jobTimer)



func justAppearedForTheFirstTime():
	syncAllNow()
	lored.syncJobs_all()
	lored.sort_jobs()
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
		if q == lv.Queue.UPDATE_PRODUCTION:
			continue
		lored.call("sync_" + lv.Queue.keys()[q])
	
	var minimum = Big.new(lored.fuelCost).m(get_refuel_job().duration * 2)
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
	
	if rt.get_node("global_tip").tip_filled:
		if rt.get_node("global_tip").type in ["lored level up", "lored info"]:
			if rt.get_node("global_tip").tip.temp["lored"] == type:
				rt.get_node("global_tip").refresh()



# - - - Getters
# These variables are never assigned a value.
# Instead, they only pull from the LORED class. See: the "lored" var

func get_refuel_job() -> Job:
	return lored.get_refuel_job()

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

var jobs: Dictionary setget , getJobs
func getJobs() -> Dictionary:
	return lored.jobs

var key: String setget , get_key
func get_key() -> String:
	return lored.key

var sorted_jobs: Array setget , get_sorted_jobs
func get_sorted_jobs() -> Array:
	return lored.sorted_job_keys



# - - - Duplicate functions

func save() -> String:
	return lored.save()
func load(data: Dictionary):
	lored.load(data)

func updateMaxDrain():
	lored.updateMaxDrain()

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

func applyDynamicUpgrade(_key: String, effectIndex: int, folder: String):
	lored.applyDynamicUpgrade(_key, effectIndex, folder)
func removeDynamicUpgrade(_key: String, folder: String):
	lored.removeDynamicUpgrade(_key, folder)

func emote(emote: MarginContainer):
	vico.emote(emote)

func removeCost(resource: int):
	lored.removeCost(resource)



# - - - Actions

func unlock():
	lored.unlocked = true
	vico.show()
	gv.emit_signal("stats_unlockLOREDStats", type)
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
		gv.stats["TimesLeveledUp"]["manual"][type] += 1
		gv.emit_signal("TimesLeveledUp", "manual", type)
		purchased()
		rt.get_node("global_tip").refresh()
	else:
		if rt.get_node("global_tip").tip_filled:
			if rt.get_node("global_tip").type == "lored level up":
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
	emoteEvent()



func asleepClicked(manual := false):
	if getAsleep():
		wakeUp()
	else:
		putToSleep()
		updateMaxDrain()
		watchSleepTime()
	if manual:
		rt.get_node("global_tip").refresh("lored asleep")
func putToSleep():
	lored.asleep = true
	vico.updateSleepButton()
func wakeUp():
	lored.asleep = false
	vico.updateSleepButton()

func flashSleep():
	vico.flashSleep()

func reset():
	remove_all_buffs()
	stopWorking()
	enterStandby()
	lored.reset()
	syncAllNow()
	cleanUp()
	lored.currentFuel = Big.new(lored.fuelStorage)
	vico.last_job = -1

func emoteEvent():
	match type:
		lv.Type.COAL:
			if gv.stats["TimesLeveledUp"]["manual"][type] == 2:
				EmoteManager.emote(EmoteManager.Type.COAL_WHOA)
			elif gv.stats["TimesLeveledUp"]["manual"][type] == 1:
				EmoteManager.emote(EmoteManager.Type.COAL_GREET)


func addJob(jobType: int):
	lored.addJob(jobType)
	lored.jobs[jobType].syncAll()
	lored.sort_jobs()



# - - - Watchers

func watchCost():
	
	var t = Timer.new()
	add_child(t)
	
	while not is_queued_for_deletion():
		
		updateVicoCheck()
		
		t.start(0.25 if mode == lv.Mode.ACTIVE else 1.0)
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
		gv.stats["TimeAsleep"][type] += 1
		gv.emit_signal("TimeAsleep", type)
		
		if sleepTime >= 30:
			newAlert(lv.AlertType.ASLEEP)
			break
	
	watchingSleepTime = false
	t.queue_free()


func limit_break_level_up():
	if diff.active_difficulty == diff.Difficulty.SONIC:
		lored.queue(lv.Queue.HASTE)
	else:
		lored.queue(lv.Queue.OUTPUT)
		lored.queue(lv.Queue.INPUT)



# - - - Checkers

func canAffordPurchase() -> bool:
	
	var _cost = getCost()
	for c in _cost:
		if gv.resource[c].less(_cost[c]):
			return false
	
	return true

var locked_resource: int
func exportChanged(resource: int):
	if not resource in lored.usedResources:
		return
	if gv.resource_is_locked(resource):
		locked_resource = resource
		newAlert(lv.AlertType.REQUIRED_RESOURCE_NOT_EXPORTING)



# - - - Alerts

var alerts := []
var activeAlert := -1

func newAlert(_type: int):
	
	if _type in alerts:
		return
	
	alerts.append(_type)
	
	if alerts.size() == 1:
		vico.showAlert()
	
	alerts.sort()
	
	if _type < activeAlert:
		stopAlertProcess(activeAlert)
	
	startAlertProcess(_type)

func stopAlert(_type: int):
	
	if not _type in alerts:
		return
	
	alerts.erase(_type)
	
	if _type == activeAlert:
		resumeUnfinishedAlert()

func resumeUnfinishedAlert():
	for alert in alerts:
		startAlertProcess(alert)
		return
	allAlertsGone()

func allAlertsGone():
	activeAlert = -1
	vico.hideAlert()

func startAlertProcess(_type: int):
	activeAlert = _type
	match _type:
		lv.AlertType.ASLEEP:
			alert_asleep()
		lv.AlertType.LOW_FUEL:
			alert_lowFuel()
		lv.AlertType.REQUIRED_RESOURCE_NOT_EXPORTING:
			alert_resource_not_exporting()
func stopAlertProcess(_type: int):
	match _type:
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

func alert_resource_not_exporting():
	
	vico.alert_resource_not_exporting()
	
	var t = Timer.new()
	add_child(t)
	
	while not is_queued_for_deletion():
		
		if not locked_resource in gv.locked_resources:
			stopAlert(lv.AlertType.REQUIRED_RESOURCE_NOT_EXPORTING)
			alert_resource_not_exporting_stop()
			break
		
		t.start(1)
		yield(t, "timeout")
	
	t.queue_free()
func alert_resource_not_exporting_stop():
	vico.alert_resource_not_exporting_stop()


# - - - Modes

var mode: int = lv.Mode.HIDDEN

func enterStandby():
	# enters stand-by mode. updates resource count, that's pmuch it
	# called by Vico when it becomes visible.
	mode = lv.Mode.STANDBY
	vico.enterStandby()
	updateFuelDrain(false)
	gv.append_value_to_list(type, gv.list.lored["unlocked and inactive"])

func enterActive():
	syncQueue()
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
	vico.stop_working()

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
		
		if stopWorking:
			return
		
		if getAsleep():
			cleanUpIfAsleep()
			continue
		if canAndShouldRefuel():
			workJob(nextJob)
		else:
			lookForWork()

func lookForWork():
	for job_key in get_sorted_jobs():
		var job = lored.jobs[job_key]
		if canStartJob(job):
			workJob(job)

var reasonWhyCannotStartJob: int

func canStartJob(job: Job) -> bool:
#	the refuel job is spamming!! that means somewhere here it is returning true.
#	i changed it so that Refuel is at the top of the lv.Job list, giving it the highest priority.
#	make it so that it will not refuel if lored is >75% fuel duh
	
	if job.type == lv.Job.REFUEL:
		if getCurrentFuelPercent() > 0.75:
			return false
		var fuel_resource = getFuelResource()
		if fuel_resource == gv.Resource.COAL:
			if lv.lored[lv.Type.COAL].purchased:
				if lv.lored[lv.Type.COAL].getCurrentFuelPercent() <= 0.5:
					if type != lv.Type.COAL:
						var coloredResourceName = "[color=#" + gv.COLORS[gv.shorthandByResource[fuel_resource]].to_html() + "]" + gv.resourceName[fuel_resource] + "[/color]"
						updateStatus("Letting " + coloredResourceName + "\ncatch up.")
						return false
		var requiredFuel = get_refuel_job().requiredResourcesBits[getFuelResource()].total
		var quarter_tank = getQuarterTank()
		if gv.resource[fuel_resource].less(quarter_tank):
			reasonWhyCannotStartJob = lv.ReasonCannotBeginJob.INSUFFICIENT_FUEL_RESOURCE
			var coloredResourceName = "[color=#" + gv.COLORS[gv.shorthandByResource[fuel_resource]].to_html() + "]" + gv.resourceName[fuel_resource] + "[/color]"
			updateStatus("Awaiting " + requiredFuel.toString() + " available " + coloredResourceName + ".")
			updatePrimaryResource(fuel_resource)
			vico.hideProduction()
			return false
	
	if getCurrentFuelPercent() <= 0.25:
		
		var the_coal_lored: bool = type == lv.Type.COAL
		var the_refuel_job: bool = job.type == lv.Job.REFUEL
		
		if not the_coal_lored and not the_refuel_job:
			reasonWhyCannotStartJob = lv.ReasonCannotBeginJob.LOW_FUEL
			return false
	
	if job.costs_fuel:
		if lored.currentFuel.less(job.requiredFuel):
			reasonWhyCannotStartJob = lv.ReasonCannotBeginJob.LOW_FUEL
			return false
	
	if not job.haveAndCanUseRequiredResources():
		
		# reasonWhyCannotStartJob is set in job.haveAndCanUseRequiredResources()
		
		if reasonWhyCannotStartJob == lv.ReasonCannotBeginJob.LORED_NOT_EXPORTING:
			var resource_shorthand = gv.shorthandByResource[job.reason_resource]
			var img_bbcode = "[img=<16>]" + gv.sprite[resource_shorthand].get_path() + "[/img]"
			updateStatus(img_bbcode + " is locked.")
		
		elif reasonWhyCannotStartJob == lv.ReasonCannotBeginJob.INSUFFICIENT_RESOURCES:
			var resource_shorthand = gv.shorthandByResource[job.reason_resource]
			var img_bbcode = "[img=<16>]" + gv.sprite[resource_shorthand].get_path() + "[/img]"
			updateStatus("Insufficient " + img_bbcode)
		
		return false
	
	if job.type == lv.Job.PLANT_SEED:
		if not Flower.seed_is_available():
			gv.setResource(gv.Resource.FLOWER_SEED, 0)
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
	vico.jobStarted(job.duration, currentTime, job.type)
	
	updatePrimaryResource(job.primaryResource)
	if job.type == lv.Job.REFUEL:
		gv.stats["TimesRefueled"][type] += 1
		gv.emit_signal("TimesRefueled", type)
		vico.hideProduction()
		drinkingAMilkshake()
	else:
		gv.stats["OtherJobs"][type] += 1
		gv.emit_signal("OtherJobs", type)
		vico.updateProduction()
	updateStatus(job.get_text())
	
	if job.type == lv.Job.WIRE:
		lv.lored[lv.Type.DRAW_PLATE].throw_draw_plate()
	
	job.add_pending_resource()
	
	
	jobTimer.start(job.duration)
	yield(jobTimer, "timeout")
	
	job.randomize_duration()
	job.remove_pending_resource()
	
	stopHighlightJobInTooltip(job)
	
	if stopWorking:
		if not lored.lastJob in [lv.Job.REFUEL, -1]:
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
	
	job.completed()
	
	if job.type == lv.Job.REFUEL:
		lored.currentFuel.a(getQuarterTank())
	
	syncQueue()
	
	if should_create_new_healing_event():
		lored.working = false
		stopWorking()
		new_healing_event()
		return
	
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
		
		if job.resource_has_a_range(resource):
			var random_value = job.get_value_in_resource_range(resource)
			f[resource].m(random_value)
	
	return f

var produced_resources := {}
func store_produced_and_required_resources():
	produced_resources = {}
	for job in lored.jobs.values():
		for resource in job.producedResourcesBits.keys():
			if not resource in produced_resources.keys():
				produced_resources[resource] = []
			if not job in produced_resources[resource]:
				produced_resources[resource].append(job)

func can_produce_resource(resource: int, lored_stack := []) -> bool:
	
	if type in lored_stack:
		return true
	
	lored_stack.append(type)
	
	if not getPurchased():
		return false
	if not lv.lored[lored.fuelResourceLORED].purchased:
		return false
	if not resource in produced_resources:
		return false
	
	for job in produced_resources[resource]:
		
		if not job.requiresResource:
			return true
		
		for _resource in job.requiredResources:
			if not gv.resourceBeingProduced(_resource, lored_stack):
				return false
		
		return true
	
	print_debug("Oh, this code can be reached? Bruh moment! Haha xD")
	return false


func takeRequiredFuelFromStorage(requiredFuel: Big):
	lored.currentFuel.s(requiredFuel)

func takeRequiredResources(_requiredResources: Dictionary):
	for resource in _requiredResources:
		gv.subtractFromResource(resource, _requiredResources[resource])
		
		gv.stats["ResourceStats"]["used"][resource].a(_requiredResources[resource])
		gv.emit_signal("resourceChanged", resource)

func giveProducedResources(_producedResources: Dictionary):
	for resource in _producedResources:
		
		var amount = Big.new(_producedResources[resource])
		
		gv.addToResource(resource, amount)
		gv.increase_lb_xp(amount)
		taq.increaseProgress(gv.Objective.RESOURCES_PRODUCED, str(resource), amount)
		
		if resource == gv.Resource.GROWTH:
			call("giveBonusResources_" + gv.Resource.keys()[resource])
			return
		
		if resource in [gv.Resource.COPPER_ORE, gv.Resource.IRON_ORE, gv.Resource.COAL]:
			if call("canGiveBonusResources_" + gv.Resource.keys()[resource]):
				if resource == gv.Resource.COAL:
					amount.m(10)
					resource = gv.Resource.STONE
				if resource == gv.Resource.IRON_ORE:
					resource = gv.Resource.IRON
				if resource == gv.Resource.COPPER_ORE:
					resource = gv.Resource.COPPER
				gv.addToResource(resource, amount)
				gv.increase_lb_xp(amount)
				taq.increaseProgress(gv.Objective.RESOURCES_PRODUCED, str(resource), amount)

func canGiveBonusResources_IRON_ORE() -> bool:
	return gv.up["I RUN"].active()
func canGiveBonusResources_COPPER_ORE() -> bool:
	return gv.up["THE THIRD"].active()
func canGiveBonusResources_COAL() -> bool:
	return gv.up["wait that's not fair"].active()
func giveBonusResources_GROWTH():
	
	if not gv.up["IT'S GROWIN ON ME"].active():
		return
	
	var buff = 0.1 * lv.lored[lv.Type.GROWTH].level
	
	if not gv.up["IT'S SPREADIN ON ME"].active():
		var roll = randi()%2
		match roll:
			0:
				gv.up["IT'S GROWIN ON ME"].effects[0].effect.a.a(buff)
				lv.lored[lv.Type.IRON].lored.queue(lv.Queue.OUTPUT)
				gv.up["IT'S GROWIN ON ME"].effects[2].effect.a.a(buff)
				lv.lored[lv.Type.IRON].lored.queue(lv.Queue.INPUT)
			1:
				gv.up["IT'S GROWIN ON ME"].effects[1].effect.a.a(buff)
				lv.lored[lv.Type.COPPER].lored.queue(lv.Queue.OUTPUT)
				gv.up["IT'S GROWIN ON ME"].effects[3].effect.a.a(buff)
				lv.lored[lv.Type.COPPER].lored.queue(lv.Queue.INPUT)
	else:
		gv.up["IT'S GROWIN ON ME"].effects[0].effect.a.a(buff)
		gv.up["IT'S GROWIN ON ME"].effects[1].effect.a.a(buff)
		gv.up["IT'S SPREADIN ON ME"].effects[0].effect.a.a(buff)
		gv.up["IT'S SPREADIN ON ME"].effects[1].effect.a.a(buff)
		lv.lored[lv.Type.IRON].lored.queue(lv.Queue.OUTPUT)
		lv.lored[lv.Type.COPPER].lored.queue(lv.Queue.OUTPUT)
		lv.lored[lv.Type.IRON_ORE].lored.queue(lv.Queue.OUTPUT)
		lv.lored[lv.Type.COPPER_ORE].lored.queue(lv.Queue.OUTPUT)

func drinkingAMilkshake():
	if not getFuelResource() == gv.Resource.COAL:
		return
	if not gv.up["I DRINK YOUR MILKSHAKE"].active():
		return
	var buff = float(getLevel()) / 100
	gv.up["I DRINK YOUR MILKSHAKE"].effects[0].effect.a.a(buff)
	lv.lored[lv.Type.COAL].lored.queue(lv.Queue.OUTPUT)

func getOutputTextDetails(producedResources: Dictionary, critMultiplier: float) -> Array:
	
	var array := []
	
	for resource in producedResources:
		
		var f := {}
		
		var text: String = "+" + producedResources[resource].toString()
		
		if critRoll:
			gv.stats["Crits"][type] += 1
			gv.emit_signal("Crits", type)
			text += " (x" + str(stepify(critMultiplier, 0.1)) + ")"
		
		f["life"] = 50
		f["text"] = text
		f["icon"] = gv.sprite[gv.shorthandByResource[resource]]
		f["color"] = gv.COLORS[gv.shorthandByResource[resource]]
		
		array.append(f)
	
	return array

var nextJob: Job
func canStartAnotherJob() -> bool:
	for job_key in get_sorted_jobs():
		var job = lored.jobs[job_key]
		if canStartJob(job):
			nextJob = job
			return true
	return false

func canAndShouldRefuel() -> bool:
	
	if getCurrentFuelPercent() > 0.75:
		return false
	
	if canStartJob(get_refuel_job()):
		nextJob = get_refuel_job()
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
			if rt.get_node("global_tip").tip.cont.lored == type:
				rt.get_node("global_tip").tip.cont.highlightJob(job)

func stopHighlightJobInTooltip(job: Job):
	if rt.get_node("global_tip").tip_filled:
		if rt.get_node("global_tip").type == "lored jobs":
			if rt.get_node("global_tip").tip.cont.lored == type:
				rt.get_node("global_tip").tip.cont.stopHighlightJob(job)


func throw_draw_plate():
	vico.throw_draw_plate()


func should_create_new_healing_event() -> bool:
	if type != lv.Type.BLOOD:
		return false
	if healing_event_queued:
		return true
	return false



# - - - Status

func updateStatus(text: String):
	vico.setStatusText(text)



# - - - Production

func updateFuelDrain(_purchased = getPurchased()):
	if _purchased:
		lv.updateFuelDrain(getFuelResource(), type, getFuelCost())
	else:
		lv.updateFuelDrain(getFuelResource(), type, Big.new(0))



# - - - Automation

var autobuying := false setget setAutobuying
func setAutobuying(val):
	autobuying = val
	vico.displayAutobuy(autobuying)

func autoWatch():
	
	var t = Timer.new()
	add_child(t)
	
	while true:# not is_queued_for_deletion():
		
		if not autobuying:
			t.start(5)
			yield(t, "timeout")
			continue
		
		if shouldAutobuy():
			autobuy()
		
		t.start(0.25)
		yield(t, "timeout")
	
	t.queue_free()

func shouldAutobuy() -> bool:
	
	if not getUnlocked():
		return false
	
	if gv.inFirstTwoSecondsOfRun():
		return false
	
	if not autobuying:
		return false
	
	if not canAffordPurchase():
		return false
	
	if has_method("autobuy_" + lv.Type.keys()[type]):
		if not call("autobuy_" + lv.Type.keys()[type]):
			return false
	
	if not is_a_lored_required_for_extra_normal_upgrade_menu_unlock():
		return false
	
	if not getPurchased():
		return true
	
	if lored.queue.size() > 0:
		return false
	
	if getAsleep():
		return false
	
	if autobuy_upgrade_check():
		return true
	
	if getWorking():
		if lored.lastJob == lv.Job.REFUEL:
			return false
	
	# if any required resource in any job has a negative net, return false
	for job in lored.jobs.values():
		
		for resource in job.requiredResourcesBits.keys():
			var net = lv.maxNet(resource)
			if net[1] == -1:
				return false
	
	if lored.keyLORED:
		return true
	
	# if any produced resource has a negative net, return true
	for job in lored.jobs.values():
		
		for resource in job.producedResourcesBits.keys():
			var net = lv.maxNet(resource)
			if net[1] == -1:
				return true
	
	return false

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

func autobuy():
	gv.stats["TimesLeveledUp"]["automated"][type] += 1
	gv.emit_signal("TimesLeveledUp", "automated", type)
	purchased()

func is_a_lored_required_for_extra_normal_upgrade_menu_unlock() -> bool:
	if getStage() == 1:
		return true
	if gv.s2_upgrades_may_be_autobought:
		return true
	return type in lv.loreds_required_for_s2_autoup_upgrades_to_begin_purchasing

func autobuy_GALENA() -> bool:
	return lv.lored[lv.Type.DRAW_PLATE].purchased

func autobuy_WOOD() -> bool:
	return lv.lored[lv.Type.SEEDS].purchased



# - Emote / dialogue

var nextEmote: int = -1
func randomEmote() -> int:
	
	if type == lv.Type.COPPER_ORE:
		nextEmote += 1
		if nextEmote > EmoteManager.Type.COPPER_ORE12:
			nextEmote = EmoteManager.Type.COPPER_ORE0
	if nextEmote == -1:
		if lored.emotePool.size() == 0:
			return EmoteManager.Type.CONCRETE0
		return lored.emotePool[randi() % lored.emotePool.size()]
	else:
		return nextEmote



# - Buffs

var active_buffs: Dictionary


func apply_buff(buff: Buff):
	
	if buff_already_applied(buff.type):
		if buff_is_queued_for_removal(buff.type):
			print_debug("I thought this line would never be reached!")
		else:
			active_buffs[buff.type].add_instance()
			active_buffs[buff.type].reset_ticks()
			return
	
	active_buffs[buff.type] = buff
	
	vico.display_active_buffs()
	
	process_buff(buff)


func process_buff(buff: Buff):
	
	var timer = Timer.new()
	add_child(timer)
	
	while not is_queued_for_deletion():
		
		if buff.queued_for_removal:
			break
		
		timer.start(buff.tick_rate)
		yield(timer, "timeout")
		
		if buff.queued_for_removal:
			break
		
		buff.tick()
		
		if has_method("buff_tick_" + buff.key):
			call("buff_tick_" + buff.key)
		
		if buff.max_ticks != -1:
			if buff.ticks >= buff.max_ticks:
				remove_buff(buff.type)


func buff_tick_WITCH():
	
	if not rt.get_node("global_tip").tip_filled:
		return
	if rt.get_node("global_tip").type != "lored active buffs":
		return
	
	var witch: Dictionary = active_buffs[BuffManager.Type.WITCH].witch
	var output_texts := []
	
	for resource in witch:
		output_texts.append({
			"text": "+" + witch[resource].toString(),
			"icon": gv.sprite[gv.shorthandByResource[resource]],
			"color": gv.COLORS[gv.shorthandByResource[resource]],
			#"direction": randi() % 100, #int(rand_range(10, 100)),
		})
	
	if rt.get_node("global_tip").tip.cont.lored == type:
		var parent_node = rt.get_node("global_tip").tip.cont.buff_ui[BuffManager.Type.WITCH].get_node("%texts")
		gv.throwOutputTexts(output_texts, parent_node)


func remove_all_buffs():
	for buff in active_buffs:
		remove_buff(buff)


func remove_buff(buff_type: int):
	
	if buff_is_not_present(buff_type):
		return
	
	if buff_is_queued_for_removal(buff_type):
		return
	
	active_buffs[buff_type].queue_removal()
	if has_method("buff_removed_" + active_buffs[buff_type].key):
		call("buff_removed_" + active_buffs[buff_type].key)
	
	active_buffs.erase(buff_type)
	
	if active_buffs.empty():
		vico.hide_active_buffs()


func buff_is_not_present(buff_type: int) -> bool:
	return not buff_already_applied(buff_type)

func buff_already_applied(buff_type: int) -> bool:
	return buff_type in active_buffs.keys()

func buff_is_queued_for_removal(buff_type: int) -> bool:
	return active_buffs[buff_type].queued_for_removal



# - Promotions

func promote():
	var _key := get_key()
	if has_method("promote_" + _key):
		call("promote_" + _key)
	else:
		print_debug(_key)
		print_debug("Make the function for this you little fucker")


func promote_WITCH():
	lored.remove_original_fuel_cost_from_relevant_jobs()
	lored.change_fuel_resource(gv.Resource.MANA)
	# add new jobs here




# - Special

var healing_event_queued := false
var queued_healing_event_type: int
var casting := -1
var cast_pass: int
var cast_timer: Timer
var time_when_cast_begun: float
var queue_cast: Dictionary

var last_target: Unit
var last_ability: UnitAbility


func queue_healing_event(_type = HealingEvent.Type.RANDOM) -> void:
	healing_event_queued = true
	queued_healing_event_type = _type


func new_healing_event() -> void:
	vico.new_healing_event(queued_healing_event_type)
	healing_event_queued = false



func cannot_cast_ability(reason: int = reasonWhyCannotStartJob, ability = 0) -> void:
	reasonWhyCannotStartJob = reason
	
	var reason_text: String
	
	match reasonWhyCannotStartJob:
		lv.ReasonCannotBeginJob.INSUFFICIENT_BLOOD, lv.ReasonCannotBeginJob.INSUFFICIENT_MANA:
			reason_text = lv.ReasonCannotBeginJob.keys()[reasonWhyCannotStartJob]
			reason_text = reason_text.replace("_", " ").capitalize() + "."
		lv.ReasonCannotBeginJob.INSUFFICIENT_FLOWERS:
			reason_text = "Insufficient " + Flower.get_plural_flower_name(ability.flower_cost) + "."
		lv.ReasonCannotBeginJob.NO_TARGET:
			reason_text = "You have no target."
		lv.ReasonCannotBeginJob.ABILITY_ON_CD:
			reason_text = ability.name + " is on cooldown."
		lv.ReasonCannotBeginJob.CURRENTLY_CASTING:
			reason_text = "Already casting."
	
	var output_texts := [{
		"text": reason_text,
		"color": Color(1, 0, 0),
	}]
	
	var parent_node = lv.lored[lv.Type.BLOOD].vico.healing_event.hotbar.get_node("%Texts")
	gv.throwOutputTexts(output_texts, parent_node)


func cast_ability_at_target(ability: UnitAbility, target: Unit) -> void:
	if is_casting():
		if get_cast_time_remaining_in_msec(healer.abilities[casting].get_cast_time_as_float()) < 500:
			queue_cast_ability_at_target(ability, target)
		else:
			cannot_cast_ability(lv.ReasonCannotBeginJob.CURRENTLY_CASTING)
		return
	
	clear_queue()
	
	time_when_cast_begun = OS.get_ticks_msec()
	var cast_time = ability.get_cast_time_as_float()
	vico.castbar_start(cast_time, time_when_cast_begun)
	casting = ability.type
	updateStatus("Casting " + ability.name + " on " + target.name + ".")
	target.vico.show_main_target_border()
	
	ability.just_cast = true
	
	gv.emit_global_cooldown(time_when_cast_begun)
	
	last_target = target
	last_ability = ability
	
	if ability.has_cast_time:
		ability.vico.show_casting_border()
		
		cast_pass = OS.get_ticks_msec()
		var my_pass = cast_pass
		cast_timer.start(cast_time)
		
		yield(cast_timer, "timeout")
		
		if my_pass != cast_pass:
			return
	
	ability.takeaway_costs(target)
	
	updateStatus("")
	
	stop_casting()
	ability.apply_effects(target)
	ability.start_cooldown()
	ability.just_cast = false
	
	if ability.is_instant_cast():
		ability.vico.flash_casting_border()
	
	cast_queued_ability_if_applicable()


func get_cast_time_remaining_in_msec(ability_cast_time: float) -> float:
	ability_cast_time *= 1000
	return abs(OS.get_ticks_msec() - (time_when_cast_begun + ability_cast_time))


func cast_queued_ability_if_applicable() -> void:
	if queue_cast.empty():
		return
	if queue_cast["ability"].is_on_cooldown:
		if queue_cast["ability"].get_cooldown_remaining() > 0.05:
			clear_queue()
			return
	cast_ability_at_target(queue_cast["ability"], queue_cast["target"])


func queue_cast_ability_at_target(ability: UnitAbility, target: Unit) -> void:
	clear_queue()
	queue_cast["ability"] = ability
	queue_cast["target"] = target


func clear_queue() -> void:
	queue_cast = {}


func is_casting() -> bool:
	return casting > -1


func interrupt_and_cancel_cast() -> void:
	if not is_casting():
		return
	gv.cancel_gcd()
	stop_casting()


func stop_casting() -> void:
	if not is_casting():
		return
	updateStatus("")
	last_ability.vico.hide_casting_border()
	last_target.vico.hide_main_target_border()
	cast_timer.stop()
	casting = -1
	vico.stop_casting()


func add_status_effects_to_unit_tooltip(unit: Unit, buff: UnitStatusEffect) -> void:
	if not unit_tooltip_exists():
		return
	if rt.get_node("global_tip").tip.cont.unit != unit:
		return
	rt.get_node("global_tip").tip.cont.add_status_effect_vico(buff)


func unit_tooltip_exists() -> bool:
	if not rt.get_node("global_tip").tip_filled:
		return false
	if rt.get_node("global_tip").type != "tooltip/Unit":
		return false
	return true
