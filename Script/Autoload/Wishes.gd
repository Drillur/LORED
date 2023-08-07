class_name Wishes
extends Node



signal wish_completed(type)

var wish_vico := preload("res://Hud/Wish/wish_vico.tscn")

var main_wish_container: VBoxContainer
var random_wish_container: VBoxContainer

var completed_wishes: Array

var active_main_wishes := 0
var active_wish_types := []
var active_random_wishes := 0
var random_wish_limit := 0:
	set(val):
		random_wish_limit = val
		for i in val:
			find_new_random_wish()




func new_game_start() -> void:
	
	start()


func loaded_game_start() -> void:
	
	start()


func start() -> void:
	skip_STUFF_wish()
	find_new_main_wish()



func find_new_main_wish() -> void:
	if lv.has_unlocked_and_inactive_loreds():
		await lv.no_unlocked_and_inactive_loreds
	
	var wish = await Wish.new(select_main_wish())
	if not wish.ready_to_start:
		await wish.became_ready_to_start
		if wish.skip_wish:
			if active_main_wishes == 0:
				find_new_main_wish()
			return
	create_wish_vico(wish)
	if wish.has_pair():
		for x in wish.pair:
			if not is_wish_begun_or_completed(x):
				create_wish_vico(await Wish.new(x))


func select_main_wish() -> int:
	for type in Wish.Type.values():
		if not is_wish_begun_or_completed(type):
			return type
	return -1


func find_new_random_wish() -> void:
	print("getting RANDOM wish...")


func create_wish_vico(wish: Wish) -> void:
	var vico = wish_vico.instantiate()
	vico.setup(wish)
	
	if wish.is_main_wish():
		active_wish_types.append(wish.type)
		main_wish_container.add_child(vico)
		active_main_wishes += 1
		start_new_wish_after_wish_completed(wish)
	
	else:
		active_random_wishes += 1
		random_wish_container.add_child(vico)


func start_new_wish_after_wish_completed(wish: Wish) -> void:
	await wish.turned_in
	active_wish_types.erase(wish.type)
	completed_wishes.append(wish.type)
	if wish.is_main_wish():
		active_main_wishes -= 1
		if active_main_wishes == 0:
			find_new_main_wish()
	else:
		active_random_wishes -= 1
		find_new_random_wish()
	emit_signal("wish_completed", wish.type)



func skip_STUFF_wish() -> void:
	if wi.is_wish_begun_or_completed(Wish.Type.FUEL):
		return
	await lv.get_lored(LORED.Type.COAL).leveled_up
	if wi.active_main_wishes == 0 and not wi.is_wish_begun_or_completed(Wish.Type.FUEL):
		wi.create_wish_vico(await Wish.new(Wish.Type.FUEL))
		wi.completed_wishes.append(Wish.Type.STUFF)



# - Get

func is_wish_begun_or_completed(wish_type: int) -> bool:
	return wish_type in active_wish_types or is_wish_completed(wish_type)


func is_wish_completed(wish_type: int) -> bool:
	return wish_type in completed_wishes


func is_game_just_beginning() -> bool:
	return not Wish.Type.STUFF in completed_wishes and not lv.get_lored(LORED.Type.COAL).purchased
