extends Node


var rt = 0


# items will save in multiple ways:
# 1. Every 30 sec.
# 2. On value change.
# 3. On load.


var save_path: String
var save_data := {}

var saved_vars := ["save_file_color",]
var game_version := "" # the game version according to the last file loaded from

var save_file_color: Color

var patched := false

signal gameSaved



var save: Save




func save(path := save_path, type := "normal"):
	
	if path != save_path:
		path = getFormattedPath(path)
		save_path = path
	
	var data := {}
	
	data["file"] = save_fileSpecificInfo()
	data["stats"] = gv.save()
	if gv.active_scene == gv.Scene.ROOT:
		data["root"] = rt.save()
	
	var save_text = var2str(data)
	var save_file = File.new()
	
	#type = "debug" #note
	match type:
		"normal":
			# create SAVE
			save_file.open(path, File.WRITE)
			save_file.store_line(Marshalls.variant_to_base64(save_text))
			save_file.close()
		
		"export":
			
			# create SAVE
			save_file.open(path, File.WRITE)
			save_file.store_line(Marshalls.variant_to_base64(save_text))
			save_file.close()
		
		"print to console":
			print("Your LORED save data is below! Click Expand, if necessary, for your save may be very large, and then save it in any text document!")
			print(Marshalls.variant_to_base64(save_text))
		
		"debug":
			save_file.open(path, File.WRITE)
			save_file.store_line(save_text)
			save_file.close()
	
	emit_signal("gameSaved")
	gv.lastSaveClock = OS.get_unix_time()

func load(path := save_path) -> bool:
	
	# returns successful load
	
	save_path = path
	
	var data := getSaveData(path)
	
	if not dataIsCompatibleSave(data):
		return false
	
	load_fileSpecificInfo(str2var(data["file"]))
	
	gv.load(str2var(data["stats"]))
	rt._load(str2var(data["root"]))
	
	return true


func loadNewGame(filename: String, _saveFileColor: Color):
	loadGame(filename, _saveFileColor)
	
	var t = Timer.new()
	add_child(t)
	t.start(1)
	yield(t, "timeout")
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
			data[x] = var2str(get(x))
	
	data["difficulty"] = diff.save()
	
	return var2str(data)

func load_fileSpecificInfo(data: Dictionary):
	
	game_version = data["game version"]
	
	diff.load(str2var(data["difficulty"]))
	
	for x in saved_vars:
		
		if not x in data.keys():
			continue
		
		if get(x) is Big:
			get(x).load(data[x])
		else:
			set(x, str2var(data[x]))


func textIsConvertibleToSave(text: String) -> bool:
	
	var marshalledText = deMarshmallowedText(text)
	if marshalledText == null:
		return false
	if marshalledText is Dictionary:
		return false
	
	var textAsVar = str2var(marshalledText)
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
	
	var save_file = File.new()
	if not save_file.file_exists(path):
		return {}
	
	save_file.open(path, File.READ)
	
	data = deMarshmallowedText(save_file.get_line())
	
	save_file.close()
	
	return str2var(data)

func getSaveText(path: String) -> String:
	
	# is not unmarshmallowed
	path = getFormattedPath(path)
	
	var file = File.new()
	file.open(path, File.READ)
	
	var rawData = file.get_line()
	
	file.close()
	
	return rawData

func deMarshmallowedText(text: String) -> String:
	return Marshalls.base64_to_variant(text)






func versionOlderThan(_save_version: String, _version: String) -> bool:
	
	# _version == the version at hand, to be compared with _save version
	
	var _save_version_split = _save_version.split(".")
	var _version_split = _version.split(".")
	
	var save = {x = int(_save_version_split[0]), y = int(_save_version_split[1]), z = int(_save_version_split[2])}
	var version = {x = int(_version_split[0]), y = int(_version_split[1]), z = int(_version_split[2])}
	
	# save version is either OLDER than version, or EQUAL to version.
	# returns TRUE if OLDER, FALSE if EQUAL
	
	if save.x < version.x:
		return true
	if save.y < version.y:
		return true
	if save.z < version.z:
		return true
	
	return false

func fileExists(path: String) -> bool:
	path = getFormattedPath(path)
	var save_file = File.new()
	return save_file.file_exists(path)

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
	var dir = Directory.new()
	dir.copy(path, newPath)

func deleteSave(filename: String):
	
	filename = getFormattedPath(filename)
	
	var dir = Directory.new()
	dir.remove(filename)

func importSave(rawSaveText: String, saveName := getRandomSaveFileName(), saveColor := gv.getRandomColor()):
	
	var path: String = getFormattedPath(saveName)
	
	setSaveFileColor(saveColor)
	
	var deMarshalledSave = deMarshmallowedText(rawSaveText)
	
	var data: Dictionary = str2var(deMarshalledSave)
	
	data["file"] = save_fileSpecificInfo()
	
	var save_text = var2str(data)
	var save_file = File.new()
	
	save_file.open(path, File.WRITE)
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
			newFilename += String(randi() % 1000000)
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
	
	var baseFilename = filenamePool[randi() % filenamePool.size()]
	
	baseFilename = SaveManager.getUniqueFilename(baseFilename)
	
	return baseFilename

func renameFile(filename: String, newFilename: String):
	var path = getFormattedPath(filename)
	var newPath = getFormattedPath(newFilename)
	
	if fileExists(newPath):
		newPath = getUniqueFilename(newPath)
	
	var dir = Directory.new()
	dir.rename(path, newPath)

func importedFileIsCompatible(path: String) -> bool:
	
	var rawText := getSaveText(path)
	
	if not textIsConvertibleToSave(rawText):
		return false
	
	return true





func loadSavedVars(saved_vars: Dictionary, save_data: Dictionary) -> Dictionary:
	
	var loadedVars := {}
	
	for x in saved_vars:
		
		if not x in save_data.keys():
			continue
		ResourceSaver
		if saved_vars[x] is Big:
			loadedVars[x] = Big.new(save_data[x])
			continue
		
		if saved_vars[x] is Dictionary:
			loadedVars[x] = str2var(save_data[x])
			for key in saved_vars[x]:
				if not key in loadedVars[x]:
					loadedVars[x][key] = saved_vars[x][key]
			continue
		
		loadedVars[x] = str2var(save_data[x])
	
	return loadedVars



