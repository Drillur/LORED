extends Node



var saved_vars := [
	"save_file_color",
	"game_version",
]

enum SaveMethod {
	TO_FILE,
	TO_CLIPBOARD,
	TO_CONSOLE,
}

enum LoadMethod {
	FROM_FILE,
	FROM_CLIPBOARD,
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

signal save_game_finished
signal load_game_finished

var default_save_method := SaveMethod.TO_FILE
var default_load_method := LoadMethod.FROM_FILE

var save_path: String = "Drillur"
var save_file_color: Color

var game_version := 3.00
var last_save_clock: float
var patched := false

var loaded_data := {}




func _ready():
	pass


func save_game(method := default_save_method) -> void:
	var data := {}
	data["SaveManager"] = save_vars(self)
	data["Overseer"] = save_vars(gv)
	data["Wallet"] = save_vars(wa)
	data["LOREDs"] = save_vars(lv)
	var save_text = var_to_str(data)
	
	match method:
		SaveMethod.TO_FILE:
			var save_file := FileAccess.open_encrypted_with_pass(get_save_path(), FileAccess.WRITE, "for finding this, you deserve to have it decrypted")
			save_file.store_line(Marshalls.variant_to_base64(save_text))
		SaveMethod.TO_CLIPBOARD:
			DisplayServer.clipboard_set(save_text)
		SaveMethod.TO_CONSOLE:
			print("Your LORED save data is below! Click Expand, if necessary, for your save may be very large, and then save it in any text document!")
			print(Marshalls.variant_to_base64(save_text))
	
	last_save_clock = Time.get_unix_time_from_system()
	emit_signal("save_game_finished")



func load_game(method := default_load_method) -> void:
	# by here, save exists and is compatible.
	var data := get_save_data()
	print(data)


func delete_save(filename: String):
	DirAccess.remove_absolute(get_save_path())


func duplicate_save(path := save_path) -> void:
	var new_path = get_unique_path(path + " (Copy)")
	DirAccess.copy_absolute(path, new_path)


func rename_path(path: String, new_path: String):
	DirAccess.rename_absolute(get_save_path(path), get_unique_path(new_path))



# - Get

func get_save_data() -> Dictionary:
	var data: String
	var save_file := FileAccess.open_encrypted_with_pass(get_save_path(), FileAccess.READ, "for finding this, you deserve to have it decrypted")
	data = Marshalls.base64_to_variant(save_file.get_line())
	return str_to_var(data)


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


func can_load_game(path = save_path) -> bool:
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



# - Save Vars

func save_vars(object) -> String:
	
	var data := {}
	var saved_vars_keys = object.get("saved_vars")
	
	for var_key in saved_vars_keys:
		
		var x = object.get(var_key)
		
		if x is Dictionary:
			data[var_key] = save_dictionary(x)
		elif x is Array:
			data[var_key] = save_array(x)
		elif x is Object:
			if x.get("saved_vars") != null:
				data[var_key] = save_vars(x)
			else:
				printerr(var_key, " does not have saved_vars variable. 1")
		else:
			data[var_key] = var_to_str(x)
	
	return var_to_str(data)


func save_dictionary(dictionary: Dictionary) -> String:
	
	var data := {}
	
	for key in dictionary:
		if dictionary[key] is Dictionary:
			data[key] = save_dictionary(dictionary[key])
		elif dictionary[key] is Array:
			data[key] = save_array(dictionary[key])
		elif dictionary[key] is Object:
			if dictionary[key].get("saved_vars") != null:
				data[key] = save_vars(dictionary[key])
			else:
				printerr(key, " does not have saved_vars variable. 2")
		else:
			data[key] = var_to_str(dictionary[key])
	
	return var_to_str(data)


func save_array(array: Array) -> String:
	
	var data := {}
	
	var i = 0
	for x in array:
		if x is Array:
			data[i] = save_array(x)
		elif x is Object:
			if x.get("saved_vars") != null:
				data[i] = save_vars(x)
			else:
				printerr(i, " does not have saved_vars variable. 3")
		else:
			data[i] = var_to_str(x)
		i += 1
	
	return var_to_str(data)



func load_vars(object, _save_data: Dictionary):
	
	for var_key in object.get("saved_vars"):
		
		if not var_key in _save_data.keys():
			continue
		
		var x = object.get(var_key)
		var saved_x = str_to_var(_save_data[var_key])
		
		if x is Dictionary:
			object.set(var_key, load_dictionary(saved_x, x))
		elif x is Array:
			object.set(var_key, load_empty_array(saved_x))
		elif x is Resource:
			if x.has_method("_load"):
				if object.get(var_key) is Big:
					object.get(var_key)._load(_save_data[var_key])
				elif object.get(var_key) is Attribute:
					object.get(var_key)._load(_save_data[var_key])
				else:
					object.get(var_key)._load(saved_x)
			else:
				load_vars(object.get(var_key), saved_x)
		else:
			object.set(var_key, saved_x)


func load_dictionary(loaded_dictionary: Dictionary, actual_dictionary: Dictionary) -> Dictionary:
	
	for key in actual_dictionary:
		
		if not key in loaded_dictionary.keys():
			continue
		
		var x = actual_dictionary[key]
		var saved_x = str_to_var(loaded_dictionary[key])
		
		if x is Dictionary:
			actual_dictionary[key] = load_dictionary(saved_x, x)
		elif x is Array:
			actual_dictionary[key] = load_empty_array(saved_x)
		elif x is Resource:
			if x.has_method("_load"):
				if x is Big:
					actual_dictionary[key]._load(loaded_dictionary[key])
				elif x is Attribute:
					actual_dictionary[key]._load(loaded_dictionary[key])
				else:
					actual_dictionary[key]._load(saved_x)
			else:
				load_vars(actual_dictionary[key], saved_x)
		else:
			actual_dictionary[key] = saved_x
	
	return actual_dictionary


const REF_CLASSES := ["FlowerSeed", "Big", "Num"]

func load_empty_array(loaded_dictionary: Dictionary) -> Array:
	
	var array := []
	
	for key in loaded_dictionary:
		
		var saved_x = str_to_var(loaded_dictionary[key])
		var _class = key.rstrip("0123456789")
		
		if (_class in REF_CLASSES) or (saved_x is Resource):
			array.append(new_reference_by_save_data(_class, saved_x))
		elif saved_x is Array:
			array.append(load_empty_array(saved_x))
		else:
			array.append(saved_x)
	
	return array


func new_reference_by_save_data(_class: String, saved_x):
	var new_thing
	
	if _class == "Big":
		new_thing = Big.new()
		new_thing._load(saved_x)
	elif _class == "Attribute":
		new_thing = Attribute.new(0)
		new_thing._load(saved_x)
	
	return new_thing






func loadSavedVars(_saved_vars: Dictionary, _save_data: Dictionary) -> Dictionary:
	
	# this is still used in some funcs.
	# It's the first version of the newer load_vars() method
	
	var loadedVars := {}
	
	for x in _saved_vars:
		
		if not x in _save_data.keys():
			continue
		
		if _saved_vars[x] is Big:
			loadedVars[x] = Big.new(_save_data[x])
			continue
		
		if _saved_vars[x] is Dictionary:
			loadedVars[x] = str_to_var(_save_data[x])
			for key in _saved_vars[x]:
				if _saved_vars[x][key] is Dictionary:
					for sub_key in _saved_vars[x][key]:
						if not sub_key in loadedVars[x][key]:
							loadedVars[x][key][sub_key] = _saved_vars[x][key][sub_key]
				else:
					if not key in loadedVars[x]:
						loadedVars[x][key] = _saved_vars[x][key]
				# if the code above fails, this is what it used to be:
				# just delete everything with this indentation until "for key in saved_vars[x]"
#				if not key in loadedVars[x]:
#					loadedVars[x][key] = saved_vars[x][key]
			continue
		
		loadedVars[x] = str_to_var(_save_data[x])
	
	return loadedVars



