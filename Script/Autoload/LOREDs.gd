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
#	"PETROLEUM": ,
#	"WOOD_PULP": ,
#	"PAPER": ,
#	"PLASTIC": ,
	"TOBACCO": 73,
	"CIGARETTES": 25,
#	"CARCINOGENS": ,
#	"TUMORS": ,
	"refuel0": 28,
	"refuel1": 27,
}

signal purchased_every_lored_once
signal loreds_initialized
signal sleep_just_unlocked(unlocked)
signal advanced_details_just_unlocked(unlocked)

var loreds := {}
var loreds_by_key := {}
var lored_container: LOREDContainer

var loreds_are_initialized := false:
	set(val):
		if loreds_are_initialized != val:
			loreds_are_initialized = val
			emit_signal("loreds_initialized")
var sleep_unlocked := false:
	set(val):
		if sleep_unlocked != val:
			sleep_unlocked = val
			sleep_just_unlocked.emit(val)
var advanced_details_unlocked := false: # includes jobs and level_up tooltip
	set(val):
		if advanced_details_unlocked != val:
			advanced_details_unlocked = val
			advanced_details_just_unlocked.emit(val)

var unlocked := []
var active := []
var active_and_awake := []
var never_purchased := []





func _ready():
	for lored in LORED.Type.values():
		loreds[lored] = LORED.new(lored)
		loreds_by_key[loreds[lored].key] = loreds[lored]
		connect("loreds_initialized", loreds[lored].loreds_initialized)
	loreds_are_initialized = true
	for lored in LORED.Type.values():
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
	unlock_lored(LORED.Type.COAL)
	unlock_lored(LORED.Type.STONE)
	get_lored(LORED.Type.STONE).force_purchase()



# - Signal

func sleep_lock(wish: int) -> void:
	if wish == Wish.Type.UPGRADE_STONE:
		sleep_unlocked = wi.is_wish_completed(wish)


func job_lock(wish: int) -> void:
	if wish == Wish.Type.JOBS:
		advanced_details_unlocked = wi.is_wish_completed(wish)



# - Actions

func start_job_timer(job: Job) -> void:
	job.work_pass = Time.get_unix_time_from_system()
	job.clock_in_time = job.work_pass
	var my_pass = gv.password
	var job_pass = job.work_pass
	await get_tree().create_timer(job.duration.get_as_float()).timeout
	if (
		my_pass == gv.password
		and job_pass == job.work_pass
	):
		job.complete()


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


func lored_is_emoting(lored: int) -> bool:
	return get_lored(lored).emoting


func get_random_active_lored() -> int:
	return active[randi() % active.size()]


func get_random_awake_lored() -> int:
	return active_and_awake[randi() % active_and_awake.size()]


func get_vico(lored: int) -> LOREDVico:
	return get_lored(lored).vico


func get_icon(lored: int) -> Texture:
	return get_lored(lored).icon


func get_color(lored: int) -> Color:
	return get_lored(lored).color


func get_loreds_in_stage(stage: int) -> Array:
	return gv.get_loreds_in_stage(stage)


func all_loreds_are_active() -> bool:
	return unlocked.size() == active.size()


func purchased_every_unlocked_lored_once() -> bool:
	return never_purchased.size() == 0


func is_lored_unlocked(lored: int) -> bool:
	return get_lored(lored).unlocked


func is_lored_purchased(lored: int) -> bool:
	return get_lored(lored).purchased


func can_lored_emote(lored_type: int) -> bool:
	var lored = get_lored(lored_type)
	return lored.unlocked and lored in active_and_awake


func get_active_lored_count() -> int:
	return active.size()


func get_fuel_percent(lored: int) -> float:
	return get_lored(lored).fuel.get_current_percent()


func get_icon_and_name_text(lored: int) -> String:
	return get_lored(lored).icon_and_name_text


func get_lored_name(lored: int) -> String:
	return get_lored(lored).name


func get_key(lored: int) -> String:
	return LORED.Type.keys()[lored]
