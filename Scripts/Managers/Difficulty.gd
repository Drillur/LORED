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
	EASY, # 5
	SONIC,
}
const DifficultyDescription := {
	Difficulty.CUSTOM: "Go wild!",
	Difficulty.MARATHON: "For freaks or excessive idling.",
	Difficulty.TORTOISE: "Slow and steady wins the race. Permanently owns Limit Break.",
	Difficulty.HARD: "For the patient.",
	Difficulty.NORMAL: "Intended values. First-time or returning players should begin here.",
	Difficulty.EASY: "For the impatient.",
	Difficulty.SONIC: "Prepare yourself for game-breaking speed. Permanently owns THE WITCH OF LOREDELITH and Limit Break; Limit Break instead affects LORED haste.",
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
	unlockedUpgrades = val



func resetAll():
	setOutput(1)
	setInput(1)
	setHaste(1)
	setCrit(0)
	setFuelCost(1)
	setFuelStorage(1)
	setUnlockedUpgrades([])

func changeDifficulty(new_diff: int):
	
	active_difficulty = new_diff
	resetAll()
	
	BuffManager.clear_queued_buffs()
	
	# You may apply buffs here. They will be applied when the game starts in Root
	#BuffManager.queue_apply_buff(BuffManager.Type.WITCH, lv.Type.STONE, {"max_ticks": -1})
	
	match active_difficulty:
		
		Difficulty.MARATHON:
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
			setHaste(0.75)
			setOutput(0.75)
			setFuelCost(2)
			setCrit(-5)
		
		Difficulty.EASY:
			setHaste(1.25)
			setFuelCost(0.5)
		
		Difficulty.SONIC:
			setUnlockedUpgrades(["Limit Break"])
	
	lv.syncLOREDs()




func getDifficultyText() -> String:
	return Difficulty.keys()[active_difficulty].capitalize()

func readAll() -> String:
	var text: String
	text += getDifficultyText() + "\n"
	for v in saved_vars:
		if v == "active_difficulty":
			continue
		text += readVal(v) + "\n"
	return text
func readVal(val: String) -> String:
	return val + ": " + str(get(val))

