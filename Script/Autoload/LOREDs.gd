extends Node



var saved_vars := [
	"sleep_unlocked",
	"loreds_by_key",
	"advanced_details_unlocked",
]



const FUEL_WARNING := 0.5
const FUEL_DANGER := 0.15
const SMALLER_ANIMATIONS := [
	"STONE",
	"COAL",
	"IRON_ORE",
	"COPPER_ORE",
	"IRON",
	"COPPER",
	"GROWTH",
	"JOULES",
	"CONCRETE",
	"MALIGNANCY",
	"TARBALLS",
	"OIL",

	"WATER",
	"WATER2",
	"HUMUS",
	"SEEDS",
	"SEEDS2",
	"TREES",
	"WOOD",
	"LIQUID_IRON",
	"SAND",
	"GLASS",
	"GALENA",
	"TOBACCO",
	"CIGARETTES",
]
const ANIMATION_FRAMES := {
	"STONE": 27,
	"COAL": 25,
	"IRON_ORE": 28,
	"COPPER_ORE": 25,
	"IRON": 47,
	"COPPER": 30,
	"GROWTH": 40,
	"JOULES": 32,
	"CONCRETE": 57,
	"MALIGNANCY": 36,
	"TARBALLS": 29,
	"OIL": 8,

	"WATER": 12,
	"HUMUS": 9,
	"SEEDS": 14,
	"TREES": 77,
	"SOIL": 42,
	"AXES": 2,
	"WOOD": 49,
	"HARDWOOD": 37,
	"LIQUID_IRON": 22,
	"STEEL": 58,
	"SAND": 45,
	"GLASS": 37,
	"DRAW_PLATE": 33,
	"WIRE": 27,
	"GALENA": 22,
	"LEAD": 11,
	"PETROLEUM": 1, # ---------
	"WOOD_PULP": 1, # ---------
	"PAPER": 1, # ---------
	"PLASTIC": 1, # ---------
	"TOBACCO": 73,
	"CIGARETTES": 25,
	"CARCINOGENS": 1, # ---------
	"TUMORS": 1, # ---------
	"refuel0": 28,
	"refuel1": 27,
}

signal started
signal purchased_every_lored_once

var loreds := {}
var loreds_by_key := {}
var lored_container: LOREDContainer

var loreds_initialized := LoudBool.new(false)

var sleep_unlocked := LoudBool.new()
var advanced_details_unlocked := LoudBool.new()

var unlocked := []
var active := []
var active_and_awake := []
var never_purchased := []

var key_loreds := [
	LORED.Type.STONE,
	LORED.Type.CONCRETE,
	LORED.Type.MALIGNANCY,
	LORED.Type.WATER,
	LORED.Type.LEAD,
	LORED.Type.TREES,
	LORED.Type.SOIL,
	LORED.Type.STEEL,
	LORED.Type.WIRE,
	LORED.Type.GLASS,
	LORED.Type.TUMORS,
	LORED.Type.HARDWOOD, # was originally WOOD. i changed without knowing why it was wood
]
var loreds_required_for_extra_normal_menu := [
	LORED.Type.SEEDS,
	LORED.Type.TREES,
	LORED.Type.WATER,
	LORED.Type.SOIL,
	LORED.Type.HUMUS,
	LORED.Type.SAND,
	LORED.Type.GLASS,
	LORED.Type.LIQUID_IRON,
	LORED.Type.STEEL,
	LORED.Type.HARDWOOD,
	LORED.Type.AXES,
	LORED.Type.WOOD,
	LORED.Type.DRAW_PLATE,
	LORED.Type.WIRE,
]
var extra_normal_menu_unlocked := false


var gay = "Okay"


func _ready():
	var d = Time.get_unix_time_from_system()
	
	for lored in LORED.Type.values():
		if lored == LORED.Type.NO_LORED:
			continue
		loreds[lored] = LORED.new(lored)
		loreds_by_key[loreds[lored].key] = loreds[lored]
		loreds_initialized.became_true.connect(loreds[lored].loreds_initialized)
	
	print_debug("LOREDs initialized in %s secs" % str(Time.get_unix_time_from_system() - d))
	
	loreds_initialized.set_to(true)
	for lored in loreds.keys():
		gv.add_lored_to_stage(loreds[lored].stage, lored)
	
	wi.wish_completed.connect(sleep_lock)
	wi.wish_uncompleted.connect(sleep_lock)
	wi.wish_completed.connect(job_lock)
	wi.wish_uncompleted.connect(job_lock)



func close() -> void:
	unlocked.clear()
	active.clear()
	active_and_awake.clear()
	never_purchased.clear()



func start() -> void:
	started.emit()



# - Signal

func sleep_lock(wish: int) -> void:
	if wish == Wish.Type.UPGRADE_STONE:
		sleep_unlocked.set_to(wi.is_wish_completed(wish))


func job_lock(wish: int) -> void:
	if wish == Wish.Type.JOBS:
		advanced_details_unlocked.set_to(wi.is_wish_completed(wish))



# - Actions

func unlock_lored(_lored: int) -> void:
	get_lored(_lored).unlock()


func lored_unlocked(lored: int) -> void:
	if not lored in unlocked:
		unlocked.append(lored)
		if not is_lored_purchased(lored):
			never_purchased.append(lored)


func lored_locked(lored: int) -> void:
	unlocked.erase(lored)
	erase_lored_from_never_purchased(lored)


func add_lored_to_never_purchased(lored: int) -> void:
	if not lored in never_purchased:
		never_purchased.append(lored)


func erase_lored_from_never_purchased(lored: int) -> void:
	if lored in never_purchased:
		never_purchased.erase(lored)
		if purchased_every_unlocked_lored_once():
			emit_signal("purchased_every_lored_once")



func reset() -> void:
	active.clear()
	active_and_awake.clear()


func lored_became_active(lored: int) -> void:
	if not lored in active:
		active.append(lored)
		active_and_awake.append(lored)
		erase_lored_from_never_purchased(lored)


func lored_became_inactive(lored: int) -> void:
	if lored in active:
		active.erase(lored)
		active_and_awake.erase(lored)



func lored_went_to_sleep(lored: int) -> void:
	if lored in active_and_awake:
		active_and_awake.erase(lored)


func lored_woke_up(lored: int) -> void:
	if not lored in active_and_awake:
		active_and_awake.append(lored)




# - Get


func get_lored(lored: int) -> LORED:
	return loreds[lored]


func get_details(lored: LORED.Type) -> Details:
	return get_lored(lored).details


func lored_is_emoting(lored: int) -> bool:
	return get_lored(lored).emoting.is_true()


func get_random_active_lored() -> int:
	return active[randi() % active.size()]


func get_random_unlocked_lored() -> int:
	return unlocked[randi() % unlocked.size()]


func get_random_awake_lored() -> int:
	return active_and_awake[randi() % active_and_awake.size()]


func get_vico(lored: int) -> LOREDVico:
	return get_lored(lored).vico


func get_icon(lored: int) -> Texture:
	return get_lored(lored).details.icon


func get_color(lored: int) -> Color:
	return get_lored(lored).details.color


func get_loreds_in_stage(stage: int) -> Array[LORED.Type]:
	return gv.get_loreds_in_stage(stage)


func all_loreds_are_active() -> bool:
	return unlocked.size() == active.size()


func purchased_every_unlocked_lored_once() -> bool:
	return never_purchased.size() == 0


func is_lored_unlocked(lored: int) -> bool:
	return get_lored(lored).unlocked.is_true()


func is_lored_purchased(lored: int) -> bool:
	return get_lored(lored).purchased.is_true()


func can_lored_emote(lored_type: int) -> bool:
	var lored = get_lored(lored_type)
	return lored.unlocked.is_true() and lored in active_and_awake


func get_active_lored_count() -> int:
	return active.size()


func get_level(lored: int) -> int:
	return get_lored(lored).level.get_value()


func get_fuel_percent(lored: int) -> float:
	return get_lored(lored).fuel.get_current_percent()


func get_icon_and_name_text(lored: int) -> String:
	return get_lored(lored).details.icon_and_name_text


func get_colored_name(lored: LORED.Type) -> String:
	return get_lored(lored).details.colored_name


func get_lored_name(lored: int) -> String:
	return get_lored(lored).details.name


func get_key(lored: int) -> String:
	return LORED.Type.keys()[lored]


func is_lored_active(lored: int) -> bool:
	var x = get_lored(lored)
	return (
		x.unlocked
		and x.purchased.is_true()
		and x.working.is_true()
		and x.asleep.is_false()
	)


func any_loreds_in_list_are_purchased(list: Array) -> bool:
	for x in list:
		if is_lored_purchased(x):
			return true
	return false


func any_loreds_in_list_are_inactive(list: Array) -> bool:
	for x in list:
		if not is_lored_active(x):
			return true
	return false


func get_all_loreds() -> Array:
	return loreds.values()


func get_loreds_in_list(_lored_types: Array[LORED.Type]) -> Array[LORED]:
	var loreds: Array[LORED]
	for lored_type in _lored_types:
		loreds.append(get_lored(lored_type))
	return loreds


func get_job(_lored_type: LORED.Type, _job_type: Job.Type) -> Job:
	return get_lored(_lored_type).get_job(_job_type)


func get_highest_lored_type(_lored_types: Array[LORED.Type]) -> int:
	var i := 0
	var highest_type := 0
	for type in _lored_types:
		if type > highest_type:
			highest_type = int(type)
		i += 1 
	return highest_type


func get_highest_lored_type_by_loreds(_loreds: Array[LORED]) -> int:
	var types: Array[LORED.Type]
	for lored in _loreds:
		types.append(lored.type)
	return get_highest_lored_type(types)
