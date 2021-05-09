extends Node

# access with taq

var quest = 0
var multi_quests := []
var cur_quest := -1

var max_tasks := 0
var cur_tasks := 0
var task := []

var task_manager: HBoxContainer

var content = 0





func new_quest(_quest: Task) -> void:
	
	quest = _quest
	cur_quest = quest.key
	
	content = gv.SRC["task"].instance()
	get_node("/root/Root/m/v/bot/h/taq/quest").add_child(content)
	content.init(quest)
	
	quest.check_already_complete()


func progress(type: int, req_key := "", amount = Big.new(1)) -> void:
	
	# tasks
	for t in task:
		t.progress(type, req_key, amount)
	
	# quest
	if cur_quest != -1:
		quest.progress(type, req_key, amount)
	
	# multi quests
	for q in multi_quests:
		q.progress(type, req_key, amount)


func add_multi_quests(quests: Array) -> void:
	
	for q in quests:
		if not q in multi_quests:
			
			gv.g[q.name.to_lower()].upgrade_quest = q
			q.manager = gv.g[q.name.to_lower()].manager
			multi_quests.append(q)
#
#func get_task_code() -> int:
#
#	var i = 0
#
#	if cur_tasks == 0:
#		return i
#
#	for t in task:
#		if i == t.code
func generate_task_name(lored : String, roll := 0) -> String:
	
	roll = randi() % 3
	
	match lored:
		"glass":
			match roll:
				0:
					return "Fall of Reach"
				1:
					return "shame about that there planet(s)"
				2:
					return "First Strike"
		"wood":
			match roll:
				0:
					return "Quit acting demicky, Virginia."
				1:
					return "DEFEATING A SANDWICH ONLY MAKES IT TASTIER"
				2:
					return "yo the naavi aint gon lik dis"
		"gale":
			match roll:
				0:
					return "Greasy Jack"
				1:
					return "Bouncy Boy"
				2:
					return "ayayayayayayayayayayaya"
		"ciga":
			match roll:
				0:
					return "Marlboro Massacre"
				1:
					return "Pall Mall Suicide"
				2:
					return "Nicotine Death"
				3:
					return "Tax on the Stupid"
		"toba":
			match roll:
				0:
					return "white shores"
				1:
					return "the Green Dragon"
				2:
					return "Mead and Hearth"
		"liq":
			match roll:
				0:
					return "SUPER> HOT. SUPER> HOT. SUPER> HOT."
				1:
					return "Liquid Conquest"
				2:
					return "bonk"
		"sand":
			match roll:
				0:
					return "It's Coarse, and Rough, and Irritating, and it Gets Everywhere"
				1:
					return "SANDY CHEEKS DUH"
				2:
					return "The LORED Wars"
		"humus":
			roll = randi() % 4
			match roll:
				0:
					return "nobody even knows what this is"
				1:
					return "what is this, horse shit?"
				2:
					return "OK Google. Define \"horse shit\"."
				3:
					return "A Horse With No Name"
		"soil":
			roll = randi() % 4
			match roll:
				0:
					return "d"
				1:
					return "i"
				2:
					return "r"
				3:
					return "t"
		"tree":
			match roll:
				0:
					return "acrobatic stuff"
				1:
					return "What is this, Minecraft?"
				2:
					return "MAGNETIC ACCELERATOR TREE SEEDS"
		"seed":
			match roll:
				0:
					return "What is this, Stardew Valley?"
				1:
					return "nobody even gardens in real life"
				2:
					return "the bee life is the life for me"
		"water":
			match roll:
				0:
					return "Splish Splash Take a Bath"
				1:
					return "Rainydaywriter"
				2:
					return "Dribbly Doobly"
		"coal":
			match roll:
				0:
					return "Coallector"
				1:
					return "Thirsty Boi!"
				2:
					return "Smudgey"
		"stone":
			match roll:
				0:
					return "Stoneheart"
				1:
					return "Stoneard"
				2:
					return "Stonebridge"
		"irono":
			match roll:
				0:
					return "Schploopty"
				1:
					return "Light Em Up!"
				2:
					return "Fire!"
		"copo":
			match roll:
				0:
					return "Mine!!"
				1:
					return "Picker!"
				2:
					return "Put Your Back Into It!"
		"iron":
			match roll:
				0:
					return "Irony"
				1:
					return "I AM the LORED."
				2:
					return "Smelt it."
		"cop":
			match roll:
				0:
					return "Copaloppy"
				1:
					return "Get to the Copper"
				2:
					return "Orange!"
		"growth":
			match roll:
				0:
					return "ew"
				1:
					return "It's not a growth!"
				2:
					return "Tummy"
		"conc":
			match roll:
				0:
					return "Conky"
				1:
					return "Cement"
				2:
					return "Snap"
		"jo":
			match roll:
				0:
					return "TESLA!!"
				1:
					return "ELECTRICITY"
				2:
					return "PHYSICS"
		"malig":
			match roll:
				0:
					return "That's cancer, dude."
				1:
					return "Stage Eleven"
				2:
					return "GoopyDoopy"
		"tar":
			match roll:
				0:
					return "Make That Tar Slap"
				1:
					return "Jiggle that Jangle"
				2:
					return "Wobble Bobble"
		"oil":
			match roll:
				0:
					return "Slurp!"
				1:
					return "Delicious!"
				2:
					return "Suck faster!"
		"steel":
			match roll:
				0: return "Pounder"
				1: return "Corona Blacksmith"
				2: return "For the Steelless"
		"axe":
			match roll:
				0: return "Quantity Over Quality"
				1: return "Automataxed"
				2: return "Factory Axes"
		"hard":
			match roll:
				0: return "OnlyHardwoodFans"
				1: return "Hardhat Zone"
				2: return "Free $10k Life Insurance!"
		"wire":
			match roll:
				0: return "Knickers"
				1: return "Cookies"
				2: return "Have Some Lunch!"
		"draw":
			match roll:
				0: return "Doodley"
				1: return "Paper or Electronic?"
				2: return "Ctrl-Z in Bulk"
		"pulp":
			match roll:
				0: return "Jus' securin' my jerb, hyere."
				1: return "don'tchu dare say a bad word about my truck"
				2: return "http://FarmerMingle.com"
		"carc":
			roll = randi() % 4
			match roll:
				0: return "Pretty sure that thing's evil"
				1: return "Devil's Dance"
				2: return "Vial"
				3: return "Masochism"
				4: return "Instigate"
		"lead":
			match roll:
				0: return "What is that, a magnet?"
				1: return "Why's that guy so mad?"
				2: return "He's just standing there... menacingly!"
		"pet":
			match roll:
				0: return "BASTARD FROM A BASKET!"
				1: return "A COMPETITION"
				2: return "I hate most people."
		"paper":
			match roll:
				0: return "Pen and Paper"
				1: return "Papers, Please"
				2: return "Paper Man"
		"tum":
			match roll:
				0: return "What is this, cancer?"
				1: return "Rumblies that only Tumors will satisfy"
				2: return "Perfectly safe!"
		"plast":
			match roll:
				0: return "I'll carry your stuff, no problem!"
				1: return "Environment-friendly"
				2: return "I've got this task in the bag!"
	
	match roll:
		0:
			return "placeholder0"
		1:
			return "placeholder1"
	
	return "placeholder2"


func hit_max_tasks():
	while taq.cur_tasks < taq.max_tasks:
		add_task(Task.new(gv.Quest.RANDOM))

func add_task(_task: Task) -> void:
	
	task.append(_task)
	
	task_manager.add_task(_task)
	
	taq.cur_tasks += 1
