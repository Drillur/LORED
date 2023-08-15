extends Node



signal save_finished
signal load_finished


func save() -> String:
	var data := {}
	data["sleep_unlocked"] = var_to_str(sleep_unlocked)
	data["jobs_unlocked"] = var_to_str(jobs_unlocked)
	for type in loreds:
		var lored = get_lored(type)
		data[lored.key] = lored.save()
	emit_signal("save_finished")
	return var_to_str(data)


func load_data(data_str: String) -> void:
	var data: Dictionary = str_to_var(data_str)
	sleep_unlocked = str_to_var(data["sleep_unlocked"])
	jobs_unlocked = str_to_var(data["jobs_unlocked"])
	for type in loreds:
		var key = LORED.Type.keys()[type]
		if key in data.keys():
			loreds[type].load_data(data[key])
	emit_signal("load_finished")



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
signal all_loreds_became_active
signal loreds_initialized
signal sleep_became_unlocked
signal jobs_just_unlocked

var loreds := {}
var lored_container: LOREDContainer

var loreds_are_initialized := false
var sleep_unlocked := false
var jobs_unlocked := false

var unlocked := []
var active := []
var active_and_awake := []
var never_purchased := []





func _ready():
	for lored in LORED.Type.values():
		loreds[lored] = LORED.new(lored)
		gv.add_lored_to_stage(loreds[lored].stage, lored)
	loreds_are_initialized = true
	emit_signal("loreds_initialized")
	
	for lored in loreds.values():
		lored.loreds_initialized()



func close() -> void:
	loreds.clear()
	unlocked.clear()
	active.clear()
	active_and_awake.clear()
	never_purchased.clear()
	loreds_are_initialized = false
	sleep_unlocked = false
	jobs_unlocked = false



func new_game_start() -> void:
	unlock_lored(LORED.Type.COAL)
	unlock_lored(LORED.Type.STONE)
	get_lored(LORED.Type.STONE).force_purchase()
	start()


func loaded_game_start() -> void:
	# when loading loreds, 
	# if they are purchased, append to active
	# elif they are unlocked, append to unlocked
	# else don't append anywhere
	start()


func start() -> void:
	unlock_sleep()
	unlock_jobs()



# - Signal

func unlock_sleep() -> void:
	if not sleep_unlocked:
		while await wi.wish_completed != Wish.Type.UPGRADE_STONE:
			pass
		sleep_unlocked = true
		emit_signal("sleep_became_unlocked")


func unlock_jobs() -> void:
	if not jobs_unlocked:
		while await wi.wish_completed != Wish.Type.JOBS:
			pass
		jobs_unlocked = true
		emit_signal("jobs_just_unlocked")



# - Handy

func start_sleep_emitter(lored: LORED) -> void:
	var my_pass = lored.time_went_to_bed
	while lored.asleep:
		await get_tree().create_timer(1).timeout
		if my_pass != lored.time_went_to_bed:
			return
		if lored.asleep:
			lored.emit_signal("second_passed_while_asleep")


# - Actions

func start_job_timer(job: Job) -> void:
	job.work_pass = Time.get_unix_time_from_system()
	job.clock_in_time = job.work_pass
	var my_pass = job.work_pass
	await get_tree().create_timer(job.duration.get_as_float()).timeout
	if my_pass == job.work_pass:
		job.complete()


func unlock_lored(_lored: int) -> void:
	var lored = get_lored(_lored) as LORED
	print(lored.key)
	lored.unlock()
	unlocked.append(lored)
	if not lored.purchased:
		never_purchased.append(lored)
		await lored.leveled_up
		never_purchased.erase(lored)
	if all_loreds_are_active():
		emit_signal("all_loreds_became_active")
	if purchased_every_unlocked_lored_once():
		emit_signal("purchased_every_lored_once")



func reset() -> void:
	active.clear()
	active_and_awake.clear()




# - Get

func get_lored(lored: int) -> LORED:
	return loreds[lored]


func get_random_active_lored() -> LORED:
	return active[randi() % active.size()]


func get_random_awake_lored() -> LORED:
	return active_and_awake[randi() % active_and_awake.size()]


func get_loreds_in_stage(stage: int) -> Array:
	return gv.get_loreds_in_stage(stage)


func all_loreds_are_active() -> bool:
	return unlocked.size() == active.size()


func purchased_every_unlocked_lored_once() -> bool:
	return never_purchased.size() == 0


func is_lored_unlocked(lored: int) -> bool:
	return get_lored(lored).unlocked


func can_lored_emote(lored_type: int) -> bool:
	var lored = get_lored(lored_type)
	return lored.unlocked and lored in active_and_awake


func get_active_lored_count() -> int:
	return active.size()


func get_icon_and_name_text(lored: int) -> String:
	return get_lored(lored).icon_and_name_text
