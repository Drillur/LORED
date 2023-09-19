extends Node



var saved_vars := [
	"active_difficulty",
	"output", "input", "haste", "crit", "fuel", "fuel_cost",
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
	
	var upgrades := []
	
	
	
	func _init(_type: int) -> void:
		type = _type
		key = df.Type.keys()[type]
	
	
	func init_CUSTOM() -> void:
		description = "Go wild!"
		
	
	
	
	func init_MARATHON() -> void:
		description = "For freaks or excessive idling."
		output = 0.5
		input = 2
		fuel = 2
		fuel_cost = 2
		haste = 0.25
		crit = -100
	
	
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
		crit = -5
	
	
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
	
	
	
	func add_upgrade(_upgrade_type: int) -> void:
		pass
		#upgrades.append(up.get_upgrade(upgrade_type))



var output := Big.new(1, true)
var input := Big.new(1, true)
var fuel := Big.new(1, true)
var fuel_cost := Big.new(1, true)
var haste := Big.new(1, true)
var crit := Big.new(0, true)

var description: String

var diffs := []

var active_difficulty := Type.NORMAL



func _ready():
	for diff in Type.values():
		diffs.append(DifficultyValues.new(diff))


func poop():
	return
