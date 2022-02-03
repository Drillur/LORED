extends MarginContainer


const PRE := "m/g/"

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

var spell_paths := {} # ex: -1: ["0/0", "2/3"]

var spell_queue: Array

#var gcd: move the gcd from spellbutton to here. it makes more sense. just do it. idk. i hate this.





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

func setSpell(path: String, spell: int):
	
	get_node("m/g/" + path).setSpell(spell)
	
	if spell == -1:
		return
	
	if not spell in spell_paths:
		spell_paths[spell] = []
	
	spells[path] = spell
	
	spell_paths[spell].append(path)

func spellCast(spell: int, cooldown: float):
	
	if not spell in spell_paths:
		return
	
	for x in spell_paths[spell]:
		
		get_node("m/g/" + x).startTimer(cooldown)



func input(ev):
	
	if ev.is_action_pressed("1"):
		queueCast(spells[hotkeys["1"]])
		return
	
	if ev.is_action_pressed("2"):
		queueCast(spells[hotkeys["2"]])
		return
	
	if ev.is_action_pressed("3"):
		queueCast(spells[hotkeys["3"]])
		return
	
	if ev.is_action_pressed("4"):
		queueCast(spells[hotkeys["4"]])
		return

func queueCast(spell: int, target: Unit = gv.warlock):
	
	if spell == -1:
		return
	
	# from deleted code, but is still smart. may be useful.
	#	if not Cav.spell[spell].requires_target:
	#	var target = yield(Cav, "spell_target_confirmed")
	
	spell_queue = [spell, target]
	
	checkIfQueuedCastShouldWaitOrCancel()

func checkIfQueuedCastShouldWaitOrCancel():
	
	if not Cav.spell[spell_queue[0]].isAvailable():
		holdCastUntilCooldownEnds()
		return
	
	if gv.warlock.casting:
		holdCastUntilCastingFinishes()
		return
	
	if not gv.warlock.gcd.isAvailable():
		holdCastUntilGCDEnds()
		return
	
	cast()

func holdCastUntilCooldownEnds():
	
	var path = spell_paths[spell_queue[0]][0]
	var time_remaining = get_node(PRE + path).getTimerTimeRemaining()
	
	if not gv.warlock.gcd.isAvailable():
		if time_remaining < um.getGCDRemaining():
			holdCastUntilGCDEnds()
			return
	
	if time_remaining > 0.5:
		spell_queue.clear()
		return
	
	if sm.getCastRemaining() > 0.5:
		spell_queue.clear()
		return
	
	while true:
		if not spellQueued():
			return
		if yield(gv, "cooldown_completed") == spell_queue[0]:
			break
	#print("Yielded for cooldown")
	cast()

func holdCastUntilCastingFinishes():
	if sm.getCastRemaining() > 0.5:
		spell_queue.clear()
		return
	yield(gv, "casting_completed")
	#print("Yielded for cast")
	
	if not spellQueued():
		return
	
	if Cav.spell[spell_queue[0]].canCast(gv.warlock):
		cast(true)
		return
	
	# if cannot currently cast the spell,
	# wait 1 frame. the completion of the cast that triggered this method
	# may change that.
	
	var tt = Timer.new()
	add_child(tt)
	tt.start(0.05)
	yield(tt, "timeout")
	tt.queue_free()
	
	cast()

func holdCastUntilGCDEnds():
	if um.getGCDRemaining() > 0.5:
		spell_queue.clear()
		return
	yield(gv, "gcd_stopped")
	#print("Yielded for gcd")
	cast()

func cast(known_to_be_able_to_cast := false):
	if not spellQueued():
		return
	gv.warlock.cast(spell_queue[0], spell_queue[1], known_to_be_able_to_cast)
	spell_queue.clear()

func spellQueued() -> bool:
	return spell_queue.size() > 0

func reset(tier: int):
	
	for path in spells:
		if spells[path] == -1:
			continue
		get_node(PRE + path).reset(tier)
