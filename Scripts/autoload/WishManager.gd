class_name WishManager
extends Node

# access with taq

var saved_vars := ["checkpoint", "wishes", "completed_wishes"]

var gn_random_wishes: VBoxContainer
var gn_main_wishes: VBoxContainer

var wish: Array
var wishes := 0

var active_wish_keys := []
var completed_wishes := []
var key_wish_keys := [
	"grinder",
	"collection",
	"upgrade_stone",
	"upgrades",
	"joy",
	"rye",
	"sand",
	"malignancy",
	"joy2",
	"a_new_leaf",
	"waterbuddy",
	"liqy",
	"gramma",
	"woody",
	"hardy",
	"axy",
	"treey",
	"joy3",
	"horsey",
	"steely",
	"galey",
	"papey",
	"plasty",
	"tumory",
	"easier",
	"autocomplete",
]

var checkpoint := 0 # used for quicker code in getSelectedWish()
var random_wishes := 0
var max_random_wishes := 0

var seeking := false
var recently_reset := false

var easier := false # set in Wish.reward
var automatedSleep := false # set in Wish.reward
var automatedCompletion := false # set in Wish.reward




func turn_in_all_wishes_automatically():
	if automatedCompletion:
		for w in wish:
			if w.random:
				if w.ready:
					w.turnIn()

func save() -> String:
	
	var data := {}
	
	for x in saved_vars:
		if get(x) is Big:
			data[x] = get(x).save()
		else:
			data[x] = var2str(get(x))
	
	data["wish data"] = {}
	for x in wishes:
		data["wish data"][x] = wish[x].save()
	
	return var2str(data)

func load(data: Dictionary):
	
	for x in saved_vars:
		
		if not x in data.keys():
			continue
		
		if get(x) is Big:
			get(x).load(data[x])
		else:
			set(x, str2var(data[x]))
	
	var wish_count = wishes
	for x in wish_count:
		newWish("load", str2var(data["wish data"][x]))
	
	# give rewards for completed key wishes
	for w in key_wish_keys:
		if not w in completed_wishes:
			continue
		for r in Wish.new(w).key_rew:
			r.turnIn()
	
	if "veryLowCoal" in active_wish_keys:
		gv.emit_signal("manualLabor")


func reset(reset_type: int):
	
	if reset_type == -1:
		
		for w in wish:
			w.die(false)
			#wishDied(w) #note might not be needed
		wish.clear()
		updateWishCount()
		
		active_wish_keys.clear()
		completed_wishes.clear()
		checkpoint = 0
		
		recently_reset = true
		
		var t = Timer.new()
		add_child(t)
		t.start(10)
		yield(t, "timeout")
		t.queue_free()
		
		seekNewWish()
		
		return
	
	var i = 0
	while true:
		
		if wish.size() - 1 < i:
			break
		
		var _wish = wish[i]
		
		if not _wish.random:
			i += 1
			continue
		
		_wish.die(false)
		wishDied(_wish)

func close():
	# scene changed. #002
	wish.clear()
	updateWishCount()
	active_wish_keys.clear()
	completed_wishes.clear()
	checkpoint = 0
	max_random_wishes = 0
	automatedSleep = false


func setupGNNodes():
	# called from Root #001
	gn_main_wishes = get_node("/root/Root/%mainWish")
	gn_random_wishes = get_node("/root/Root/%randomWish")


func increaseProgress(type: int, key: String, amount = 1):
	for w in wish:
		w.increaseCount(type, key, amount)



func newWish(key: String, data: Dictionary = {}):
	
	var i = wish.size()
	wish.append(Wish.new(key, data))
	updateWishCount()
	
	WishLogManager.log(wish[i])
	#instanceWishVico(wish[i])
	
	active_wish_keys.append(wish[i].key)
	
	if wish[i].random:
		random_wishes += 1
	
	match wish[i].obj.type:
		gv.Objective.MAXED_FUEL_STORAGE:
			maxedFuelStorageManager(wish[i])
		gv.Objective.BREAK:
			sleepManager(wish[i])

func instanceWishVico(_wish: Wish):
	var manager = gv.SRC["wish vico"].instance()
	manager.setup(_wish, false)
	if _wish.random:
		gn_random_wishes.add_child(manager)
		gn_random_wishes.move_child(manager, 0)
	else:
		gn_main_wishes.add_child(manager)
		gn_main_wishes.move_child(manager, 0)
	hideOrDisplayMainWishes()

func wishCompleted(_wish: Wish):
	emoteEvent(_wish)
	completed_wishes.append(_wish.key)
	adjustCheckpointBasedOnCompletedQuest(_wish.key)

func wishDied(_wish: Wish):
	wish.erase(_wish)
	updateWishCount()
	active_wish_keys.erase(_wish.key)
	hideOrDisplayMainWishes()
	
func hideOrDisplayMainWishes():
	if gn_main_wishes.get_child_count() == 0:
		gn_main_wishes.hide()
	else:
		gn_main_wishes.show()


func adjustCheckpointBasedOnCompletedQuest(key: String):
	match key:
		"to_da_limit":
			checkpoint = 26
		"easier", "autocomplete":
			if "easier" in completed_wishes and "autocomplete" in completed_wishes:
				checkpoint = 25
		"tumory", "maliggy", "ciorany":
			if "tumory" in completed_wishes and "maliggy" in completed_wishes and "ciorany" in completed_wishes:
				checkpoint = 24
		"carcy":
			checkpoint = 23
		"papey", "plasty":
			if "papey" in completed_wishes and "plasty" in completed_wishes:
				checkpoint = 22
		"galey":
			checkpoint = 21
		"joy3", "steely", "horsey":
			if "joy3" in completed_wishes and "steely" in completed_wishes and "horsey" in completed_wishes:
				checkpoint = 20
		"treey":
			checkpoint = 19
		"woody", "hardy", "axy":
			if "woody" in completed_wishes and "hardy" in completed_wishes and "axy" in completed_wishes:
				checkpoint = 18
		"gramma":
			checkpoint = 17
		"liqy":
			checkpoint = 16
		"waterbuddy":
			checkpoint = 15
		"joy2", "a_new_leaf":
			if "joy2" in completed_wishes and "a_new_leaf" in completed_wishes:
				checkpoint = 14
		"soccer_dude":
			checkpoint = 13
		"malignancy":
			checkpoint = 12
		"sand":
			checkpoint = 11
		"rye":
			checkpoint = 10
		"jobs":
			checkpoint = 9
		"joy":
			checkpoint = 8
		"grinder":
			checkpoint = 7
		"upgrades":
			checkpoint = 6
		"test_sleep":
			checkpoint = 5
		"upgrade_stone", "importance_of_coal":
			if "upgrade_stone" in completed_wishes and "importance_of_coal" in completed_wishes:
				checkpoint = 4
		"collection":
			checkpoint = 3
		"fuel":
			checkpoint = 2
		"stuff":
			checkpoint = 1

func seekNewWish():
	
	if seeking:
		return
	
	seeking = true
	
	while not recently_reset:
		
		var t = Timer.new()
		add_child(t)
		t.start(rand_range(1, 5))
		yield(t, "timeout")
		t.queue_free()
		
		if gv.active_scene != gv.Scene.ROOT:
			seeking = false
			return
		
		var selected_wish: String = getSelectedWish()
		
		if selected_wish in ["r", "n"]:
			if random_wishes >= max_random_wishes:
				continue
			selected_wish = "random"
		
		newWish(selected_wish)
	
	recently_reset = false
	
	seeking = false

func getSelectedWish() -> String:
	
	# return "r": retry
	# return "n": none appropriate
	
	var try := []
	match checkpoint:
		25:
			try.append("to_da_limit")
		24:
			try.append("easier")
			try.append("autocomplete")
		23:
			try.append("tumory")
			try.append("maliggy")
			try.append("ciorany")
		22:
			try.append("carcy")
		21:
			try.append("papey")
			try.append("plasty")
		20:
			try.append("galey")
		19:
			try.append("joy3")
			try.append("steely")
			try.append("horsey")
		18:
			try.append("treey")
		17:
			try.append("woody")
			try.append("hardy")
			try.append("axy")
		16:
			try.append("gramma")
		15:
			try.append("liqy")
		14:
			try.append("waterbuddy")
		13:
			try.append("joy2")
			try.append("a_new_leaf")
		12:
			try.append("soccer_dude")
		11:
			try.append("malignancy")
		10:
			try.append("sand")
		9:
			try.append("rye")
		8:
			try.append("jobs")
		7:
			try.append("joy")
		6:
			try.append("grinder")
		5:
			try.append("upgrades")
		4:
			try.append("test_sleep")
		3:
			try.append("importance_of_coal")
			try.append("upgrade_stone")
		2:
			try.append("collection")
		1:
			try.append("fuel")
		0:
			if wishCompleteOrAlreadyActive("stuff"):
				return "n"
			if not lv.lored[lv.Type.COAL].purchased:
				return "stuff"
			checkpoint = 1
			gv.stats["WishMain"] += 1
			gv.emit_signal("statChanged", "WishMain")
			return "r"
	
	if gv.resource[gv.Resource.COAL].less(Big.new(lv.lored[lv.Type.COAL].output).m(30)):
		if not "veryLowCoal" in active_wish_keys and not gv.manualLaborActive:
			var job_required_fuel = lv.lored[lv.Type.COAL].lored.jobs.values()[0].requiredFuel
			var minimum_fuel = Big.new(job_required_fuel).m(2)
			if lv.lored[lv.Type.COAL].currentFuel.less(minimum_fuel) and not lv.lored[lv.Type.COAL].working:
				return "veryLowCoal"
	
	if gv.list.lored["unlocked and inactive"].size() > 0:
		return "r"
	
	for t in try:
		if not wishCompleteOrAlreadyActive(t):
			return t
	
	return "n"

func wishCompleteOrAlreadyActive(key: String) -> bool:
	if key in completed_wishes:
		return true
	if key in active_wish_keys:
		return true
	return false


func emoteEvent(_wish: Wish):
	match _wish.key:
		"fuel":
			EmoteManager.emote(EmoteManager.Type.STONE_HAPPY)


func maxedFuelStorageManager(_wish: Wish):
	
	var t = Timer.new()
	add_child(t)
	
	while not _wish.ready and _wish.exists:
		
		if gv.active_scene != gv.Scene.ROOT:
			break
		
		var lored_key = int(_wish.obj.key)
		var fuel_percentage = Big.new(lv.lored[lored_key].currentFuelPercent).m(100)
		
		_wish.setCount(fuel_percentage)
		
		t.start(0.1)
		yield(t, "timeout")
	
	t.queue_free()

func sleepManager(_wish: Wish):
	
	var lored: LOREDManager = lv.lored[_wish.objKey()]
	var was_already_halted: bool = lored.asleep
	
	if automatedSleep:
		lored.putToSleep()
	
	while not _wish.ready:
		
		if gv.active_scene == gv.Scene.MAIN_MENU:
			return
		
		#var lored_key = int(_wish.obj.key)
		
		if not lored.working and lored.asleep:
			_wish.setCount(Big.new(_wish.obj.current_count).a(1))
		
		if _wish.ready or not _wish.exists:
			if lored.asleep and not was_already_halted:
				lored.wakeUp()
				lored.vico.updateSleepButton()
				return
		
		var t = Timer.new()
		add_child(t)
		t.start(1)
		yield(t, "timeout")
		t.queue_free()



func updateWishCount():
	wishes = wish.size()


# - - - Handy

func getWishStat(objectiveType: int, key = "") -> String:
	match objectiveType:
		gv.Objective.RESOURCES_PRODUCED:
			if key == str(gv.Resource.JOY):
				return "Joy Collection"
			elif key == str(gv.Resource.GRIEF):
				return "Grief Collection"
			else:
				return "Random Resource"
		gv.Objective.LORED_UPGRADED:
			return "Level Up"
		gv.Objective.UPGRADE_PURCHASED:
			return "Buy Upgrade"
		gv.Objective.MAXED_FUEL_STORAGE:
			return "Refuel"
		gv.Objective.BREAK:
			return "Sleep"
		gv.Objective.LIMIT_BREAK_LEVEL:
			return "Limit Break"
	
	print_debug("fail: getWishStat() in WishManager")
	return "oops!"

func populateMainScreenVicos():
	for w in wish:
		instanceWishVico(w)

func deleteMainScreenVicos():
	for w in wish:
		var i = -1
		for v in w.vico:
			i += 1
			if v.inLog:
				continue
			v.queue_free()
			break
		w.vico.remove(i)
