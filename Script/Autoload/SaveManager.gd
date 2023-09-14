extends Node



var saved_vars := [
	"save_name",
	"save_file_color",
	"save_version",
]

signal save_finished
signal load_finished
signal load_started
signal save_color_changed(val)

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

var default_save_method := SaveMethod.TO_FILE
var default_load_method := LoadMethod.FROM_FILE

var save_name: String = "Save"
var save_file_color: Color:
	set(val):
		if save_file_color != val:
			save_file_color = val
			save_color_changed.emit(val)

var save_version := {
	"major": 3,
	"minor": 0,
	"revision": 0,
}

var loaded_data: Dictionary
var last_save_clock := Time.get_unix_time_from_system() #reset
var patched := false

var test_data: String



func save_game(method := default_save_method) -> void:
	var packed_vars = pack_all_saved_vars()
	var save_text = JSON.stringify(packed_vars)
	
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
			print("- * - GAME SAVED - * -")
			#print(save_text)
	
	last_save_clock = Time.get_unix_time_from_system()
	
	save_finished.emit()



func load_game(method := default_load_method) -> void:
	gv.close_all()
	emit_signal("load_started")
	loaded_data = get_save_data(method)
	unpack_data(loaded_data)
	gv.open_all()
	load_finished.emit()
	
	update_save_version()


func delete_save(path := save_name):
	DirAccess.remove_absolute(get_save_path(path))


func duplicate_save(path := save_name) -> void:
	var new_path = get_unique_path(path + " (Copy)")
	DirAccess.copy_absolute(path, new_path)


func rename_path(path: String, new_path: String):
	DirAccess.rename_absolute(get_save_path(path), get_unique_path(new_path))



# - Actions

func pack_all_saved_vars() -> Dictionary:
	var data := {}
	data["SaveManager"] = pack_saved_vars(self)
	data["Overseer"] = pack_saved_vars(gv)
	data["Wallet"] = pack_saved_vars(wa)
	data["LOREDs"] = pack_saved_vars(lv)
	data["Upgrades"] = pack_saved_vars(up)
	data["Wishes"] = pack_saved_vars(wi)
	return data


func unpack_data(data: Dictionary) -> void:
	unpack_vars(self, data["SaveManager"])
	unpack_vars(gv, data["Overseer"])
	unpack_vars(wa, data["Wallet"])
	unpack_vars(lv, data["LOREDs"])
	unpack_vars(up, data["Upgrades"])
	unpack_vars(wi, data["Wishes"])



func pack_saved_vars(object) -> Dictionary:
	var data := {}
	for variable_name in object.get("saved_vars"):
		var variable = object.get(variable_name)
		if variable is Dictionary:
			data[variable_name] = pack_dictionary(variable)
		elif variable is Array:
			data[variable_name] = pack_array(variable)
		elif variable is Object:
			data[variable_name] = pack_saved_vars(variable)
		elif variable is Color:
			data[variable_name] = {
				"r": variable.r,
				"g": variable.g,
				"b": variable.b,
				"a": variable.a,
			}
		else:
			data[variable_name] = variable
	return data


func pack_dictionary(dictionary: Dictionary) -> Dictionary:
	var data := {}
	for key in dictionary:
		var value = dictionary[key]
		if value is Dictionary:
			data[key] = pack_dictionary(value)
		elif value is Object:
			data[key] = pack_saved_vars(value)
		elif value is Color:
			data[key] = {
				"r": value.r,
				"g": value.g,
				"b": value.b,
				"a": value.a,
			}
		else:
			data[key] = dictionary[key]
	return data


func pack_array(array: Array) -> Dictionary:
	var data := {}
	var i := 0
	for value in array:
		var variable_class: String
		if value is Array:
			data[i] = pack_array(value)
		elif value is Object:
			if value is Wish:
				variable_class = "Wish"
			elif value is Wish.Reward:
				if not "type" in value.saved_vars:
					continue
				variable_class = "Reward"
			data[variable_class + str(i)] = pack_saved_vars(value)
		elif value is int:
			variable_class = "int"
			data[variable_class + str(i)] = value
		else:
			data[i] = value
		i += 1
	return data



func unpack_vars(object, packed_vars: Dictionary) -> void:
	for variable_name in object.get("saved_vars"):
		if not variable_name in packed_vars.keys():
			continue
		var variable = object.get(variable_name)
		var packed_variable = packed_vars[variable_name]
		
		if variable is Dictionary:
			object.set(variable_name, unpack_dictionary(variable, packed_variable))
		elif variable is Array:
			object.set(variable_name, unpack_array(packed_variable))
		elif variable is Object:
			unpack_vars(object.get(variable_name), packed_variable)
			if variable is Big:
				emit_signals_on_bigs(variable)
		elif variable is Color:
			object.set(variable_name, Color(
				packed_variable.r,
				packed_variable.g,
				packed_variable.b,
				packed_variable.a,
			))
		else:
			object.set(variable_name, packed_variable)


func unpack_dictionary(dictionary: Dictionary, packed_dictionary: Dictionary) -> Dictionary:
	for key in dictionary:
		if not key in packed_dictionary.keys():
			continue
		var value = dictionary[key]
		var packed_value = packed_dictionary[key]
		
		if value is Dictionary:
			dictionary[key] = unpack_dictionary(value, packed_value)
		elif value is Object:
			unpack_vars(dictionary[key], packed_value)
			if value is Big:
				emit_signals_on_bigs(value)
		elif value is Color:
			dictionary[key] = Color(
				packed_value.r,
				packed_value.g,
				packed_value.b,
				packed_value.a,
			)
		else:
			dictionary[key] = packed_value
	return dictionary


func unpack_array(packed_array: Dictionary) -> Array:
	var array := []
	for key in packed_array:
		var data = packed_array[key]
		var variable_class = key.rstrip("0123456789")
		
		if variable_class == "Wish":
			var wish = Wish.new(data["type"])
			unpack_vars(wish, data)
			array.append(wish)
		
		elif variable_class == "Reward":
			var reward = Wish.Reward.new(data["type"], {
				"object_type": data["object_type"],
				"amount": data["amount"],
			})
			unpack_vars(reward, data)
			array.append(reward)
		
		elif variable_class == "int":
			array.append(int(data))
		
		else:
			array.append(data)
	
	return array



func emit_signals_on_bigs(big: Big) -> void:
	await load_finished
	big.emit_change()
	big.emit_increase()
	big.emit_decrease()



func update_save_version() -> void:
	var version_text = ProjectSettings.get("application/config/Version").split(".")
	save_version.major = version_text[0]
	save_version.minor = version_text[1]
	save_version.revision = version_text[2]



# - Get

func get_save_data(method := default_load_method, filename := save_name) -> Dictionary:
	var save_text: String = get_save_text(method, filename)
	var json = JSON.new()
	json.parse(save_text)
#	if method == LoadMethod.TEST:
#		print(json.data)
	return json.data


func get_save_text(method := default_load_method, filename := save_name) -> String:
	var save_text: String
	match method:
		LoadMethod.FROM_FILE:
			print(get_save_path(filename))
			var save_file := FileAccess.open(get_save_path(filename), FileAccess.READ)
			save_text = Marshalls.base64_to_variant(save_file.get_line())
		LoadMethod.FROM_CLIPBOARD:
			save_text = DisplayServer.clipboard_get()
		LoadMethod.TEST:
			print("- * - LOADING GAME - * -")
			save_text = test_data
	return save_text


func save_exists(filename := save_name) -> bool:
	return FileAccess.file_exists(get_save_path(filename))


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


func can_load_game(method := default_load_method, path = save_name) -> bool:
	if not save_exists(path):
		return false
	var json = JSON.new()
	var error = json.parse(get_save_text(method, path))
	if error != OK:
		print("Loading error. ", error)
		return false
	var data := get_save_data()
	return is_compatible_save(data)


func is_version_changed_since_save() -> bool:
	var version_text = ProjectSettings.get("application/config/Version").split(".")
	var version := {
		"major": version_text[0],
		"minor": version_text[1],
		"revision": version_text[2],
	}
	if save_version.major < version.major:
		return true
	if save_version.minor < version.minor:
		return true
	return save_version.revision < version.revision


func get_save_path(path := save_name) -> String:
	return SAVE_BASE_PATH + path + SAVE_EXTENSION


func get_unique_path(path: String) -> String:
	randomize()
	var new_path := path
	while save_exists(new_path):
		new_path += str(Time.get_unix_time_from_system() + randi())
	return new_path


func get_random_path() -> String:
	return get_unique_path(RANDOM_PATH_POOL[randi() % RANDOM_PATH_POOL.size()])


func get_time_since_last_save() -> float:
	return gv.current_clock - last_save_clock


