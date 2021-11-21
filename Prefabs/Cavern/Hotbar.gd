extends MarginContainer


var hotkeys := {
	"F1": "0/0",
	"F2": "0/1",
	"F3": "0/2",
	"F4": "0/3",
	"F5": "0/4",
	"1": "0/5",
	"2": "0/6",
	"3": "0/7",
	"4": "0/8",
	"5": "0/9",
	
	"Q": "1/0",
	"W": "1/1",
	"E": "1/2",
	"R": "1/3",
	"T": "1/4",
	"A": "1/5",
	"S": "1/6",
	"D": "1/7",
	"F": "1/8",
	"G": "1/9",
	
	"SHQ": "2/0",
	"SHW": "2/1",
	"SHE": "2/2",
	"SHR": "2/3",
	"SHT": "2/4",
	"SHA": "2/5",
	"SHS": "2/6",
	"SHD": "2/7",
	"SHF": "2/8",
	"SHG": "2/9",
	
	"Z": "3/0",
	"X": "3/1",
	"C": "3/2",
	"V": "3/3",
	"B": "3/4",
	"SHZ": "3/5",
	"SHX": "3/6",
	"SHC": "3/7",
	"SHV": "3/8",
	"SHB": "3/9",
}
var spells := {
	"0/0": -1,
	"0/1": -1,
	"0/2": -1,
	"0/3": -1,
	"0/4": -1,
	"0/5": -1,
	"0/6": -1,
	"0/7": -1,
	"0/8": -1,
	"0/9": -1,
	
	"1/0": -1,
	"1/1": -1,
	"1/2": -1,
	"1/3": -1,
	"1/4": -1,
	"1/5": -1,
	"1/6": -1,
	"1/7": -1,
	"1/8": -1,
	"1/9": -1,
	
	"2/0": -1,
	"2/1": -1,
	"2/2": -1,
	"2/3": -1,
	"2/4": -1,
	"2/5": -1,
	"2/6": -1,
	"2/7": -1,
	"2/8": -1,
	"2/9": -1,
	
	"3/0": -1,
	"3/1": -1,
	"3/2": -1,
	"3/3": -1,
	"3/4": -1,
	"3/5": -1,
	"3/6": -1,
	"3/7": -1,
	"3/8": -1,
	"3/9": -1,
}





func save() -> String:
	
	var data := {}
	
	data["hotkeys"] = saveHotkeys()
	data["spells"] = saveSpells()
	
	return var2str(data)

func load(raw_data: String):
	
	var data = str2var(raw_data)
	
	loadHotkeys(data["hotkeys"])
	loadSpells(data["spells"])

func saveHotkeys() -> String:
	return var2str(hotkeys)
func loadHotkeys(raw_data: String) -> void:
	var data = str2var(raw_data)
	
	for x in data:
		hotkeys[x] = data[x]

func saveSpells() -> String:
	return var2str(spells)
func loadSpells(raw_data: String):
	var data = str2var(raw_data)
	
	for x in data:
		spells[x] = data[x]



func setup():
	
	setHotkeyText()
	setSpells()

func setHotkeyText():
	
	for x in hotkeys:
		var path = "m/g/" + hotkeys[x]
		get_node(path).setHotkeyText(x)

func setSpells():
	for x in spells:
		setSpell(x, spells[x])

func setSpell(path: String, spell_type: int):
	get_node("m/g/" + path).setSpell(spell_type)
	
