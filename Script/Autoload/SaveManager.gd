extends Node



enum SaveMethod {
	TO_FILE,
	TO_CLIPBOARD,
	TO_CONSOLE,
	TEST,
}

enum LoadMethod {
	FROM_FILE,
	FROM_CLIPBOARD,
	TEST,
}

const SAVE_BASE_PATH := "user://"
const SAVE_EXTENSION := ".lored"

const RANDOM_PATH_POOL := [
	"PaperPilot",
	"Carl",
	"MEE6",
	"Captain Succ",
	"Cullect",
	"Ohtil",
	"Buhthul",
	"Stangmouse",
	"Stonkmaus",
	"Baby Shark", # kill me
	"And a little bonus for Merp. Fock you, Stangmouse",
	"CrimsonFrost",
	"CryptoGrounds",
	"CGGamesLLCInc.Company.Com",
	"Dimelsondr",
	"Raptors",
	"Srotpar",
	"Merp",
	"SteelDusk",
	"Water",
	"Flamemaster",
	"VoidCloud",
	"Peekabluu",
	"Peekambluu",
	"vgCollosus",
	"Aylienne",
	"Kam",
	"Master Polaris",
	"YouTube Superstar",
	"Dread Dude",
	"Blood4All",
	"Pizza",
	"PacBrad",
	"Univenon",
	"Wintermaul Wars",
	"SSJ10",
	"Pent",
	"Pent",
	"Semicolon",
	"ASMR",
	"Magic Hag",
	"retchleaf",
]

signal save_finished
signal load_finished

var default_save_method := SaveMethod.TO_FILE
var default_load_method := LoadMethod.FROM_FILE

var save_path: String = "Drillur"
var save_file_color: Color

var game_version := 3.00
var last_save_clock: float
var patched := false
var loaded := false

var test_data: String



func save_game(method := default_save_method) -> void:
	loaded = false
	var data := {}
	data["save_file_color"] = var_to_str(save_file_color)
	data["game_version"] = var_to_str(game_version)
	data["Overseer"] = gv.save()
	data["Wallet"] = wa.save()
	data["LOREDs"] = lv.save()
	data["Upgrades"] = up.save()
	data["Wishes"] = wi.save()
	var save_text = var_to_str(data)
	
	match method:
		SaveMethod.TO_FILE:
			var save_file := FileAccess.open(get_save_path(), FileAccess.WRITE)
			save_file.store_line(Marshalls.variant_to_base64(save_text))
		SaveMethod.TO_CLIPBOARD:
			DisplayServer.clipboard_set(save_text)
		SaveMethod.TO_CONSOLE:
			print("Your LORED save data is below! Click Expand, if necessary, for your save may be very large, and then save it in any text document!")
			print(Marshalls.variant_to_base64(save_text))
		SaveMethod.TEST:
			test_data = save_text
	
	last_save_clock = Time.get_unix_time_from_system()
	emit_signal("save_finished")



func load_game(method := default_load_method) -> void:
	# by here, save exists and is compatible.
	loaded = true
	gv.reload_scene()
	if gv.reloading:
		print("awaiting closure")
		await gv.reload_finished
	print("-----------saving continue")
	var data := get_save_data(method)
	save_file_color = str_to_var(data["save_file_color"])
	game_version = str_to_var(data["game_version"])
	gv.load_data(data["Overseer"])
	wa.load_data(data["Wallet"])
	lv.load_data(data["LOREDs"])
	up.load_data(data["Upgrades"])
	wi.load_data(data["Wishes"])
	emit_signal("load_finished")


func delete_save(filename: String):
	DirAccess.remove_absolute(get_save_path())


func duplicate_save(path := save_path) -> void:
	var new_path = get_unique_path(path + " (Copy)")
	DirAccess.copy_absolute(path, new_path)


func rename_path(path: String, new_path: String):
	DirAccess.rename_absolute(get_save_path(path), get_unique_path(new_path))



# - Get

func get_save_data(method := default_load_method) -> Dictionary:
	match method:
		LoadMethod.FROM_FILE:
			var data: String
			var save_file := FileAccess.open(get_save_path(), FileAccess.READ)
			data = Marshalls.base64_to_variant(save_file.get_line())
			return str_to_var(data)
		LoadMethod.FROM_CLIPBOARD:
			return str_to_var(Marshalls.base64_to_variant(DisplayServer.clipboard_get()))
		_: # TEST
			return str_to_var(test_data)


func save_exists(path := get_save_path()) -> bool:
	return FileAccess.file_exists(get_save_path(path))


func is_compatible_save(data: Dictionary) -> bool:
	if data == {}:
		return false
	if not "SaveManager" in data.keys():
		return false
	if not "Overseer" in data.keys():
		return false
	if not "Wallet" in data.keys():
		return false
	if not "LOREDs" in data.keys():
		return false
	return true


func can_load_game(method := default_load_method, path = save_path) -> bool:
	if not save_exists():
		return false
	var data := get_save_data()
	return is_compatible_save(data)


func is_version_changed_since_save(save_version: float) -> bool:
	return save_version < game_version


func get_save_path(path := save_path) -> String:
	return SAVE_BASE_PATH + path + SAVE_EXTENSION


func get_unique_path(path: String) -> String:
	randomize()
	var new_path := path
	while save_exists(new_path):
		new_path += str(Time.get_unix_time_from_system() + randi())
	return new_path


func get_random_path() -> String:
	return get_unique_path(RANDOM_PATH_POOL[randi() % RANDOM_PATH_POOL.size()])


