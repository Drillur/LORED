class_name Quest
extends Reference



var key: int
var name: String

var random: bool
var ready := false
var managed := false
var complete := false

var desc := ""
var icon_key := ""
var color_key := "grey"

var rewards := []
var objectives := []

var save_data := {}

var required_objectives: int
var completed_objectives := 0

var icon: Texture

var color: Color

var total_progress: Big
var current_progress := Big.new(0)

var manager: MarginContainer




class Reward:

	var type: int

	var key: String
	var icon_key: String
	var color_key := "grey"
	var description: String

	var color: Color
	var icon: Texture

	var includes_amount := false
	var amount: Big

	func _init(_type: int, _key: String, _amount = false):
		
		type = _type
		key = _key

		assumeIcon()
		assumeColor()
		assumeDescription()
		
		if typeof(_amount) != TYPE_BOOL:
			amount = Big.new(_amount)
			includes_amount = true

	func assumeIcon():
		if key in gv.sprite.keys():
			setIcon(key)

	func assumeColor():
		if icon_key in gv.COLORS.keys():
			setColor(icon_key)

	func setIcon(_icon_key: String):
		icon_key = _icon_key
		icon = gv.sprite[icon_key]

	func setColor(_color_key: String):
		color_key = _color_key
		color = gv.COLORS[color_key]

	func assumeDescription():
		match type:
			gv.QuestReward.RESOURCE:
				setDescription(gv.g[key].name)

	func setDescription(_description: String):
		description = _description
	
	func turnIn():
		match type:
			gv.QuestReward.RESOURCE:
				gv.r[key].a(amount)
				taq.increaseProgress(gv.Objective.RESOURCES_PRODUCED, key, amount)
			gv.QuestReward.TAB:
				gv.emit_signal("quest_reward", type, key)
			gv.QuestReward.MAX_TASKS:
				taq.max_tasks += 1
			gv.QuestReward.OTHER:
				gv.emit_signal("quest_reward", type, str(key))
			gv.QuestReward.NEW_LORED:
				gv.g[key].unlock()


class Objective:

	var type: int

	var key: String
	var icon_key: String
	var color_key := "grey"
	var description: String

	var color: Color
	var icon: Texture

	var complete := false

	var current_progress := Big.new(0)
	var required_progress: Big

	func _init(_type: int, _key: String, _required_progress = 1) -> void:

		type = _type
		key = _key

		assumeIcon()
		assumeColor()
		setDescription()

		required_progress = Big.new(_required_progress)

		checkComplete()
	
	func checkComplete():
		match type:
			gv.Objective.UPGRADE_PURCHASED:
				if gv.up[key].have:
					setComplete()

	func matchingTypes(_type: int) -> bool:
		return type == _type

	func matchingKeys(_key: String) -> bool:
		if key == "any":
			return true
		return key == _key

	func increaseProgress(amount: Big):
		current_progress.a(amount)
		checkProgress()

	func checkProgress():
		if current_progress.greater_equal(required_progress):
			setComplete()

	func setComplete():
		current_progress = Big.new(required_progress)
		complete = true

	func assumeIcon():
		match type:
			gv.Objective.TASKS_COMPLETED, gv.Objective.RARE_OR_SPIKE_TASKS_COMPLETED:
				setIcon("copy")
			gv.Objective.RESOURCES_PRODUCED, gv.Objective.LORED_UPGRADED:
				if key == "any":
					setIcon(str(gv.Tab.S1))
					return
				setIcon(key)
			gv.Objective.UPGRADE_PURCHASED:
				setIcon(gv.up[key].icon)

	func assumeColor():
		if key in gv.COLORS.keys():
			setColor(key)
		
	func setIcon(_icon_key: String):
		icon_key = _icon_key
		icon = gv.sprite[icon_key]

	func setColor(_color_key: String):
		color_key = _color_key
		color = gv.COLORS[color_key]

	func setDescription() -> void:
		
		match type:
			gv.Objective.RESOURCES_PRODUCED:
				if key == "any":
					description = "Combined resources produced"
				else:
					if key in gv.g.keys():
						description = gv.g[key].name + " produced"
					else:
						description = key.capitalize() + " produced"
			gv.Objective.SPELL_CAST_COUNT:
				description = key + " cast"
			gv.Objective.RARE_OR_SPIKE_TASKS_COMPLETED:
				description = "Rare or spike tasks completed"
			gv.Objective.TASKS_COMPLETED:
				description = "Tasks completed"
			gv.Objective.UPGRADE_PURCHASED:
				description = key + " purchased"
			gv.Objective.LORED_UPGRADED:
				description = gv.g[key].name + " LORED upgraded"
			gv.Objective.UPGRADES_PURCHASED:
				var bla = {str(gv.Tab.NORMAL): "Normal", str(gv.Tab.MALIGNANT): "Malignant",
					str(gv.Tab.EXTRA_NORMAL): "Extra-normal", str(gv.Tab.RADIATIVE): "Radiative",
					str(gv.Tab.RUNED_DIAL): "Runed Dial", str(gv.Tab.SPIRIT): "Spirit"
				}
				description = "%s upgrades purchased" % bla[key]
			_:
				description = ""






func _init(_key: int, _manager = 0, pack := {}) -> void:
	
	key = _key
	
	setManager(_manager)
	
	if intendToLoadTask():
		loadTask(pack)
		return
	
	random = key >= gv.Quest.RANDOM
	
	if random:
		initRandomQuest()
	else:
		initMainQuest()
	
	infer_icon_key()
	set_icon()
	required_objectives = objectives.size()
	if color_key == "grey":
		if icon_key in gv.COLORS.keys():
			color_key = icon_key
	color = gv.COLORS[color_key]
	set_total_progress()
	
	if not random:
		if pack.size() != 0:
			loadQuest(pack)
	
	for o in objectives:
		if o.complete:
			completed_objectives += 1
	
	# do not call checReady() here

func initMainQuest():
	
	match key:
		
		gv.Quest.MORE_INTRO:
			
			name = "More Intro!"
			
			objectives.append(Objective.new(gv.Objective.RESOURCES_PRODUCED, "stone", "10"))
			
			rewards.append(Reward.new(gv.QuestReward.RESOURCE, "stone", "20"))
			rewards.append(Reward.new(gv.QuestReward.RESOURCE, "iron", "20"))
			rewards.append(Reward.new(gv.QuestReward.RESOURCE, "cop", "10"))
			
			rewards.append(Reward.new(gv.QuestReward.NEW_LORED, "iron"))
			rewards.append(Reward.new(gv.QuestReward.NEW_LORED, "cop"))
			rewards.append(Reward.new(gv.QuestReward.NEW_LORED, "irono"))
			rewards.append(Reward.new(gv.QuestReward.NEW_LORED, "copo"))
		
		gv.Quest.INTRO:

			name = "Intro!"
			desc = "Your Stone LORED requires fuel to work. Buy a Coal LORED with the Stone you began with."

			objectives.append(Objective.new(gv.Objective.LORED_UPGRADED, "coal"))

			rewards.append(Reward.new(gv.QuestReward.RESOURCE, "stone", "10"))

func initRandomQuest():
	pass

func infer_icon_key():
	if icon_key == "":
		icon_key = objectives[0].icon_key

func set_icon():
	icon = gv.sprite[icon_key]

func set_total_progress() -> void:
	total_progress = Big.new(0)
	for o in objectives:
		total_progress.a(o.required_progress)


func setManager(_manager: MarginContainer) -> void:
	manager = _manager
	managed = true



func save(position_in_loop := -1) -> Dictionary:
	if random:
		return saveTask(position_in_loop)
	return saveQuest()

func saveQuest() -> Dictionary:
	
	var data := {}
	
	data["main quest key"] = str(key)
	data["main quest objective count"] = str(objectives.size())
	
	for i in objectives.size():
		var key = "main quest objective " + str(i) + " current progress"
		data[key] = objectives[i].current_progress.toScientific()
	
	return data

func saveTask(position_in_loop := -1) -> Dictionary:

	var data := {}
	var base_key = "task " + str(position_in_loop)

	data[base_key + " name"] = name
	data[base_key + " key"] = str(key)
	data[base_key + " icon key"] = icon_key
	data[base_key + " position in loop"] = str(position_in_loop)
	
	data[base_key + " objective count"] = str(objectives.size())
	for i in objectives.size():
		var objective_key = base_key + " objective " + str(i)
		data[objective_key + " type"] = str(objectives[i].type)
		data[objective_key + " key"] = objectives[i].key
		data[objective_key + " current progress"] = objectives[i].current_progress.toScientific()
		data[objective_key + " required progress"] = objectives[i].required_progress.toScientific()

	data[base_key + " reward count"] = str(rewards.size())
	for i in rewards.size():
		var reward_key = base_key + " reward " + str(i)
		data[reward_key + " type"] = str(rewards[i].type)
		data[reward_key + " key"] = rewards[i].key
		data[reward_key + " amount"] = rewards[i].amount.toScientific()
	
	return data


func intendToLoadTask() -> bool:
	return key == gv.Quest.LOAD

func loadTask(pack: Dictionary):

	name = pack["name"]
	key = pack["key"]
	icon_key = pack["icon key"]
	icon = gv.sprite[icon_key]
	
	for o in pack["objective count"]:
		objectives.append(Objective.new(pack["objective " + str(o) + " type"], pack["objective " + str(o) + " key"], pack["objective " + str(o) + " required progress"]))
		total_progress.a(objectives[o].required_progress)
		objectives[o].increaseProgress(pack["objective " + str(o) + " current progress"])
		# does not get increased progress from offline earnings here
	
	for r in pack["reward count"]:
		rewards.append(Reward.new(pack["reward " + str(r) + " type"], pack["reward " + str(r) + " key"], pack["reward " + str(r) + " amount"]))
	
	match key:
		gv.Quest.RANDOM_COMMON:
			color_key = "common"
		gv.Quest.RANDOM_RARE:
			color_key = "rare"
		gv.Quest.RANDOM_SPIKE:
			color_key = "spike"
	
	color = gv.COLORS[color_key]

func loadQuest(pack: Dictionary):
	# done after Quest init
	for i in objectives.size():
		objectives[i].current_progress = Big.new(pack["main quest objective " + str(i) + " current progress"])
		objectives[i].checkProgress()

func checkIfReady():
	if ready:
		return
	if completed_objectives >= required_objectives:
		setReady()

func setReady():
	ready = true
	completed_objectives = required_objectives
	current_progress = Big.new(total_progress)
	manager.ready()

func increaseProgress(_type: int, _key: String, amount: Big):
	
	var objective_progressed := false
	
	for o in objectives:
		if o.complete:
			continue
		if not o.matchingTypes(_type):
			continue
		if not o.matchingKeys(_key):
			continue

		o.increaseProgress(amount)
		if o.complete:
			completed_objectives += 1
		
		if not objective_progressed:
			objective_progressed = true

	if objective_progressed:
		progressIncreased()

func progressIncreased():
	checkIfReady()
	if not ready:
		syncProgress()

func syncProgress():
	current_progress = Big.new(0)
	for o in objectives:
		current_progress.a(o.current_progress)
	rUpdate()

func rUpdate():
	if managed:
		manager.rUpdate()


func flashIncompleteObjectives():
	if not managed:
		return
	if is_instance_valid(manager.rt.get_node("global_tip").tip):
		manager.rt.get_node("global_tip").tip.cont["taq"].flash()

func isReady() -> bool:
	return ready

func turnIn():
	
	if complete:
		return
	
	complete = true
	if not random:
		taq.completed_quests.append(key)
	
	if random:
		gv.stats.tasks_completed += 1
		#@increaseProgressOfTasksCompletedQuest()
	
	giveRewards()

func giveRewards():
	
	for r in rewards:
		r.turnIn()
	if key in taq.key_quest_rewards:
		for r in taq.key_quest_rewards[key]:
			r.turnIn()

#func increaseProgressOfTasksCompletedQuest():
#
#	if key in [gv.Quest.RANDOM_RARE, gv.Quest.RANDOM_SPIKE]:
#		taq.increaseProgress(gv.Objective.RARE_OR_SPIKE_TASKS_COMPLETED)
#	elif not _load:
#		taq.increaseProgress(gv.Objective.TASKS_COMPLETED)
