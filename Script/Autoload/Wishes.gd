class_name Wishes
extends Node



var saved_vars := [
	"completed_wishes",
	"random_wish_limit",
	"completed_random_wishes",
	"wishes",
	"active_random_wishes",
]


func load_finished() -> void:
	for wish in wishes:
		new_pending_wish(wish)
	
	wish_ended.connect(find_new_main_wish)
	wish_ended.connect(find_new_random_wish)
	
	for i in random_wish_limit:
		find_new_random_wish()


signal wish_ended
signal wish_completed(type)
signal wish_uncompleted(type)

var wish_vico := preload("res://Hud/Wish/wish_vico.tscn")
var pending_wish_vico := preload("res://Hud/Wish/wish_pending.tscn")

var main_wish_container: VBoxContainer
var random_wish_container: VBoxContainer

var timers := {}

var active_wish_types := []
var active_random_wishes := 0

var wishes := []
var completed_wishes := []
var completed_random_wishes := 0
var random_wish_limit := 0:
	set(val):
		random_wish_limit = val



func _ready() -> void:
	SaveManager.connect("load_finished", load_finished)
	wish_ended.connect(find_new_main_wish)
	wish_ended.connect(find_new_random_wish)



func close() -> void:
	wish_ended.disconnect(find_new_main_wish)
	wish_ended.disconnect(find_new_random_wish)
	wishes.clear()
	active_wish_types.clear()
	uncomplete_all_wishes()
	random_wish_limit = 0
	active_random_wishes = 0
	completed_random_wishes = 0



func start() -> void:
	lv.purchased_every_lored_once.connect(find_new_main_wish)
	if not Wish.Type.STUFF in completed_wishes:
		print("STUFF STARTED")
		new_wish_considering_conditions(Wish.Type.STUFF)
	else:
		find_new_main_wish()



# - Actions

func find_new_main_wish(_nothing = null) -> void:
	if not lv.purchased_every_unlocked_lored_once():
		return
	if main_wish_container.get_child_count() > 0:
		return
	new_wish_considering_conditions(select_main_wish())


func new_wish_considering_conditions(type: int):
	if has_start_conditions(type):
		call("condition_" + Wish.get_key(type))
	else:
		new_wish(type)


func new_wish(type: int) -> void:
	var wish = Wish.new(type)
	wishes.append(wish)
	new_pending_wish(wish)
	if wish.has_pair():
		for x in wish.pair:
			if not is_wish_begun_or_completed(x):
				var paired_wish = Wish.new(x)
				wishes.append(paired_wish)
				new_pending_wish(paired_wish)


func select_main_wish() -> int:
	for type in Wish.Type.values():
		if type == Wish.Type.RANDOM:
			continue
		if not is_wish_begun_or_completed(type):
			return type
	return -1


func find_new_random_wish(_nothing = null) -> void:
	if active_random_wishes < random_wish_limit:
		var wish = Wish.new(Wish.Type.RANDOM)
		wishes.append(wish)
		new_pending_wish(wish)


func new_pending_wish(wish: Wish) -> void:
	active_wish_types.append(wish.type)
	if wish.is_main_wish():
		wish.container = main_wish_container
	else:
		wish.container = random_wish_container
		active_random_wishes += 1
	
	var pending_vico = pending_wish_vico.instantiate()
	pending_vico.setup(wish)
	wish.container.add_child(pending_vico)
	pending_vico.exiting.connect(new_wish_vico)


func new_wish_vico(wish: Wish, pending_vico_index: int) -> void:
	var vico = wish_vico.instantiate()
	vico.setup(wish)
	wish.container.add_child(vico)
	wish.container.move_child(vico, pending_vico_index)
	vico.ended.connect(start_new_wish_after_wish_completed)
	wish.start()


func start_new_wish_after_wish_completed(wish: Wish) -> void:
	wishes.erase(wish)
	active_wish_types.erase(wish.type)
	if wish.turned_in:
		if wish.is_main_wish():
			complete_wish(wish.type)
		else:
			completed_random_wishes += 1
	if not wish.is_main_wish():
		active_random_wishes -= 1
	wish_ended.emit()




func complete_wish(type: int) -> void:
	if not type in completed_wishes:
		completed_wishes.append(type)
		wish_completed.emit(type)


func uncomplete_all_wishes() -> void:
	for type in completed_wishes:
		wish_uncompleted.emit(type)
	completed_wishes.clear()



# - Start and Skip

func has_start_conditions(wish: int) -> bool:
	return has_method("condition_" + Wish.get_key(wish))


func condition_STUFF() -> void:
	if not gv.session_incremented.is_connected(start_STUFF):
		gv.session_incremented.connect(start_STUFF)
		lv.get_lored(LORED.Type.COAL).purchased.became_true.connect(skip_STUFF)


func start_STUFF(session_duration: int) -> void:
	if session_duration >= 5:
		gv.session_incremented.disconnect(start_STUFF)
		lv.get_lored(LORED.Type.COAL).purchased.became_true.disconnect(skip_STUFF)
		new_wish(Wish.Type.STUFF)


func skip_STUFF() -> void:
	gv.session_incremented.disconnect(start_STUFF)
	lv.get_lored(LORED.Type.COAL).purchased.became_true.disconnect(skip_STUFF)
	complete_wish(Wish.Type.STUFF)
	find_new_main_wish()




# - Get

func is_wish_begun_or_completed(wish_type: int) -> bool:
	return wish_type in active_wish_types or is_wish_completed(wish_type)


func is_wish_completed(wish_type: int) -> bool:
	return wish_type in completed_wishes


func is_game_just_beginning() -> bool:
	return not Wish.Type.STUFF in completed_wishes and not lv.is_lored_purchased(LORED.Type.COAL)
