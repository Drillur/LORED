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
var automatedHaltAndHold := false # set in Wish.reward
var automatedCompletion := false # set in Wish.reward




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


func reset(reset_type: int):
	
	if reset_type == -1:
		
		for w in wish:
			w.die(false)
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


func close():
	# scene changed. #002
	wish.clear()
	active_wish_keys.clear()
	completed_wishes.clear()


func setupGNNodes():
	# called from Root #001
	gn_main_wishes = get_node("/root/Root/WishAnchor/m/v/main")
	gn_random_wishes = get_node("/root/Root/WishAnchor/m/v/random")


func increaseProgress(type: int, key: String, amount = 1):
	for w in wish:
		w.increaseCount(type, key, amount)



func newWish(key: String, data: Dictionary = {}):
	
	var i = wish.size()
	wish.append(Wish.new(key, data))
	updateWishCount()
	
	instanceWishVico(wish[i])
	
	active_wish_keys.append(wish[i].key)
	
	if wish[i].random:
		random_wishes += 1
	
	match wish[i].obj.type:
		gv.Objective.MAXED_FUEL_STORAGE:
			maxedFuelStorageManager(wish[i])
		gv.Objective.BREAK:
			breakManager(wish[i])
		gv.Objective.HOARD:
			hoardManager(wish[i])

func instanceWishVico(_wish: Wish):
	var manager = gv.SRC["wish vico"].instance()
	manager.setup(_wish)
	if _wish.random:
		gn_random_wishes.add_child(manager)
		gn_random_wishes.move_child(manager, 0)
	else:
		gn_main_wishes.add_child(manager)
		gn_main_wishes.move_child(manager, 0)
	hideOrDisplayMainWishes()

func wishCompleted(_wish: Wish):
	completed_wishes.append(_wish.key)
	adjustCheckpointBasedOnCompletedQuest(_wish.key)

func wishDied(_wish: Wish):
	_wish.vico.queue_free()
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
		"easier", "autocomplete":
			if "easier" in completed_wishes and "autocomplete" in completed_wishes:
				checkpoint = 22
		"tumory", "maliggy", "ciorany":
			if "tumory" in completed_wishes and "maliggy" in completed_wishes and "ciorany" in completed_wishes:
				checkpoint = 21
		"carcy":
			checkpoint = 20
		"papey", "plasty":
			if "papey" in completed_wishes and "plasty" in completed_wishes:
				checkpoint = 19
		"galey":
			checkpoint = 18
		"joy3", "steely", "horsey":
			if "joy3" in completed_wishes and "steely" in completed_wishes and "horsey" in completed_wishes:
				checkpoint = 17
		"treey":
			checkpoint = 16
		"woody", "hardy", "axy":
			if "woody" in completed_wishes and "hardy" in completed_wishes and "axy" in completed_wishes:
				checkpoint = 15
		"gramma":
			checkpoint = 14
		"liqy":
			checkpoint = 13
		"waterbuddy":
			checkpoint = 12
		"joy2", "a_new_leaf":
			if "joy2" in completed_wishes and "a_new_leaf" in completed_wishes:
				checkpoint = 11
		"soccer_dude":
			checkpoint = 10
		"malignancy":
			checkpoint = 9
		"sand":
			checkpoint = 8
		"rye":
			checkpoint = 7
		"joy":
			checkpoint = 6
		"grinder":
			checkpoint = 5
		"upgrades":
			checkpoint = 4
		"upgrade_stone", "importance_of_coal":
			if "upgrade_stone" in completed_wishes and "importance_of_coal" in completed_wishes:
				checkpoint = 3
		"collection", "fuel":
			if "fuel" in completed_wishes and "collection" in completed_wishes:
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
		t.start(rand_range(5, 10))
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
		21:
			try.append("easier")
			try.append("autocomplete")
		20:
			try.append("tumory")
			try.append("maliggy")
			try.append("ciorany")
		19:
			try.append("carcy")
		18:
			try.append("papey")
			try.append("plasty")
		17:
			try.append("galey")
		16:
			try.append("joy3")
			try.append("steely")
			try.append("horsey")
		15:
			try.append("treey")
		14:
			try.append("woody")
			try.append("hardy")
			try.append("axy")
		13:
			try.append("gramma")
		12:
			try.append("liqy")
		11:
			try.append("waterbuddy")
		10:
			try.append("joy2")
			try.append("a_new_leaf")
		9:
			try.append("soccer_dude")
		8:
			try.append("malignancy")
		7:
			try.append("sand")
		6:
			try.append("rye")
		5:
			try.append("joy")
		4:
			try.append("grinder")
		3:
			try.append("upgrades")
		2:
			try.append("importance_of_coal")
			try.append("upgrade_stone")
		1:
			try.append("fuel")
			try.append("collection")
		0:
			if wishCompleteOrAlreadyActive("stuff"):
				return "n"
			if not gv.g["coal"].active:
				return "stuff"
			checkpoint = 1
			return "r"
	
	#note THIS CANNOT BE COMMENTED OUT. if it's not, erase this comment i guess
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


func maxedFuelStorageManager(wish: Wish):
	
	while not wish.ready and wish.exists:
		
		var lored_key = wish.obj.key
		var fuel_percentage = Big.new(gv.g[lored_key].f.f.percent(gv.g[lored_key].f.t)).m(100)
		
		wish.setCount(fuel_percentage)
		
		var t = Timer.new()
		add_child(t)
		t.start(0.1)
		yield(t, "timeout")
		t.queue_free()

func breakManager(wish: Wish):
	
	var was_already_halted: bool = gv.g[wish.obj.key].halt
	
	if automatedHaltAndHold:
		gv.g[wish.obj.key].manager.halt(true)
	
	while not wish.ready:
		
		if gv.active_scene == gv.Scene.MAIN_MENU:
			return
		
		var lored_key = wish.obj.key
		
		if not gv.g[lored_key].working:
			wish.setCount(Big.new(wish.obj.current_count).a(1))
		
		if wish.ready or not wish.exists:
			if gv.g[wish.obj.key].halt and not was_already_halted:
				gv.g[wish.obj.key].manager.halt()
				return
		
		var t = Timer.new()
		add_child(t)
		t.start(1)
		yield(t, "timeout")
		t.queue_free()

func hoardManager(wish: Wish):
	
	var was_already_holding: bool = gv.g[wish.obj.key].hold
	
	if automatedHaltAndHold:
		gv.g[wish.obj.key].manager.hold(true)
	
	while not wish.ready:
		
		if gv.active_scene == gv.Scene.MAIN_MENU:
			return
		
		var lored_key = wish.obj.key
		
		if gv.g[lored_key].hold:
			wish.setCount(Big.new(wish.obj.current_count).a(1))
		
		if wish.ready or not wish.exists:
			if gv.g[wish.obj.key].hold and not was_already_holding:
				gv.g[wish.obj.key].manager.hold()
				return
			
		var t = Timer.new()
		add_child(t)
		t.start(1)
		yield(t, "timeout")
		t.queue_free()



func updateWishCount():
	wishes = wish.size()
	
