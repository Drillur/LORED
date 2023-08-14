class_name Wishes
extends Node



var saved_vars := [
	"wishes",
	"completed_wishes",
	"completed_random_wishes",
	"random_wish_limit",
]

signal wish_completed(type)

var wish_vico := preload("res://Hud/Wish/wish_vico.tscn")
var pending_wish_vico := preload("res://Hud/Wish/wish_pending.tscn")

var main_wish_container: VBoxContainer
var random_wish_container: VBoxContainer

var active_main_wishes := 0
var active_wish_types := []
var active_random_wishes := 0

var wishes := []
var completed_wishes: Array
var completed_random_wishes := 0
var random_wish_limit := 0:
	set(val):
		random_wish_limit = val
		for i in val:
			find_new_random_wish()


func loaded() -> void:
	for wish in wishes:
		create_wish_vico(wish)




func new_game_start() -> void:
	create_wish_vico(await Wish.new(Wish.Type.STUFF))
	start()


func loaded_game_start() -> void:
	
	start()


func start() -> void:
	skip_STUFF_wish()
	find_new_main_wish()



func find_new_main_wish() -> void:
	if not lv.purchased_every_unlocked_lored_once():
		await lv.purchased_every_lored_once
	
	if active_main_wishes > 0:
		return
	
	var wish = await Wish.new(select_main_wish())
	wishes.append(wish)
	create_wish_vico(wish)
	if wish.has_pair():
		for x in wish.pair:
			if not is_wish_begun_or_completed(x):
				var paired_wish = await Wish.new(x)
				wishes.append(paired_wish)
				create_wish_vico(paired_wish)


func select_main_wish() -> int:
	for type in Wish.Type.values():
		if type == Wish.Type.RANDOM:
			continue
		if not is_wish_begun_or_completed(type):
			return type
	return -1


func find_new_random_wish() -> void:
	var wish = await Wish.new(Wish.Type.RANDOM)
	wishes.append(wish)
	create_wish_vico(wish)


func create_wish_vico(wish: Wish) -> void:
	if not wish.ready_to_start:
		await wish.became_ready_to_start
		if wish.skip_wish:
			if active_main_wishes == 0:
				find_new_main_wish()
			return
	
	var container: VBoxContainer
	
	if wish.is_main_wish():
		container = main_wish_container
		active_wish_types.append(wish.type)
		active_main_wishes += 1
	else:
		container = random_wish_container
		active_random_wishes += 1
	
	var pending_vico = pending_wish_vico.instantiate()
	pending_vico.setup(wish)
	container.add_child(pending_vico)
	var pending_vico_index = pending_vico.get_index()
	await pending_vico.tree_exited
	
	var vico = wish_vico.instantiate()
	vico.setup(wish)
	container.add_child(vico)
	container.move_child(vico, pending_vico_index)
	
	start_new_wish_after_wish_completed(wish)


func start_new_wish_after_wish_completed(wish: Wish) -> void:
	await wish.just_ended
	wishes.erase(wish)
	if wish.is_main_wish():
		active_wish_types.erase(wish.type)
		completed_wishes.append(wish.type)
		active_main_wishes -= 1
		if active_main_wishes == 0:
			find_new_main_wish()
	else:
		active_random_wishes -= 1
		if wish.turned_in:
			completed_random_wishes += 1
		find_new_random_wish()
	emit_signal("wish_completed", wish.type)



func skip_STUFF_wish() -> void:
	if is_wish_begun_or_completed(Wish.Type.FUEL):
		return
	await lv.get_lored(LORED.Type.COAL).leveled_up
	if active_main_wishes == 0 and not is_wish_begun_or_completed(Wish.Type.FUEL):
		create_wish_vico(await Wish.new(Wish.Type.FUEL))
		completed_wishes.append(Wish.Type.STUFF)



# - Get

func is_wish_begun_or_completed(wish_type: int) -> bool:
	return wish_type in active_wish_types or is_wish_completed(wish_type)


func is_wish_completed(wish_type: int) -> bool:
	return wish_type in completed_wishes


func is_game_just_beginning() -> bool:
	return not Wish.Type.STUFF in completed_wishes and not lv.get_lored(LORED.Type.COAL).purchased
