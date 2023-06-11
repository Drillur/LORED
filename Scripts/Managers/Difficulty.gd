extends Node


var saved_vars := ["active_difficulty", "Output", "Input", "Haste", "Crit", "FuelCost", "FuelStorage",]


var Output := 1.0 setget setOutput
var Input := 1.0 setget setInput
var Haste := 1.0 setget setHaste
var Crit := 0.0 setget setCrit
var FuelCost := 1.0 setget setFuelCost
var FuelStorage := 1.0 setget setFuelStorage

var unlockedUpgrades := [] setget setUnlockedUpgrades

enum Difficulty {
	# new difficulties must be added at the bottom
	CUSTOM,
	MARATHON,
	HARD,
	TORTOISE,
	NORMAL, # 4
	LAZYBONES, 
	EASY, # 6
	SONIC, # 7
}
const DifficultyDescription := {
	Difficulty.CUSTOM: "Go wild!",
	Difficulty.MARATHON: "For freaks or excessive idling.",
	Difficulty.TORTOISE: "Slow and steady wins the race. Begin the game with Limit Break.",
	Difficulty.HARD: "For the patient.",
	Difficulty.NORMAL: "Intended values. First-time or returning players should begin here.",
	Difficulty.LAZYBONES: "Begin the game with every autobuyer upgrade.",
	Difficulty.EASY: "For the impatient.",
	Difficulty.SONIC: "Prepare yourself for game-breaking speed. Begin the game with Limit Break, except it instead affects LORED haste.",
}
var active_difficulty: int = Difficulty.NORMAL


func save():
	
	var data := {}
	
	for x in saved_vars:
		data[x] = var2str(get(x))
	
	return var2str(data)

func load(data: Dictionary):
	
	active_difficulty = str2var(data["active_difficulty"])
	
	if active_difficulty == Difficulty.CUSTOM:
		for x in saved_vars:
			if not x in data.keys():
				continue
			if x == "active_difficulty":
				continue
			set(x, float(str2var(data[x])))
	else:
		changeDifficulty(active_difficulty)

func setOutput(val: float):
	Output = val
func setInput(val: float):
	Input = val
func setHaste(val: float):
	Haste = val
func setCrit(val: float):
	Crit = val
func setFuelCost(val: float):
	FuelCost = val
func setFuelStorage(val: float):
	FuelStorage = val
func setUnlockedUpgrades(val: Array):
	for upgrade in unlockedUpgrades:
		lock_upgrade(upgrade, true)
	unlockedUpgrades.clear()
	for upgrade in val:
		unlock_upgrade(upgrade)



func resetAll():
	setOutput(1)
	setInput(1)
	setHaste(1)
	setCrit(0)
	setFuelCost(1)
	setFuelStorage(1)

func changeDifficulty(new_diff: int):
	
	active_difficulty = new_diff
	resetAll()
	
	BuffManager.clear_queued_buffs()
	
	# You may apply buffs here. They will be applied when the game starts in Root
	#BuffManager.queue_apply_buff(BuffManager.Type.WITCH, lv.Type.STONE, {"max_ticks": -1})
	
	match active_difficulty:
		
		Difficulty.MARATHON:
			setUnlockedUpgrades([])
			setHaste(0.25)
			setOutput(0.5)
			setInput(2)
			setFuelStorage(2)
			setFuelCost(2)
			setCrit(-100)
		
		Difficulty.TORTOISE:
			setHaste(0.1)
			setCrit(50)
			setFuelStorage(10)
			setUnlockedUpgrades(["Limit Break"])
		
		Difficulty.HARD:
			setUnlockedUpgrades([])
			setHaste(0.75)
			setOutput(0.75)
			setFuelCost(2)
			setCrit(-5)
		
		Difficulty.LAZYBONES:
			setUnlockedUpgrades([
				"we were so close, now you don't even think about me",
				"Now That's What I'm Talkin About, YeeeeeeaaaaaaaAAAAAAGGGGGHHH",
				"RED NECROMANCY",
				"Sudden Commission",
				"AUTOSENSU",
				"Master",
				"AXELOT",
				"AUTOSHIT",
				"Smashy Crashy",
				"A baby Roleum!! Thanks, pa!",
				"poofy wizard boy",
				"BENEFIT",
				"AUTOAQUATICICIDE",
				"Go on, then, LEAD us!",
				"BEEKEEPING",
				"Master Iron Worker",
				"Scoopy Doopy",
				"JOINTSHACK",
				"AROUSAL",
				"autofloof",
				"ELECTRONIC CIRCUITS",
				"AUTOBADDECISIONMAKER",
				"what kind of resource is 'tumors', you hack fraud",
				"PILLAR OF AUTUMN",
				"AUTOSMITHY",
				"DEVOUR",
				"Splishy Splashy",
				"SENTIENT DERRICK",
				"SLAPAPOW!",
				"MOUND",
				"wtf is that musk",
				"CANKERITE",
				"MOIST",
				"AUTOPOLICE",
				"SIDIUS IRON",
				"pippenpaddle- oppsoCOPolis",
				"OREOREUHBor E ALICE",
				"AUTOSTONER",
				"AUTOSHOVELER",
			])
		
		Difficulty.EASY:
			setUnlockedUpgrades([])
			setHaste(1.25)
			setFuelCost(0.5)
		
		Difficulty.SONIC:
			setUnlockedUpgrades(["Limit Break"])
	
	lv.syncLOREDs()




func getDifficultyText() -> String:
	return Difficulty.keys()[active_difficulty].capitalize()

func readAll() -> String:
	var text := ""
	text += getDifficultyText() + "\n"
	for v in saved_vars:
		if v == "active_difficulty":
			continue
		text += readVal(v) + "\n"
	return text
func readVal(val: String) -> String:
	return val + ": " + str(get(val))


func unlock_upgrade(upgrade_key: String):
	if not upgrade_key in unlockedUpgrades:
		unlockedUpgrades.append(upgrade_key)
		if gv.active_scene == gv.Scene.MAIN_MENU:
			get_node("/root/Main Menu").unlock_upgrade(upgrade_key)

func lock_upgrade(upgrade_key: String, iterating = false):
	if upgrade_key in unlockedUpgrades:
		if not iterating:
			unlockedUpgrades.erase(upgrade_key)
		if gv.active_scene == gv.Scene.MAIN_MENU:
			get_node("/root/Main Menu").lock_upgrade(upgrade_key)

