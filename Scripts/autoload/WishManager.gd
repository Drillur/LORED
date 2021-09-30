extends Node

# access with taq

const path1 := "/root/Root/WishAnchor/m/v/"
onready var gn_random_wishes = get_node(path1 + "random")
onready var gn_main_wishes = get_node(path1 + "main")

var wish: Array

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
]

var checkpoint := 0 # used for quicker code in getSelectedWish()
var random_wishes := 0
var max_random_wishes := 0

var recently_reset := false


func save() -> String:
	
	var data := {}
	
	data["wishes"] = var2str(wish.size())
	
	data["completed_wishes"] = var2str(completed_wishes)
	data["checkpoint"] = var2str(checkpoint)
	
	for w in wish.size():
		var _key = "wish" + str(w)
		data[_key] = var2str(wish[w].save())
	
	return var2str(data)

func _load(data_string: String):
	
	var data = str2var(data_string)
	
	completed_wishes = str2var(data["completed_wishes"])
	checkpoint = str2var(data["checkpoint"])
	
	for w in str2var(data["wishes"]):
		var _key = "wish" + str(w)
		newWish("load", str2var(data[_key]))
	
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


func increaseProgress(type: int, key: String, amount = 1):
	for w in wish:
		w.increaseCount(type, key, amount)



func newWish(key: String, data: Dictionary = {}):
	
	var i = wish.size()
	wish.append(Wish.new(key, data))
	
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
		gn_main_wishes.add_child(manager) #note fix
		gn_main_wishes.move_child(manager, 0)
	hideOrDisplayMainWishes()

func wishCompleted(_wish: Wish):
	completed_wishes.append(_wish.key)
	adjustCheckpointBasedOnCompletedQuest(_wish.key)

func wishDied(_wish: Wish):
	_wish.vico.queue_free()
	wish.erase(_wish)
	active_wish_keys.erase(_wish.key)
	hideOrDisplayMainWishes()
	
func hideOrDisplayMainWishes():
	if gn_main_wishes.get_child_count() == 0:
		gn_main_wishes.hide()
	else:
		gn_main_wishes.show()


func adjustCheckpointBasedOnCompletedQuest(key: String):
	match key:
		"joy2", "upgrade_name":
			if "joy2" in completed_wishes and "upgrade_name" in completed_wishes:
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
	
	while not recently_reset:
		
		var t = Timer.new()
		add_child(t)
		t.start(rand_range(5, 10))
		yield(t, "timeout")
		t.queue_free()
		
		var selected_wish: String = getSelectedWish()
		
		if selected_wish in ["r", "n"]:
			if random_wishes >= max_random_wishes:
				continue
			selected_wish = "random"
		
		newWish(selected_wish)
	
	recently_reset = false

func getSelectedWish() -> String:
	
	# return "r": retry
	# return "n": none appropriate
	
	var try := []
	
	match checkpoint:
		10:
			try.append("joy2")
			try.append("upgrade_name")
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
	
	while not wish.ready:
		
		var lored_key = wish.obj.key
		
		if not gv.g[lored_key].working:
			wish.setCount(Big.new(wish.obj.current_count).a(1))
		
		if wish.ready:
			if gv.g[wish.obj.key].halt and not was_already_halted:
				gv.g[wish.obj.key].manager.halt()
		
		var t = Timer.new()
		add_child(t)
		t.start(1)
		yield(t, "timeout")
		t.queue_free()

func hoardManager(wish: Wish):
	
	var was_already_holding: bool = gv.g[wish.obj.key].hold
	
	while not wish.ready:
		
		var lored_key = wish.obj.key
		
		if gv.g[lored_key].hold:
			wish.setCount(Big.new(wish.obj.current_count).a(1))
		
		if wish.ready:
			if gv.g[wish.obj.key].hold and not was_already_holding:
				gv.g[wish.obj.key].manager.hold()
		
		var t = Timer.new()
		add_child(t)
		t.start(1)
		yield(t, "timeout")
		t.queue_free()
