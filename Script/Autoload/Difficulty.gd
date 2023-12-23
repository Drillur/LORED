extends Node



var saved_vars := [
	"active_difficulty",
	#"output", "input", "haste", "crit", "fuel", "fuel_cost",
]


enum Type {
	CUSTOM,
	MARATHON,
	HARD,
	TORTOISE,
	NORMAL, # 4
	LAZYBONES, 
	EASY, # 6
	SONIC, # 7
}



class DifficultyValues:
	
	var type: int
	var key: String
	
	var description: String
	var output := 1.0
	var input := 1.0
	var fuel := 1.0
	var fuel_cost := 1.0
	var haste := 1.0
	var crit := 0.0
	
	var upgrades: Array[Upgrade]
	var applied := false
	
	
	
	func _init(_type: Type) -> void:
		type = _type
		key = df.Type.keys()[type]
		call("init_" + key)
		df.active_difficulty.changed.connect(difficulty_changed)
	
	#region Init
	
	func init_CUSTOM() -> void:
		description = "Go wild!"
	
	
	func init_MARATHON() -> void:
		description = "For freaks or excessive idling."
		output = 0.5
		input = 2
		fuel = 2
		fuel_cost = 2
		haste = 0.25
		crit = -5
	
	
	func init_TORTOISE() -> void:
		description = "Slow and steady wins the race. Begin the game with Limit Break."
		fuel = 10
		haste = 0.1
		crit = 50
		add_upgrade(Upgrade.Type.LIMIT_BREAK)
	
	
	func init_HARD() -> void:
		description = "For the patient."
		output = 0.75
		fuel_cost = 2
		haste = 0.75
	
	
	func init_NORMAL() -> void:
		description = "Intended values. First-time or returning players should begin here."
	
	
	func init_LAZYBONES() -> void:
		description = "Begin the game with every autobuyer upgrade."
		add_upgrade(Upgrade.Type.WE_WERE_SO_CLOSE)
		add_upgrade(Upgrade.Type.NOW_THATS_WHAT_IM_TALKIN_ABOUT)
		add_upgrade(Upgrade.Type.RED_NECROMANCY)
		add_upgrade(Upgrade.Type.SUDDEN_COMMISSION)
		add_upgrade(Upgrade.Type.AUTOSENSU)
		add_upgrade(Upgrade.Type.MASTER)
		add_upgrade(Upgrade.Type.AXELOT)
		add_upgrade(Upgrade.Type.AUTOSHIT)
		add_upgrade(Upgrade.Type.SMASHY_CRASHY)
		add_upgrade(Upgrade.Type.A_BABY_ROLEUM)
		add_upgrade(Upgrade.Type.POOFY_WIZARD_BOY)
		add_upgrade(Upgrade.Type.BENEFIT)
		add_upgrade(Upgrade.Type.AUTOAQUATICIDE)
		add_upgrade(Upgrade.Type.GO_ON_THEN_LEAD_US)
		add_upgrade(Upgrade.Type.BEEKEEPING)
		add_upgrade(Upgrade.Type.MASTER_IRON_WORKER)
		add_upgrade(Upgrade.Type.SCOOPY_DOOPY)
		add_upgrade(Upgrade.Type.JOINTSHACK)
		add_upgrade(Upgrade.Type.AROUSAL)
		add_upgrade(Upgrade.Type.AUTOFLOOF)
		add_upgrade(Upgrade.Type.ELECTRONIC_CIRCUITS)
		add_upgrade(Upgrade.Type.AUTOBADDECISIONMAKER)
		add_upgrade(Upgrade.Type.WHAT_KIND_OF_RESOURCE_IS_TUMORS)
		add_upgrade(Upgrade.Type.PILLAR_OF_AUTUMN)
		add_upgrade(Upgrade.Type.AUTOSMITHY)
		add_upgrade(Upgrade.Type.DEVOUR)
		add_upgrade(Upgrade.Type.SPLISHY_SPLASHY)
		add_upgrade(Upgrade.Type.SENTIENT_DERRICK)
		add_upgrade(Upgrade.Type.SLAPAPOW)
		add_upgrade(Upgrade.Type.MOUND)
		add_upgrade(Upgrade.Type.WTF_IS_THAT_MUSK)
		add_upgrade(Upgrade.Type.CANKERITE)
		add_upgrade(Upgrade.Type.MOIST)
		add_upgrade(Upgrade.Type.AUTOPOLICE)
		add_upgrade(Upgrade.Type.SIDIUS_IRON)
		add_upgrade(Upgrade.Type.PIPPENPADDLE_OPPSOCOPOLIS)
		add_upgrade(Upgrade.Type.OREOREUHBOREALICE)
		add_upgrade(Upgrade.Type.AUTOSTONER)
		add_upgrade(Upgrade.Type.AUTOSHOVELER)
	
	
	func init_EASY() -> void:
		description = "For the impatient."
		fuel_cost = 0.5
		haste = 1.25
	
	
	func init_SONIC() -> void:
		description = "Prepare yourself for game-breaking speed! Begin the game with Limit Break, except it instead affects Haste."
		add_upgrade(Upgrade.Type.LIMIT_BREAK)
	
	#endregion
	
	
	# - Internal
	
	
	func add_upgrade(_upgrade_type: Upgrade.Type) -> void:
		upgrades.append(up.get_upgrade(_upgrade_type))
	
	
	
	# - Signal
	
	
	func difficulty_changed() -> void:
		if df.active_difficulty.get_value() == type:
			df.output.set_to(output)
			df.input.set_to(input)
			df.fuel.set_to(fuel)
			df.fuel_cost.set_to(fuel_cost)
			df.haste.set_to(haste)
			df.crit.set_to(crit)
	
	
	
	# - Action
	
	func apply_upgrades() -> void:
		for upgrade in upgrades:
			upgrade.unlocked.set_default_value(true)
			upgrade.purchased.set_default_value(true)
			upgrade.unlocked.reset()
			upgrade.purchased.reset()
			upgrade.apply()
	
	
	func remove_upgrades() -> void:
		for upgrade in upgrades:
			upgrade.remove()
			upgrade.unlocked.set_default_value(false)
			upgrade.purchased.set_default_value(false)
			upgrade.unlocked.reset()
			upgrade.purchased.reset()



var output := LoudFloat.new(1.0)
var input := LoudFloat.new(1.0)
var fuel := LoudFloat.new(1.0)
var fuel_cost := LoudFloat.new(1.0)
var haste := LoudFloat.new(1.0)
var crit := LoudFloat.new(0.0)

var prev_output := 1.0
var prev_input := 1.0
var prev_fuel := 1.0
var prev_fuel_cost := 1.0
var prev_haste := 1.0
var prev_crit := 0.0

var description: String

var diffs := []

var active_difficulty := LoudInt.new(Type.NORMAL)



func _ready():
	for diff in Type.values():
		diffs.append(DifficultyValues.new(diff))





# - Action


func change_difficulty(new_difficulty: Type):
	if active_difficulty.equal(new_difficulty):
		return
	prev_output = output.get_value()
	prev_input = input.get_value()
	prev_fuel = fuel.get_value()
	prev_fuel_cost = fuel_cost.get_value()
	prev_haste = haste.get_value()
	prev_crit = crit.get_value()
	diffs[active_difficulty.get_value()].remove_upgrades()
	active_difficulty.set_to(new_difficulty)
	diffs[active_difficulty.get_value()].apply_upgrades()
