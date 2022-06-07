extends Node


var modifier_lored_output := 1.0 setget setOutput, getOutput
var modifier_lored_input := 1.0 setget setInput, getInput
var modifier_lored_haste := 1.0 setget setHaste, getHaste
var modifier_lored_crit_add := 0.0 setget setCritAdd, getCritAdd
var modifier_lored_crit := 1.0 setget setCrit, getCrit
var modifier_lored_fuel_consumption := 1.0 setget setFuelConsumption, getFuelConsumption
var modifier_lored_fuel_storage := 1.0 setget setFuelStorage, getFuelStorage

enum Difficulty {
	# new difficulties must be added at the bottom
	CUSTOM,
	MARATHON,
	HARD,
	NORMAL,
	TORTOISE,
	EASY,
	SPEEDRUN,
	HACKS,
}
const DifficultyDescription := {
	Difficulty.CUSTOM: "Go wild!",
	Difficulty.MARATHON: "For freaks or excessive idling.",
	Difficulty.HARD: "For the patient.",
	Difficulty.NORMAL: "Intended values. First-time or returning players should begin here.",
	Difficulty.TORTOISE: "Slow and steady wins the race.",
	Difficulty.EASY: "For the impatient.",
	Difficulty.SPEEDRUN: "Warp 1. Engage.",
	Difficulty.HACKS: "~dev_mode = true~",
}
var active_difficulty = Difficulty.NORMAL


func setOutput(val: float):
	modifier_lored_output = val
func getOutput() -> float:
	return modifier_lored_output

func setInput(val: float):
	modifier_lored_input = val
func getInput() -> float:
	return modifier_lored_input

func setHaste(val: float):
	modifier_lored_haste = val
func getHaste() -> float:
	return modifier_lored_haste

func setCritAdd(val: float):
	modifier_lored_crit_add = val
func getCritAdd() -> float:
	return modifier_lored_crit_add

func setCrit(val: float):
	modifier_lored_crit = val
func getCrit() -> float:
	return modifier_lored_crit

func setFuelConsumption(val: float):
	modifier_lored_fuel_consumption = val
func getFuelConsumption() -> float:
	return modifier_lored_fuel_consumption

func setFuelStorage(val: float):
	modifier_lored_fuel_storage = val
func getFuelStorage() -> float:
	return modifier_lored_fuel_storage


func resetAll():
	setOutput(1)
	setInput(1)
	setHaste(1)
	setCritAdd(0)
	setCrit(1)
	setFuelConsumption(1)
	setFuelStorage(1)

func changeDifficulty(new_diff: int):
	
	#zhere ^
	
	active_difficulty = new_diff
	resetAll()
	
	match active_difficulty:
		
		Difficulty.MARATHON:
			setHaste(0.25)
			setOutput(0.5)
			setInput(2)
			setFuelStorage(2)
			setFuelConsumption(2)
			setCrit(0)
		
		Difficulty.HARD:
			setHaste(0.5)
			setOutput(0.5)
			setFuelConsumption(2)
			setCrit(0.5)
		
		Difficulty.TORTOISE:
			setHaste(0.1)
			setCritAdd(35)
		
		Difficulty.EASY:
			setHaste(2)
			setFuelConsumption(0.5)
		
		Difficulty.SPEEDRUN:
			setHaste(2)
			setOutput(2)
			setInput(0.5)
			setCrit(2)
		
		Difficulty.HACKS:
			setHaste(5)
			setInput(0)
			setCritAdd(100)
	
	gv.syncLOREDs()



func getDifficultyText() -> String:
	return Difficulty.keys()[active_difficulty].capitalize()
