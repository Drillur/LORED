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







# find out when to actually LOAD.
#on boot?
#after boot done?
#at the end of _ready in Root?
#probly that last one




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

func save_fileSpecificInfo() -> String:
	
	var data := {}
	
	data["game version"] = ProjectSettings.get_setting("application/config/Version")
	
	for x in saved_vars:
		if get(x) is Big:
			data[x] = get(x).save()
		else:
			data[x] = var2str(get(x))
	
	data["difficulty"] = diff.active_difficulty
	
	return var2str(data)

func load_fileSpecificInfo(data: Dictionary):
	
	game_version = data["game version"]
	
	for x in saved_vars:
		
		if not x in data.keys():
			continue
		
		if get(x) is Big:
			get(x).load(data[x])
		else:
			set(x, str2var(data[x]))






func load(path := save_path) -> bool:
	
	save_path = path
	
	var data := getSaveData(path)
	
	if data == {} or not "root" in data.keys():
		return false
	
	load_fileSpecificInfo(str2var(data["file"]))
	
	gv.load(str2var(data["stats"]))
	rt._load(str2var(data["root"]))
	
	return true

func getSaveData(path: String) -> Dictionary:
	
	var data: String
	
	var save_file = File.new()
	if not save_file.file_exists(path):
		return {}
	
	save_file.open(path, File.READ)
	
	data = Marshalls.base64_to_variant(save_file.get_line())
	
	save_file.close()
	
	return str2var(data)








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
	return filename if ".lored" in filename else filename + ".lored"


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
	var newPath = getFormattedPath(workshopPath + ".lored")
	var dir = Directory.new()
	dir.copy(path, newPath)

func getUniqueFilename(filename: String) -> String:
	
	var formattedFilename: String
	
	var i = 0
	while true:
		formattedFilename = filename + ".lored" if not ".lored" in filename else filename
		if fileExists(formattedFilename):
			filename += String(randi() % 1000000)
			i += 1
			if i == 20:
				return "Are you trying to break the game?.lored"
			continue
		break
	
	return filename

func renameFile(filename: String, newFilename: String):
	var path = getFormattedPath(filename)
	var newPath = getFormattedPath(newFilename)
	var dir = Directory.new()
	dir.rename(path, newPath)



func loadGame(filename: String, _saveFileColor: Color):
	
	setSavePath(filename)
	setSaveFileColor(_saveFileColor)
	Boot.go()
	get_tree().change_scene("res://Scenes/Root.tscn")



func loadSavedVars(saved_vars: Dictionary, save_data: Dictionary) -> Dictionary:
	
	var loadedVars := {}
	
	for x in saved_vars:
		
		if not x in save_data.keys():
			continue
		
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


























































































#func e_save(type := "normal", path := SAVE.SLOT0):
#
#	var save := _save.new()
#
#	# menu and stats
#	if true:
#
#		for e in emote_events:
#			save.data[e] = emote_events[e]
#
#		save.game_version = ProjectSettings.get_setting("application/config/Version")
#
#		for x in gv.run.size():
#			save.data["gv.run" + str(x) + "]"] = gv.runx]
#			save.data["stats.last_run_dur[" + str(x) + "]"] = gv.last_run_dur[x]
#			save.data["stats.last_reset_clock[" + str(x) + "]"] = gv.last_reset_clock[x]
#		save.data["cur_clock"] = cur_clock
#		save.data["times game loaded"] = times_game_loaded
#
#		for x in gv.option:
#			save.data["option " + x] = gv.option[x]
#			if x == "on_save_menu_options" and not gv.option[x]: break
#
#		save.data["time_played"] = gv.time_played
#		save.data["tasks_completed"] = gv.tasks_completed
#
#		save.data["most_resources_gained"] = gv.most_resources_gained.toScientific()
#		save.data["highest_run"] = gv.highest_run
#
#		for x in gv.last_reset_clock.size():
#			save.data["save last reset clock " + String(x)] = gv.last_reset_clock[x]
#
#	save.data["wish data"] = taq.save()
#
#	# upgrades
#	if true:
#
#		if gv.up["Limit Break"].active():
#			save.data["Limit Break d"] = gv.up["Limit Break"].effects[0].effect.a.toScientific()
#			save.data["Limit Break xpf"] = gv.lb_xp.f.toScientific()
#			save.data["Limit Break xpt"] = gv.lb_xp.t.toScientific()
#
#		if gv.up["I DRINK YOUR MILKSHAKE"].active():
#			save.data["[I DRINK YOUR MILKSHAKE] e0"] = gv.up["I DRINK YOUR MILKSHAKE"].effects[0].effect.a.toScientific()
#
#		if gv.up["IT'S GROWIN ON ME"].active():
#			save.data["[IT'S GROWIN ON ME] e0"] = gv.up["IT'S GROWIN ON ME"].effects[0].effect.a.toScientific()
#			save.data["[IT'S GROWIN ON ME] e1"] = gv.up["IT'S GROWIN ON ME"].effects[1].effect.a.toScientific()
#
#		if gv.up["IT'S SPREADIN ON ME"].active():
#			save.data["[IT'S SPREADIN ON ME] e0"] = gv.up["IT'S SPREADIN ON ME"].effects[0].effect.a.toScientific()
#			save.data["[IT'S SPREADIN ON ME] e1"] = gv.up["IT'S SPREADIN ON ME"].effects[1].effect.a.toScientific()
#
#		for x in gv.up:
#			save.data["[" + x + "] have"] = gv.up[x].have
#			save.data["[" + x + "] refundable"] = gv.up[x].refundable
#			save.data["[" + x + "] unlocked"] = gv.up[x].unlocked
#			save.data["[" + x + "] times_purchased"] = gv.up[x].times_purchased
#
#	# resources
#	save.data["resources"] = gv.saveResources()
#
#	# loreds
#	save.data["LOREDs"] = get_node(gnLOREDs).saveLOREDs()
#
#
#	# fin & misc
#	if true:
#
#		save.data["game version"] = save.game_version
#
#		var save_file = File.new()
#
#		match type:
#			"normal":
#
#				# create SAVE
#				save_file.open(SAVE[gv.active_slot], File.WRITE)
#				save_file.store_line(Marshalls.variant_to_base64(save.data))
#				save_file.close()
#
#			"export":
#
#				# create SAVE
#				save_file.open(path, File.WRITE)
#				save_file.store_line(Marshalls.variant_to_base64(save.data))
#				save_file.close()
#
#			"print to console":
#				print("Your LORED save data is below! Click Expand, if necessary, for your save may be very large, and then save it in any text document!")
#				print(Marshalls.variant_to_base64(save.data))
#
#		w_aa()
#
#func e_load(path := SAVE[gv.active_slot]) -> bool:
#
#	if gv.stored_path != "":
#		path = gv.stored_path
#		gv.stored_path = ""
#		print("Loading from \"", path, "\".")
#
#	var save_file = File.new()
#	var save := _save.new()
#
#	# file shit
#	if true:
#
#		if not save_file.file_exists(path):
#			return false
#
#		# load from base64
#		save_file.open(path, File.READ)
#
#		var save_lines := []
#
#		save_lines.append(save_file.get_line())
#		save_lines.append(save_file.get_line())
#
#		if len(save_lines[0]) < 20:
#			save.game_version = save_lines[0]
#			save.data =  Marshalls.base64_to_variant(save_lines[1])
#		else:
#			save.data =  Marshalls.base64_to_variant(save_lines[0])
#			save.game_version = save.data["game version"]
#
#		save_file.close()
#
#	if "1" == save.game_version[0]:
#		print("Save incompatible; from 1.2c or earlier.\nWhat the heck, have you really not played since then? Welcome back, jeez!")
#		return false
#
#	var pre_beta_4 := false
#	if "(" in save.game_version:
#		var beta_version = save.game_version.split("(")[1].split(")")[0]
#		if int(beta_version) <= 3:
#			pre_beta_4 = true
#
#	var keys = save.data.keys()
#
#	load_stats(save.data, keys, pre_beta_4)
#	if "resources" in keys:
#		gv.loadResources(str2var(save.data["resources"]))
#	load_upgrades(save.data, keys)
#	load_loreds(save.data, save.game_version, keys)
#
#
#	if "wish data" in keys:
#		taq._load(save.data["wish data"])
#
#	patched = version_older_than(save.game_version, ProjectSettings.get_setting("application/config/Version")) if gv.option["patch alert"] else false
#	# this, to the computer, could look like this:
#	# patched = false if false else false
#
#	if version_older_than(save.game_version, "2.2.4"):
#		gv.option["FPS"] = 2
#
#	# X.Y.Z
#	# 2.1.0
#	# 1.2c
#
#	# shit that needs to be done before offline earnings
#	if true:
#
#		# limit break
#		if true:
#
#			activate_lb_effects()
#
#	#offline_earnings(min(cur_clock - save.data["cur_clock"] - 30, 604800))
#
#	w_total_per_sec(cur_clock - save.data["cur_clock"] - 30)
#
#	return true
#
#func load_stats(data: Dictionary, keys: Array, pre_beta_4: bool):
#
#	for e in emote_events:
#		if e in keys:
#			emote_events[e] = data[e]
#
#	for x in gv.run.size():
#		if "gv.run" + str(x) + "]" in keys:
#			gv.runx] = data["gv.run" + str(x) + "]"]
#		if "stats.last_run_dur[" + str(x) + "]" in keys:
#			gv.last_run_dur[x] = data["stats.last_run_dur[" + str(x) + "]"]
#		if "stats.last_reset_clock[" + str(x) + "]" in keys:
#			gv.last_reset_clock[x] = data["stats.last_reset_clock[" + str(x) + "]"]
#	times_game_loaded = data["times game loaded"] + 1
#
#	for x in gv.option:
#
#		if not "option " + x in keys: continue
#		if gv.PLATFORM == "browser" and x == "performance": continue
#
#		gv.option[x] = data["option " + x]
#		if x == "on_save_menu_options" and not gv.option[x]: break
#
#
#
#	gv.time_played = data["time_played"]
#	gv.tasks_completed = data["tasks_completed"]
#
#	if "highest_run" in keys:
#		gv.highest_run = data["highest_run"]
#
#	for x in gv.last_reset_clock.size():
#		if not ("save last reset clock " + str(x)) in keys: continue
#		gv.last_reset_clock[x] = data["save last reset clock " + str(x)]
#
#
#
#	if pre_beta_4:
#
#		if "most_resources_gained" in keys:
#			gv.most_resources_gained = Big.new(fval.f(data["most_resources_gained"]))
#
#		return
#
#	if "most_resources_gained" in keys:
#		gv.most_resources_gained = Big.new(data["most_resources_gained"])
#
#func load_upgrades(data: Dictionary, keys: Array):
#
#	if "Limit Break d" in keys:
#		gv.up["Limit Break"].effects[0].effect.a = Big.new(data["Limit Break d"])
#		gv.up["Limit Break"].sync_effects()
#		gv.lb_xp.t = Big.new(data["Limit Break xpt"])
#		gv.lb_xp.f = Big.new(data["Limit Break xpf"])
#		gv.emit_signal("limit_break_leveled_up", "color")
#
#	if "[I DRINK YOUR MILKSHAKE] e0" in keys:
#		gv.up["I DRINK YOUR MILKSHAKE"].effects[0].effect.a = Big.new(data["[I DRINK YOUR MILKSHAKE] e0"])
#
#	if "[IT'S GROWIN ON ME] e0" in keys:
#		gv.up["IT'S GROWIN ON ME"].effects[0].effect.a = Big.new(data["[IT'S GROWIN ON ME] e0"])
#		gv.up["IT'S GROWIN ON ME"].effects[1].effect.a = Big.new(data["[IT'S GROWIN ON ME] e1"])
#
#	if "[IT'S SPREADIN ON ME] e0" in keys:
#		gv.up["IT'S SPREADIN ON ME"].effects[0].effect.a = Big.new(data["[IT'S SPREADIN ON ME] e0"])
#		gv.up["IT'S SPREADIN ON ME"].effects[1].effect.a = Big.new(data["[IT'S SPREADIN ON ME] e1"])
#
#	for x in gv.up:
#
#		if not "[" + x + "] have" in keys: continue
#
#		gv.up[x].have = data["[" + x + "] have"]
#		if gv.up[x].have and gv.up[x].normal:
#			gv.list.upgrade["unowned " + str(gv.up[x].tab)].erase(x)
#		gv.up[x].refundable = data["[" + x + "] refundable"]
#		if "[" + x + "] times_purchased" in keys:
#			gv.up[x].times_purchased = data["[" + x + "] times_purchased"]
#		if "[" + x + "] unlocked" in keys:
#			gv.up[x].unlocked = data["[" + x + "] unlocked"]
#
#		if not gv.up[x].refundable:
#			if gv.up[x].active():
#				gv.up[x].apply()
#			continue
#
#		gv.up[x].refund()
#
#	for x in gv.up:
#		gv.up[x].sync()
#		if not gv.up[x].have:
#			continue
#		gv.list.upgrade["owned " + str(gv.up[x].tab)].append(gv.up[x].key)
#
#func load_loreds(data: Dictionary, game_version: String, keys: Array):
#
#	if version_older_than(game_version, "3.0.0"):
#
#		print("Save version: ", game_version, "; converting save.")
#
#		var LORED_data := {}
#
#		for x in gv.g:
#
#			if not "g" + x + " active" in keys:
#				continue
#
#			var pack := {}
#
#			if "g" + x + " times_purchased" in keys:
#				pack["times_purchased"] = data["g" + x + " times_purchased"]
#
#			pack["active"] = data["g" + x + " active"]
#
#			if "g" + x + " key" in keys:
#				pack["key_lored"] = data["g" + x + " key"]
#
#			if not pack["active"]:
#				continue
#
#			pack["level"] = data["g" + x + " level"]
#
#			if "g" + x + " halt" in keys:
#				pack["halt"] = data["g" + x + " halt"]
#			if "g" + x + " hold" in keys:
#				pack["hold"] = data["g" + x + " hold"]
#
#			pack["fuel"] = var2str(Big.new(data["g" + x + " fuel"]))
#
#			LORED_data[x] = var2str(pack)
#
#		data["LOREDs"] = var2str(LORED_data)
#
#	get_node(gnLOREDs).loadLOREDs(str2var(data["LOREDs"]))
