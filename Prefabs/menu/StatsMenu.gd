extends MarginContainer

var noticesShown := {}

var lored0 := {}
var TimesLeveledUp := {"manual": {}, "automated": {}}
var TimesRefueled := {}
var OtherJobs := {}
var AnimationsPlayed := {}
var TimeAsleep := {}
var Crits := {}

onready var WishMain = get_node("%WishMain")
onready var WishGranted = get_node("%WishGranted")
onready var WishDenied = get_node("%WishDenied")

var lored1 := {}
var WishStats := {}
var LOREDGranted := {}
var LOREDDenied := {}

var upgrade0 := {}
var UpgradesPurchased := {}

var resource0 := {}
var ResourceCollected := {}
var ResourceUsed := {}
var ResourceSpent := {}

onready var CurSess := get_node("%CurSess")
onready var TotalTime := get_node("%TotalTime")
var RunReset := {}
var RunQuickest := {}
var RunLongest := {}


func _ready():
	gv.connect("stats_unlockTab", self, "unlockTab")
	gv.connect("stats_unlockResource", self, "unlockResource")
	gv.connect("stats_unlockRuns", self, "unlockRuns")
	gv.connect("TimesLeveledUp", self, "updateTimesLeveledUp")
	gv.connect("AnimationsPlayed", self, "updateAnimationsPlayed")
	gv.connect("OtherJobs", self, "updateOtherJobs")
	gv.connect("TimesRefueled", self, "updateTimesRefueled")
	gv.connect("TimeAsleep", self, "updateTimeAsleep")
	gv.connect("Crits", self, "updateCrits")
	gv.connect("statChanged", self, "updateStat")
	gv.connect("statChanged2", self, "updateStat2")
	gv.connect("LOREDGranted", self, "updateLOREDGranted")
	gv.connect("LOREDDenied", self, "updateLOREDDenied")
	gv.connect("UpgradesPurchased", self, "updateUpgradesPurchased")
	gv.connect("ResourceCollected", self, "updateResourceCollected")
	gv.connect("ResourceUsed", self, "updateResourceUsed")
	gv.connect("ResourceSpent", self, "updateResourceSpent")
	gv.connect("Reset", self, "updateRunReset")
	gv.connect("stats_unlockLOREDStats", self, "unlockLOREDStats")



# - - - Setup

func setup():
	updateCurSess()
	setupLORED()
	setupStats2()
	setupStats3()
	setupUp0()
	setupResource0()
	setupGeneral0()
	hideAllSpoilers()

func setupLORED():
	
	for x in lv.lored:
		
		lored0[x] = gv.SRC["earnings report/resource"].instance()
		lored0[x].get_node("%icon").texture = lv.lored[x].icon
		lored0[x].get_node("%shadow").texture = lored0[x].get_node("%icon").texture
		lored0[x].get_node("%resource").text = lv.lored[x].name
		lored0[x].get_node("%resource").self_modulate = lv.lored[x].color
		get_node("%LORED").add_child(lored0[x])
		
		TimesLeveledUp["manual"][x] = gv.SRC["labels/medium label"].instance()
		TimesLeveledUp["manual"][x].self_modulate = lv.lored[x].color
		TimesLeveledUp["manual"][x].text = "0"
		TimesLeveledUp["manual"][x].align = Label.ALIGN_CENTER
		get_node("%LORED").add_child(TimesLeveledUp["manual"][x])
		
		TimesLeveledUp["automated"][x] = gv.SRC["labels/medium label"].instance()
		TimesLeveledUp["automated"][x].self_modulate = lv.lored[x].color
		TimesLeveledUp["automated"][x].text = "0"
		TimesLeveledUp["automated"][x].align = Label.ALIGN_CENTER
		get_node("%LORED").add_child(TimesLeveledUp["automated"][x])
		
		TimesRefueled[x] = gv.SRC["labels/medium label"].instance()
		TimesRefueled[x].self_modulate = lv.lored[x].color
		TimesRefueled[x].text = "0"
		TimesRefueled[x].align = Label.ALIGN_CENTER
		get_node("%LORED").add_child(TimesRefueled[x])
		
		OtherJobs[x] = gv.SRC["labels/medium label"].instance()
		OtherJobs[x].self_modulate = lv.lored[x].color
		OtherJobs[x].text = "0"
		OtherJobs[x].align = Label.ALIGN_CENTER
		get_node("%LORED").add_child(OtherJobs[x])
		
		AnimationsPlayed[x] = gv.SRC["labels/medium label"].instance()
		AnimationsPlayed[x].self_modulate = lv.lored[x].color
		AnimationsPlayed[x].text = "0"
		AnimationsPlayed[x].align = Label.ALIGN_CENTER
		get_node("%LORED").add_child(AnimationsPlayed[x])
		
		TimeAsleep[x] = gv.SRC["labels/medium label"].instance()
		TimeAsleep[x].self_modulate = lv.lored[x].color
		TimeAsleep[x].text = "0s"
		TimeAsleep[x].align = Label.ALIGN_CENTER
		get_node("%LORED").add_child(TimeAsleep[x])
		
		Crits[x] = gv.SRC["labels/medium label"].instance()
		Crits[x].self_modulate = lv.lored[x].color
		Crits[x].text = "0"
		Crits[x].align = Label.ALIGN_CENTER
		get_node("%LORED").add_child(Crits[x])
		
		lored0[x].hide()
		TimesLeveledUp["manual"][x].hide()
		TimesLeveledUp["automated"][x].hide()
		TimesRefueled[x].hide()
		OtherJobs[x].hide()
		AnimationsPlayed[x].hide()
		TimeAsleep[x].hide()
		Crits[x].hide()

func setupStats2():
	
	for x in ["Level Up", "Random Resource", "Sleep", "Buy Upgrade", "Refuel", "Joy Collection", "Grief Collection"]:
		
		var type = gv.SRC["labels/medium label"].instance()
		type.text = x
		get_node("%stats2").add_child(type)
		
		WishStats[x] = {}
		
		for c in ["granted", "denied"]:
			WishStats[x][c] = gv.SRC["labels/medium label"].instance()
			WishStats[x][c].text = "0"
			WishStats[x][c].align = Label.ALIGN_CENTER
			get_node("%stats2").add_child(WishStats[x][c])

func setupStats3():
	
	for x in lv.lored:
		
		lored1[x] = gv.SRC["earnings report/resource"].instance()
		lored1[x].get_node("%icon").texture = lv.lored[x].icon
		lored1[x].get_node("%shadow").texture = lored1[x].get_node("%icon").texture
		lored1[x].get_node("%resource").text = lv.lored[x].name
		lored1[x].get_node("%resource").self_modulate = lv.lored[x].color
		get_node("%stats3").add_child(lored1[x])
		
		LOREDGranted[x] = gv.SRC["labels/medium label"].instance()
		LOREDGranted[x].text = "0"
		LOREDGranted[x].align = Label.ALIGN_CENTER
		LOREDGranted[x].self_modulate = lv.lored[x].color
		get_node("%stats3").add_child(LOREDGranted[x])
		
		LOREDDenied[x] = gv.SRC["labels/medium label"].instance()
		LOREDDenied[x].text = "0"
		LOREDDenied[x].align = Label.ALIGN_CENTER
		LOREDDenied[x].self_modulate = lv.lored[x].color
		get_node("%stats3").add_child(LOREDDenied[x])
		
		lored1[x].hide()
		LOREDGranted[x].hide()
		LOREDDenied[x].hide()
		
		updateLOREDGranted(x)
		updateLOREDDenied(x)

func setupUp0():
	
	for x in gv.Tab.values():
		
		if x == gv.Tab.S1:
			break
		
		upgrade0[x] = gv.SRC["earnings report/resource"].instance()
		upgrade0[x].get_node("%icon").texture = gv.sprite[str(x)]
		upgrade0[x].get_node("%shadow").texture = upgrade0[x].get_node("%icon").texture
		upgrade0[x].get_node("%resource").text = gv.upgradeTierByTab(x)
		upgrade0[x].get_node("%resource").self_modulate = gv.COLORS[str(x)]
		get_node("%Up0").add_child(upgrade0[x])
		
		UpgradesPurchased[x] = gv.SRC["labels/medium label"].instance()
		UpgradesPurchased[x].text = "0"
		UpgradesPurchased[x].align = Label.ALIGN_CENTER
		UpgradesPurchased[x].self_modulate = gv.COLORS[str(x)]
		get_node("%Up0").add_child(UpgradesPurchased[x])
		
		upgrade0[x].hide()
		UpgradesPurchased[x].hide()

func setupResource0():
	
	for resource in gv.Resource.values():
		
		resource0[resource] = gv.SRC["earnings report/resource"].instance()
		resource0[resource].get_node("%icon").texture = gv.sprite[gv.shorthandByResource[resource]]
		resource0[resource].get_node("%shadow").texture = resource0[resource].get_node("%icon").texture
		resource0[resource].get_node("%resource").text = gv.resourceName[resource]
		resource0[resource].get_node("%resource").self_modulate = gv.COLORS[gv.shorthandByResource[resource]]
		get_node("%Resource0").add_child(resource0[resource])
		
		ResourceCollected[resource] = gv.SRC["labels/medium label"].instance()
		ResourceCollected[resource].text = "0"
		ResourceCollected[resource].align = Label.ALIGN_CENTER
		ResourceCollected[resource].self_modulate = gv.COLORS[gv.shorthandByResource[resource]]
		get_node("%Resource0").add_child(ResourceCollected[resource])
		
		ResourceUsed[resource] = gv.SRC["labels/medium label"].instance()
		ResourceUsed[resource].text = "0"
		ResourceUsed[resource].align = Label.ALIGN_CENTER
		ResourceUsed[resource].self_modulate = gv.COLORS[gv.shorthandByResource[resource]]
		get_node("%Resource0").add_child(ResourceUsed[resource])
		
		ResourceSpent[resource] = gv.SRC["labels/medium label"].instance()
		ResourceSpent[resource].text = "0"
		ResourceSpent[resource].align = Label.ALIGN_CENTER
		ResourceSpent[resource].self_modulate = gv.COLORS[gv.shorthandByResource[resource]]
		get_node("%Resource0").add_child(ResourceSpent[resource])
		
		resource0[resource].hide()
		ResourceCollected[resource].hide()
		ResourceUsed[resource].hide()
		ResourceSpent[resource].hide()

func setupGeneral0():
	
	for x in [gv.Tab.S1, gv.Tab.S2, gv.Tab.S3, gv.Tab.S4]:
		
		var stage = gv.SRC["earnings report/resource"].instance()
		stage.get_node("%icon").texture = gv.sprite[str(x)]
		stage.get_node("%shadow").texture = stage.get_node("%icon").texture
		stage.get_node("%resource").text = str(x - gv.Tab.S1 + 1)
		stage.get_node("%resource").self_modulate = gv.COLORS[str(x)]
		get_node("%run").add_child(stage)
		
		RunReset[x] = gv.SRC["labels/medium label"].instance()
		RunReset[x].text = "0"
		RunReset[x].align = Label.ALIGN_CENTER
		RunReset[x].self_modulate = gv.COLORS[str(x)]
		get_node("%run").add_child(RunReset[x])
		
		RunQuickest[x] = gv.SRC["labels/medium label"].instance()
		RunQuickest[x].text = "0"
		RunQuickest[x].align = Label.ALIGN_CENTER
		RunQuickest[x].self_modulate = gv.COLORS[str(x)]
		get_node("%run").add_child(RunQuickest[x])
		
		RunLongest[x] = gv.SRC["labels/medium label"].instance()
		RunLongest[x].text = "0"
		RunLongest[x].align = Label.ALIGN_CENTER
		RunLongest[x].self_modulate = gv.COLORS[str(x)]
		get_node("%run").add_child(RunLongest[x])



# - - - Buttons

var queue := []
func queue(a: String, b = -1, c = -1):
	if int(c) == -1:
		if [a, b] in queue:
			return
		queue.append([a, b])
	else:
		if [a, b, c] in queue:
			return
		queue.append([a, b, c])

func _on_StatsMenu_visibility_changed() -> void:
	if not visible:
		return
	for item in queue:
		if item is Array:
			if item.size() == 2:
				call("update" + item[0], item[1])
			else:
				call("update" + item[0], item[1], item[2])
		else:
			call("update" + item)
	queue.clear()
	
	if get_node("%Sessions").text == "-1":
		get_node("%Sessions").text = fval.f(gv.times_game_loaded)


# - - - Update

func updateTimesLeveledUp(manual: String, lored: int):
	if not visible:
		queue("TimesLeveledUp", manual, lored)
		return
	TimesLeveledUp[manual][lored].text = fval.f(gv.stats["TimesLeveledUp"][manual][lored])
func updateAnimationsPlayed(lored: int):
	if not visible:
		queue("AnimationsPlayed", lored)
		return
	AnimationsPlayed[lored].text = fval.f(gv.stats["AnimationsPlayed"][lored])
func updateTimesRefueled(lored: int):
	if not visible:
		queue("TimesRefueled", lored)
		return
	TimesRefueled[lored].text = fval.f(gv.stats["TimesRefueled"][lored])
func updateOtherJobs(lored: int):
	if not visible:
		queue("OtherJobs", lored)
		return
	OtherJobs[lored].text = fval.f(gv.stats["OtherJobs"][lored])
func updateTimeAsleep(lored: int):
	if not visible:
		queue("TimeAsleep", lored)
		return
	var text = gv.parse_time_float(gv.stats["TimeAsleep"][lored])
	TimeAsleep[lored].text = "-" if text == "!" else text
func updateCrits(lored: int):
	if not visible:
		queue("Crits", lored)
		return
	var crits = gv.stats["Crits"][lored]
	Crits[lored].text = fval.f(crits) + " (" + fval.f((float(crits) / max(gv.stats["OtherJobs"][lored], 1)) * 100) + "%)"

func updateStat(stat: String):
	if not visible:
		queue("Stat", stat)
		return
	if get(stat) is Label:
		get(stat).text = fval.f(gv.stats[stat])
	else:
		get(stat).get_node("%resource").text = fval.f(gv.stats[stat])
func updateStat2(stat: String, type: String):
	if not visible:
		queue("Stat2", stat, type)
		return
	WishStats[stat][type].text = fval.f(gv.stats["WishStats"][stat][type])

func updateLOREDGranted(lored: int):
	if not visible:
		queue("LOREDGranted", lored)
		return
	LOREDGranted[lored].text = fval.f(gv.stats["LOREDGranted"][lored])
func updateLOREDDenied(lored: int):
	if not visible:
		queue("LOREDDenied", lored)
		return
	LOREDDenied[lored].text = fval.f(gv.stats["LOREDDenied"][lored])
func updateUpgradesPurchased(tier: int):
	if not visible:
		queue("UpgradesPurchased", tier)
		return
	UpgradesPurchased[tier].text = fval.f(gv.stats["UpgradesPurchased"][tier])
func updateResourceCollected(resource: int):
	if not visible:
		queue("ResourceCollected", resource)
		return
	ResourceCollected[resource].text = gv.stats["ResourceStats"]["collected"][resource].toString()
func updateResourceUsed(resource: int):
	if not visible:
		queue("ResourceUsed", resource)
		return
	ResourceUsed[resource].text = gv.stats["ResourceStats"]["used"][resource].toString()
func updateResourceSpent(resource: int):
	if not visible:
		queue("ResourceSpent", resource)
		return
	ResourceSpent[resource].text = gv.stats["ResourceStats"]["spent"][resource].toString()
func updateRunReset(stage: int):
	if not visible:
		queue("RunReset", stage)
		return
	RunReset[stage].text = fval.f(gv.get("run" + str(stage - gv.Tab.S1 + 1)) - 1)
	RunLongest[stage].text = gv.parse_time_float(gv.stats["Run"][stage]["longest"]).replace("!", "-")
	if gv.stats["Run"][stage]["quickest"] == 1000000000000:
		RunQuickest[stage].text = "-"
	else:
		RunQuickest[stage].text = gv.parse_time_float(gv.stats["Run"][stage]["quickest"])

func updateCurSess():
	var t = Timer.new()
	add_child(t)
	
	while not is_queued_for_deletion():
		t.start(1)
		yield(t,"timeout")
		CurSess.text = gv.parse_time_float(gv.cur_session)
		TotalTime.text = gv.parse_time_float(gv.time_played)
	
	t.queue_free()



func updateAll():
	for x in lv.lored:
		updateTimesLeveledUp("manual", x)
		updateTimesLeveledUp("automated", x)
		updateAnimationsPlayed(x)
		updateTimesRefueled(x)
		updateOtherJobs(x)
		updateTimeAsleep(x)
		updateCrits(x)
	
	for x in ["WishMain", "WishGranted", "WishDenied"]:
		updateStat(x)
	
	for x in ["Level Up", "Random Resource", "Sleep", "Buy Upgrade", "Refuel", "Joy Collection", "Grief Collection"]:
		for c in ["granted", "denied"]:
			updateStat2(x, c)
	
	for x in gv.Tab.values():
		if x == gv.Tab.S1:
			break
		updateUpgradesPurchased(x)
	
	for x in gv.Resource.values():
		updateResourceCollected(x)
		updateResourceUsed(x)
		updateResourceSpent(x)
	
	for x in [gv.Tab.S1, gv.Tab.S2, gv.Tab.S3, gv.Tab.S4]:
		updateRunReset(x)




# - - - Gate

func hideAllSpoilers():
	get_node("%Runs").hide()

func unlockRuns():
	get_node("%Runs").show()

func unlockLOREDStats(lored: int):
	if lored0[lored].visible:
		return
	lored0[lored].show()
	TimesLeveledUp["manual"][lored].show()
	TimesLeveledUp["automated"][lored].show()
	TimesRefueled[lored].show()
	OtherJobs[lored].show()
	AnimationsPlayed[lored].show()
	TimeAsleep[lored].show()
	Crits[lored].show()
	
	lored1[lored].show()
	LOREDGranted[lored].show()
	LOREDDenied[lored].show()

func unlockResource(resource: int):
	if resource0[resource].visible:
		return
	resource0[resource].show()
	ResourceCollected[resource].show()
	ResourceUsed[resource].show()
	ResourceSpent[resource].show()

func unlockTab(tab: int):
	if upgrade0[tab].visible:
		return
	upgrade0[tab].show()
	UpgradesPurchased[tab].show()
