extends Node


var rt = 0


# items will save in multiple ways:
# 1. Every 30 sec.
# 2. On value change.
# 3. On _load.


var save_path: String
var save_data := {}

var saved_vars := ["save_file_color",]
var game_version := "" # the game version according to the last file loaded from

var save_file_color: Color

var patched := false

signal gameSaved





func save(path := save_path, type := "normal"):
	
	if path != save_path:
		path = getFormattedPath(path)
		save_path = path
	
	var data := {}
	
	data["file"] = save_fileSpecificInfo()
	data["stats"] = gv.save()
	if gv.active_scene == gv.Scene.ROOT:
		data["root"] = rt.save()
	
	var save_text = var_to_str(data)
	var save_file := FileAccess.open(path, FileAccess.WRITE)
	
	#type = "debug" #note
	match type:
		"normal":
			# create SAVE
			save_file.store_line(Marshalls.variant_to_base64(save_text))
			save_file.close()
		
		"export":
			
			# create SAVE
			save_file.store_line(Marshalls.variant_to_base64(save_text))
			save_file.close()
		
		"print to console":
			print("Your LORED save data is below! Click Expand, if necessary, for your save may be very large, and then save it in any text document!")
			print(Marshalls.variant_to_base64(save_text))
		
		"debug":
			save_file.store_line(save_text)
			save_file.close()
	
	emit_signal("gameSaved")
	gv.lastSaveClock = Time.get_unix_time_from_system()

func _load(path := save_path) -> bool:
	
	# returns successful _load
	
	save_path = path
	
	var data := getSaveData(path)
	
	if not dataIsCompatibleSave(data):
		return false
	
	load_fileSpecificInfo(str_to_var(data["file"]))
	
	gv._load(str_to_var(data["stats"]))
	rt._load(str_to_var(data["root"]))
	
	return true


func can_load_game(path = save_path) -> bool:
	if not FileAccess.file_exists(path):
		return false
	var data := getSaveData(path)
	return dataIsCompatibleSave(data)


func loadNewGame(filename: String, _saveFileColor: Color):
	loadGame(filename, _saveFileColor)
	
	var t = Timer.new()
	add_child(t)
	t.start(1)
	await t.timeout
	t.queue_free()
	
	save()
func loadGame(filename: String, _saveFileColor: Color):
	
	setSavePath(filename)
	setSaveFileColor(_saveFileColor)
	
	gv.changeScene(gv.Scene.ROOT)


func save_fileSpecificInfo() -> String:
	
	var data := {}
	
	data["game version"] = ProjectSettings.get_setting("application/config/Version")
	
	for x in saved_vars:
		if get(x) is Big:
			data[x] = get(x).save()
		else:
			data[x] = var_to_str(get(x))
	
	#data["difficulty"] = diff.save()
	
	return var_to_str(data)

func load_fileSpecificInfo(data: Dictionary):
	
	game_version = data["game version"]
	
	#diff._load(str_to_var(data["difficulty"]))
	
	for x in saved_vars:
		
		if not x in data.keys():
			continue
		
		if get(x) is Big:
			get(x)._load(data[x])
		else:
			set(x, str_to_var(data[x]))


func textIsConvertibleToSave(text: String) -> bool:
	
	var marshalledText = deMarshmallowedText(text)
	if marshalledText == null:
		return false
	if marshalledText is Dictionary:
		return false
	
	var textAsVar = str_to_var(marshalledText)
	if not textAsVar is Dictionary:
		return false
	return dataIsCompatibleSave(textAsVar)
func dataIsCompatibleSave(data: Dictionary) -> bool:
	
	if data == {}:
		return false
	if not "root" in data.keys():
		return false
	if not "stats" in data.keys():
		return false
	
	return true
	

func getSaveData(path: String) -> Dictionary:
	
	var data: String
	
	if not FileAccess.file_exists(path):
		return {}
	
	var save_file := FileAccess.open(path, FileAccess.READ)
	
	data = deMarshmallowedText(save_file.get_line())
	
	save_file.close()
	
	return str_to_var(data)

func getSaveText(path: String) -> String:
	
	# is not unmarshmallowed
	path = getFormattedPath(path)
	
	var file := FileAccess.open(path, FileAccess.READ)
	
	var rawData = file.get_line()
	
	file.close()
	
	return rawData

func deMarshmallowedText(text: String) -> String:
	return Marshalls.base64_to_variant(text)






func versionOlderThan(_save_version: String, _version: String) -> bool:
	
	# _version == the version at hand, to be compared with _save version
	
	var _save_version_split = _save_version.split(".")
	var _version_split = _version.split(".")
	
	var _save = {x = int(_save_version_split[0]), y = int(_save_version_split[1]), z = int(_save_version_split[2])}
	var version = {x = int(_version_split[0]), y = int(_version_split[1]), z = int(_version_split[2])}
	
	# save version is either OLDER than version, or EQUAL to version.
	# returns TRUE if OLDER, FALSE if EQUAL
	
	if _save.x < version.x:
		return true
	if _save.y < version.y:
		return true
	if _save.z < version.z:
		return true
	
	return false

func fileExists(path: String) -> bool:
	path = getFormattedPath(path)
	return FileAccess.file_exists(path)

func getFormattedPath(path: String) -> String:
	return path if "user://" in path else "user://" + path
func LOREDifyFilename(filename: String) -> String:
	if filename.ends_with(".lored"):
		return filename
	if filename.ends_with(".loredd"):
		return filename.split(".lored")[0] + ".lored"
	if filename.ends_with(".lore"):
		return filename + "d"
	return filename + ".lored"


func setSavePath(path: String) -> void:
	path = getFormattedPath(path)
	save_path = path

func setRT():
	rt = get_node("/root/Root")

func setSaveFileColor(color: Color):
	save_file_color = color


func duplicateSave(filename: String):
	var path = getFormattedPath(filename)
	var workshopPath = getUniqueFilename(filename.split(".lored")[0] + " (Copy)")
	var newPath = getFormattedPath(LOREDifyFilename(workshopPath))
	DirAccess.copy_absolute(path, newPath)

func deleteSave(filename: String):
	
	filename = getFormattedPath(filename)
	DirAccess.remove_absolute(filename)

func importSave(rawSaveText: String, saveName := getRandomSaveFileName(), saveColor := gv.getRandomColor()):
	
	var path: String = getFormattedPath(saveName)
	
	setSaveFileColor(saveColor)
	
	var deMarshalledSave = deMarshmallowedText(rawSaveText)
	
	var data: Dictionary = str_to_var(deMarshalledSave)
	
	data["file"] = save_fileSpecificInfo()
	
	var save_text = var_to_str(data)
	var save_file = FileAccess.open(path, FileAccess.WRITE)
	save_file.store_line(Marshalls.variant_to_base64(save_text))
	save_file.close()

func getUniqueFilename(filename: String) -> String:
	
	var newFilename: String
	if filename.ends_with(".lored"):
		newFilename = filename.split(".lored")[0]
	else:
		newFilename = filename
	
	var i = 0
	while true:
		if i == 20:
			return "Are you trying to break the game?.lored"
		if fileExists(newFilename + ".lored"):
			newFilename += str(Time.get_unix_time_from_system())
			i += 1
			continue
		newFilename = LOREDifyFilename(newFilename)
		break
	
	return newFilename

func getRandomSaveFileName() -> String:
	
	var filenamePool = [
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
	]
	
	randomize()
	
	var baseFilename = filenamePool[randi() % filenamePool.size()]
	
	baseFilename = getUniqueFilename(baseFilename)
	
	return baseFilename

func renameFile(filename: String, newFilename: String):
	var path = getFormattedPath(filename)
	var newPath = getFormattedPath(newFilename)
	
	if fileExists(newPath):
		newPath = getUniqueFilename(newPath)
	
	DirAccess.rename_absolute(path, newPath)

func importedFileIsCompatible(path: String) -> bool:
	
	var rawText := getSaveText(path)
	
	if not textIsConvertibleToSave(rawText):
		return false
	
	return true



func save_vars(object) -> String:
	
	var data := {}
	var saved_vars_keys = object.get("saved_vars")
	
	for var_key in saved_vars_keys:
		
		var x = object.get(var_key)
		
		if x is Dictionary:
			data[var_key] = save_dictionary(x)
		elif x is Array:
			data[var_key] = save_array(x)
		elif x is Resource:
			if x.has_method("save"):
				data[var_key] = x.save()
			else:
				save_vars(x)
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
		elif dictionary[key] is Resource:
			if dictionary[key].has_method("save"):
				data[key] = dictionary[key].save()
			else:
				data[key] = save_vars(dictionary[key])
		else:
			data[key] = var_to_str(dictionary[key])
	
	return var_to_str(data)


func save_array(array: Array) -> String:
	
	var data := {}
	
	var i = 0
	for x in array:
		if x is Array:
			data[i] = save_array(x)
		elif x is Resource:
			var _class: String
			if x is Big:
				_class = "Big"
				data[_class + str(i)] = x.save()
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



