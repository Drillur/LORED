class_name Wish
extends Reference

var saved_vars := [
	"key", "name", "giver", "help_text", "thank_text",
	"color_key", "random", "ready",
]

var key: String

var name := ""
var giver: String
var giverName: String
var giverColor: Color

var help_text: String
var thank_text: String
var help_expression := "angry"
var thank_expression := "test"

var rewards := 0

var random: bool
var ready := false
var exists := true
#var major_wish: bool
var complete := false

var color: Color
var color_key: String

var obj: Objective # objective
var rew: Array # rewards
var key_rew: Array

var vico: MarginContainer
var vico_set := false
signal vico_just_set
var tooltip: MarginContainer
var tooltip_active := false






class Objective:
	
	var saved_vars := ["type", "key", "current_count", "required_count", "complete", "icon_key"]
	
	var type: int
	var key: String
	var shorthandKey: String
	
	var current_count: Big = Big.new(0)
	var required_count: Big = Big.new(1)
	
	var complete := false
	
	var icon_key: String
	
	
	func _init(_type: int, _key: String, _count := "0"):
		
		if _type == -1:
			_load(str2var(_key))
			return
		
		type = _type
		key = _key
		
		if _count == "0":
			assumeCount()
		else:
			required_count = Big.new(_count)
		
		assumeIconKey()
		
		if alreadyComplete():
			complete()
	
	
	func save() -> String:
		
		var data := {}
		
		for x in saved_vars:
			if get(x) is Big:
				data[x] = get(x).save()
			else:
				data[x] = var2str(get(x))
		
		return var2str(data)

	func _load(data: Dictionary):
		
		for x in saved_vars:
			
			if not x in data.keys():
				continue
			
			if get(x) is Big:
				get(x).load(data[x])
			else:
				set(x, str2var(data[x]))
	
	
	func alreadyComplete() -> bool:
		
		match type:
			gv.Objective.UPGRADE_PURCHASED:
				return gv.up[key].have
		
		return false
	
	func assumeIconKey():
		if icon_key != "":
			return
		if type == gv.Objective.LORED_UPGRADED:
			shorthandKey = lv.lored[int(key)].shorthandKey
			setIconKey(shorthandKey)
		elif type == gv.Objective.MAXED_FUEL_STORAGE:
			shorthandKey = gv.shorthandByResource[lv.lored[int(key)].fuelResource]
			setIconKey(shorthandKey)
		elif type == gv.Objective.RESOURCES_PRODUCED:
			shorthandKey = gv.shorthandByResource[int(key)]
			setIconKey(shorthandKey)
		elif key in gv.sprite:
			setIconKey(key)
		elif type == gv.Objective.UPGRADE_PURCHASED:
			setIconKey(gv.up[key].icon)
	
	func setIconKey(_icon_key: String):
		icon_key = _icon_key
	
	func assumeCount():
		match type:
			gv.Objective.MAXED_FUEL_STORAGE:
				required_count = Big.new(75)
			_:
				required_count = Big.new(1)
	
	func parseCount() -> String:
		if complete:
			if required_count.equal(1):
				return "1/1"
			return "Complete!"
		if type == gv.Objective.MAXED_FUEL_STORAGE:
			return fval.f(current_count.percent(75) * 100) + "%"
		
		return current_count.toString() + "/" + required_count.toString()
	
	func parseObjective() -> String:
		
		match type:
			gv.Objective.RESOURCES_PRODUCED:
				return "Collect " + gv.resourceName[int(key)]
			gv.Objective.LORED_UPGRADED:
				return "Upgrade " + lv.lored[int(key)].name
			gv.Objective.UPGRADE_PURCHASED:
				return "Purchase " + gv.up[key].name
			gv.Objective.MAXED_FUEL_STORAGE:
				return lv.lored[int(key)].name + " at 75% fuel"
			gv.Objective.BREAK:
				return "Relax"
			gv.Objective.HOARD:
				return "Hoard!"
		
		print_debug("Wish parseObjective() fail. Type: ", type)
		return "Oops!"

	func complete():
		complete = true

	func match(_type: int, _key: String) -> bool:
		return _key == key and _type == type

	func increaseCount(amount: Big):
		if complete:
			return
		current_count.a(amount)
		checkIfComplete()
	
	func setCount(amount: Big):
		if complete:
			return
		current_count = Big.new(amount)
		checkIfComplete()
	
	func checkIfComplete():
		if current_count.greater_equal(required_count):
			complete()
		current_count.capMax(required_count)

class Reward:
	
	var saved_vars = ["type", "key", "amount"]
	
	var type: int
	
	var key: String
	
	var amount: Big = Big.new(0)
	
#	var icon_key: String
	
	
	func _init(_type: int, _key: String, _amount = 1):
		
		if _type == -1:
			# in this case, _key is save data.
			_load(str2var(_key))
			return
		
		type = _type
		key = _key
		amount = Big.new(_amount)
	
	
	func save() -> String:
		
		var data := {}
		
		for x in saved_vars:
			if get(x) is Big:
				data[x] = get(x).save()
			else:
				data[x] = var2str(get(x))
		
		return var2str(data)

	func _load(data: Dictionary):
		
		for x in saved_vars:
			
			if not x in data.keys():
				continue
			
			if get(x) is Big:
				get(x).load(data[x])
			else:
				set(x, str2var(data[x]))
	
	
	func turnIn():
		match type:
			gv.WishReward.RESOURCE:
				gv.addToResource(int(key), amount)
				taq.increaseProgress(gv.Objective.RESOURCES_PRODUCED, key, amount)
			gv.WishReward.NEW_LORED:
				lv.lored[int(key)].unlock()
			gv.WishReward.TAB:
				if key == str(gv.Tab.EXTRA_NORMAL):
					if not gv.haveLoredsRequiredForExtraNormalUpgradeMenu():
						return
				gv.emit_signal("wishReward", type, key)
			gv.WishReward.MAX_RANDOM_WISHES:
				taq.max_random_wishes += amount.toFloat()
			gv.WishReward.AUTOMATED:
				if key == str(gv.WishReward.HALT_AND_HOLD):
					taq.automatedHaltAndHold = true
				elif key == str(gv.WishReward.WISH_TURNIN):
					taq.automatedCompletion = true
			gv.WishReward.EASIER:
				taq.easier = true








func save() -> String:
	
	var data := {}
	
	for x in saved_vars:
		data[x] = var2str(get(x))
	
	data["obj"] = obj.save()
	
	data["rewards"] = {}
	for r in rew:
		data["rewards"][r] = r.save()
	
	return var2str(data)

func _load(data: Dictionary):
	
	for x in saved_vars:
		
		if not x in data.keys():
			continue
		
		if get(x) is Big:
			get(x).load(data[x])
		else:
			set(x, str2var(data[x]))
	
	obj = Objective.new(-1, data["obj"])
	
	var reward_data = data["rewards"]
	
	for r in reward_data:
		rew.append(Reward.new(-1, reward_data[r]))
	
	rewards = rew.size()
	
	
	setColor(color_key)




func _init(_key: String, data: Dictionary = {}):
	
	if _key == "load":
		
		_load(data)
	
	else:
		
		key = _key
		
		random = key == "random"
		
		var construct_method = "construct_" + key
		call(construct_method)
		
		assumeName()
		assumeColor()
		
		#major_wish = key != "random"
		rewards = rew.size()
	
	if obj.icon_key == "":
		obj.setIconKey(giver)
	
	if alreadyComplete():
		obj.complete()
	
	giverName = lv.lored[int(giver)].name
	giverColor = lv.lored[int(giver)].color

func alreadyComplete():
	# different from Objective.alreadyComplete
	if key == "upgrade_stone":
		if lv.lored[lv.Type.STONE].level >= 2:
			return true

func assumeName():
	if name != "":
		return
	name = key.capitalize()

func assumeColor():
	if obj.type == gv.Objective.MAXED_FUEL_STORAGE:
		setColor(gv.shorthandByResource[lv.lored[int(obj.key)].fuelResource])
		return
	if obj.type == gv.Objective.LORED_UPGRADED:
		setColor(lv.lored[int(obj.key)].shorthandKey)
		return
	if obj.type == gv.Objective.RESOURCES_PRODUCED:
		setColor(gv.shorthandByResource[int(obj.key)])
		return
	if obj.key in gv.COLORS.keys():
		setColor(obj.key)
		return
	setColor("common")

func setColor(_color: String):
	if "," in _color:
		color = Color(_color)
	else:
		color_key = _color
		color = gv.COLORS[color_key]


func setTooltip(_tooltip: MarginContainer):
	tooltip = _tooltip
	tooltip_active = true

func clearTooltip():
	tooltip_active = false

func setVico(_vico: MarginContainer):
	vico = _vico
	vico.wish = self
	vico_set = true
	emit_signal("vico_just_set")



func die(inform_taq := true):
	vico.hide()
	exists = false
	if tooltip_active:
		vico._on_Button_mouse_exited()
	if random:
		taq.random_wishes -= 1
	if inform_taq:
		# false when called from wishManager.gd
		taq.wishDied(self)


func increaseCount(_type: int, _key: String, amount):
	
	if not exists:
		return
	
	if obj.match(_type, _key):
		amount = Big.new(amount)
		obj.increaseCount(amount)
		checkIfReady()

func setCount(_count: Big):
	obj.setCount(_count)
	checkIfReady()

func checkIfReady():
	if obj.complete:
		ready()
	else:
		if is_instance_valid(vico):
			vico.update()
	

func ready():
	
	#print("---------------ready called")
	if not is_instance_valid(vico):
		return
	
	ready = true
	vico.ready()
	
	if taq.automatedCompletion:
		# don't care about the tooltip. it's gonna go away anyway
		return
	
	if tooltip_active:
		if not is_instance_valid(tooltip):
			clearTooltip()
			return
		tooltip.updateDialogueAndExpression()
		tooltip.updateRandomVisibility()

func turnIn():
	
	complete = true
	
	for r in rew:
		r.turnIn()
	
	taq.wishCompleted(self)
	
	gv.resource[gv.Resource.JOY].a(1)
	taq.increaseProgress(gv.Objective.RESOURCES_PRODUCED, str(gv.Resource.JOY))
	
	die()


























func construct_autocomplete():
	giver = str(lv.Type.OIL)
	help_text = "Gahoogie!!! Snaffle. Hehehe~"
	thank_text = "*farts and poops*"
	obj = Objective.new(gv.Objective.UPGRADE_PURCHASED, "THE WITCH OF LOREDELITH")
	rew.append(Reward.new(gv.WishReward.AUTOMATED, str(gv.WishReward.WISH_TURNIN)))
	key_rew.append(Reward.new(gv.WishReward.AUTOMATED, str(gv.WishReward.WISH_TURNIN)))
func construct_easier():
	giver = str(lv.Type.PAPER)
	help_text = "Well, hey, there! It's me again! Paper Boy! Haha. Just kiddin. I mean, that is my name, but I know you wouldn't forget my name, so I was just kiddin about that part. You have better conduct than that! Haha. Just kiddin. Uh, well, I guess I'm actually not kiddin.\n\nHey, anyway, talkin about conduct, I think it might be a good idea to get that! The upgrade! The Conduct upgrade! Yeah. So, you probably should, but don't let me boss you around! Haha. Just kiddin. Er, I mean, uh.. Wait, what was I kiddin about?\n\nAnyway, hey, if you haven't done one of those Chemotherapy things yet, uh, I think it might be a good idea to wait a bit! Yeah. You should definitely get some Radiative upgrades that boost Stage 2 because, jeez la weez, Stage 2 is pretty hard, huh?! I sure couldn't walk ten billion miles in your shoes! Haha. Hahaha!!! Just kiddin!!! Hahahah..\n\nI mean, I really couldn't, though."
	thank_text = "I am a sucker for proper conduct! Haha. Just kiddin."
	obj = Objective.new(gv.Objective.UPGRADE_PURCHASED, "CONDUCT")
	rew.append(Reward.new(gv.WishReward.EASIER, "10"))
	key_rew.append(Reward.new(gv.WishReward.EASIER, "10"))

func construct_ciorany():
	giver = str(lv.Type.WATER)
	help_text = "I'm actually in [i]shock[/i] at how many you were able to gather!!! And it didn't take you [i]UNDEFINED[/i] years, like it took Seeds and Trees and I!!!"
	thank_text = "I'm so happy :')"
	obj = Objective.new(gv.Objective.UPGRADE_PURCHASED, "Cioran")
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.TUMORS), "1000"))
func construct_maliggy():
	giver = str(lv.Type.MALIGNANCY)
	help_text = "Hey, don't forget about us!! We're still relevant!!! D':"
	thank_text = "Whew. :)"
	obj = Objective.new(gv.Objective.RESOURCES_PRODUCED, str(gv.Resource.MALIGNANCY), "1e9")
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.TUMORS), "1000"))
func construct_tumory():
	giver = str(lv.Type.TUMORS)
	help_text = "You read that right, buddy. Five grand. Cough em up. Chop chop. We've got people to infect."
	thank_text = "Delicious."
	obj = Objective.new(gv.Objective.RESOURCES_PRODUCED, str(gv.Resource.TUMORS), "5000")
	rew.append(Reward.new(gv.WishReward.TAB, str(gv.Tab.RADIATIVE)))
	key_rew.append(Reward.new(gv.WishReward.TAB, str(gv.Tab.RADIATIVE)))

func construct_carcy():
	giver = str(lv.Type.CARCINOGENS)
	help_text = "Excuse my appearance, I'm actually pretty likeable once you get to know me. Just give me one puff. C'mon. You won't regret it."
	thank_text = "Sucker."
	obj = Objective.new(gv.Objective.UPGRADE_PURCHASED, "Sagan")
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.STEEL), "1000"))
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.GLASS), "1000"))
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.HARDWOOD), "1000"))
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.WIRE), "1000"))

func construct_plasty():
	giver = str(lv.Type.PLASTIC)
	help_text = "I'm a plastic bag."
	thank_text = "[i]*crinkle*"
	obj = Objective.new(gv.Objective.RESOURCES_PRODUCED, str(gv.Resource.PLASTIC), "100")
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.HUMUS), "1000"))
	rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.CARCINOGENS)))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.CARCINOGENS)))
func construct_papey():
	giver = str(lv.Type.PAPER)
	help_text = "Well, hey, there! I'm Paper Boy. Your local neighborhood Paper Boy! Hahah! Just kiddin. Who am I, Spider-man? Haha! Just kiddin. If anything, I'd be Spider-boy. Haha! Just kiddin. But, anyway, yeah, so, like I was sayin, hi there!\n\nIf you need any help figuring out how we work together up here, ask me anytime! Also, try checkin the hold button, on account that it shows who else is using their stuff. Like, look at Pulp! It'll say I use his stuff. That's on account of the fact that I do use his stuff! Haha! Just kiddin. I mean, I do actually, but the way I said it was weird, so I was just kiddin about that part. Haha. Just kiddin. I mean, not really. Okay, yeah, so, anyway. Cya around!"
	thank_text = "Thanks bunches, pal! Haha."
	obj = Objective.new(gv.Objective.RESOURCES_PRODUCED, str(gv.Resource.PAPER), "100")
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.AXES), "1000"))
	rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.TOBACCO)))
	rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.CIGARETTES)))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.TOBACCO)))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.CIGARETTES)))

func construct_galey():
	giver = str(lv.Type.GALENA)
	help_text = "W-w-w-w-wo-o-u-u-u-l-l-d-d-d y-y-y-o-o-o-u-u-u-u g-g-g-g-g-g-get s-s-s-o-o-m-m-m-e L-L-L-E-E-E-A-A-A-D?"
	thank_text = "A-h-o-o-o-o-o-o-o-o-o-oh-oh-oh-oh-oh-oh-h-h-h-e-e-e-e-e-e"
	obj = Objective.new(gv.Objective.RESOURCES_PRODUCED, str(gv.Resource.LEAD), "100")
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.AXES), "100"))
	rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.PAPER)))
	rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.WOOD_PULP)))
	rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.PETROLEUM)))
	rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.PLASTIC)))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.PAPER)))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.WOOD_PULP)))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.PETROLEUM)))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.PLASTIC)))

func construct_horsey():
	giver = str(lv.Type.HUMUS)
	help_text = "Neigh!"
	thank_text = "Whinny."
	obj = Objective.new(gv.Objective.LORED_UPGRADED, "humus")
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.WATER), "500"))
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.WOOD), "500"))
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.LIQUID_IRON), "500"))
	rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.LEAD)))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.LEAD)))
func construct_steely():
	giver = str(lv.Type.STEEL)
	help_text = "No doubt you'll need lots of [i]me[/i] to progress! Hahaheyyy!"
	thank_text = "Sick!"
	obj = Objective.new(gv.Objective.LORED_UPGRADED, str(lv.Type.STEEL))
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.WATER), "500"))
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.WOOD), "500"))
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.LIQUID_IRON), "500"))
	rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.GALENA)))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.GALENA)))
func construct_joy3():
	giver = str(lv.Type.IRON)
	help_text = "Our new friends are so cool! I'm glad we can all come together and have fun. Let's get some more joy!\n\nWhat's automated halt and hold? I don't know. Is there a time where you have to manually click on halt or hold?"
	thank_text = "Yay! Automatic halty hold! Whatever that is!"
	obj = Objective.new(gv.Objective.RESOURCES_PRODUCED, str(gv.Resource.JOY), "10")
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.WATER), "500"))
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.WOOD), "500"))
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.LIQUID_IRON), "500"))
	rew.append(Reward.new(gv.WishReward.AUTOMATED, str(gv.WishReward.HALT_AND_HOLD)))
	key_rew.append(Reward.new(gv.WishReward.AUTOMATED, str(gv.WishReward.HALT_AND_HOLD)))

func construct_treey():
	giver = str(lv.Type.TREES)
	help_text = "Woohoo! There's a ton of friends here, now!! That's CrAzy!!!\n\nSoil's here, too!! My favorite thing in the [i]whole void!![/i] I need Soil's soil to get [i]stronger!!!![/i]\n\nAlso, listen to this. It's crazy. Those four are in a loop. They all require each other to work. I'm talking about Steel, Hardwood, Wire, and Glass. Each of the four have their own branch. Hardwood is the worst. She has a loop of her own, and I'm not talking about her earrings. More like she's loopy! Ha!! She's got a loop in her own loop. It's super confusing!!! [i]It's crazy!!!"
	thank_text = "[i]YEAH, LET'S GOOOOOO! SOIL!!!"
	obj = Objective.new(gv.Objective.LORED_UPGRADED, str(lv.Type.TREES))
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.STEEL), "50"))
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.HARDWOOD), "50"))
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.WIRE), "50"))
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.GLASS), "50"))
	rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.TUMORS)))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.TUMORS)))
	rew.append(Reward.new(gv.WishReward.TAB, str(gv.Tab.EXTRA_NORMAL)))
	key_rew.append(Reward.new(gv.WishReward.TAB, str(gv.Tab.EXTRA_NORMAL)))

func construct_axy():
	giver = str(lv.Type.AXES)
	help_text = "I require 0.8 Hardwood and 0.25 Steel per cycle. Satisy these requirements and I will assemble 1.0 axes. If you require further assistance, you can find help in the Help section of your Alaxa app."
	thank_text = "Job complete."
	obj = Objective.new(gv.Objective.RESOURCES_PRODUCED, str(gv.Resource.HARDWOOD), "20")
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.WOOD), "150"))
	rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.HUMUS)))
	rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.SOIL)))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.HUMUS)))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.SOIL)))
func construct_hardy():
	giver = str(lv.Type.HARDWOOD)
	help_text = "Hiya, stud. Care to help a girl out with some wood? I'll make it hard for you."
	thank_text = "Call me later."
	obj = Objective.new(gv.Objective.RESOURCES_PRODUCED, str(gv.Resource.WOOD), "300")
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.AXES), "10"))
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.STEEL), "50"))
	rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.GLASS)))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.GLASS)))
func construct_woody():
	giver = str(lv.Type.WOOD)
	help_text = "Hey! I heard you were strong! Let's fight!\n\nJust kiddin. Hey, can you help me get some axes? I need them to make wood."
	thank_text = "Wow, that was fast! Not as fast as me, but pretty good!"
	obj = Objective.new(gv.Objective.RESOURCES_PRODUCED, str(gv.Resource.AXES), "20")
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.HARDWOOD), "10"))
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.SAND), "250"))
	rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.SAND)))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.SAND)))

func construct_gramma():
	giver = str(lv.Type.WIRE)
	help_text = "Oooh! Goodness gracious! Look at you!\n\nNow stop causing a ruckus you little heathen and come help me get some wire."
	thank_text = "Children are so kind."
	obj = Objective.new(gv.Objective.RESOURCES_PRODUCED, str(gv.Resource.WIRE), "25")
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.LIQUID_IRON), "100"))
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.AXES), "5"))
	rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.AXES)))
	rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.WOOD)))
	rew.append(Reward.new(gv.gv.WishReward.NEW_LORED, str(lv.Type.HARDWOOD)))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.AXES)))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.WOOD)))
	key_rew.append(Reward.new(gv.gv.WishReward.NEW_LORED, str(lv.Type.HARDWOOD)))

func construct_liqy():
	giver = str(lv.Type.LIQUID_IRON)
	help_text = "Some freaking little freaker keeps throwing iron on my [i]head!!![/i]\n\nSo anyways, I'm making soup."
	thank_text = "Soup."
	obj = Objective.new(gv.Objective.RESOURCES_PRODUCED, str(gv.Resource.STEEL), "3")
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.WIRE), "20"))
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.GLASS), "30"))
	rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.WIRE)))
	rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.DRAW_PLATE)))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.WIRE)))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.DRAW_PLATE)))

func construct_waterbuddy():
	giver = str(lv.Type.WATER)
	help_text = "Okay, lemme show you around my pool. Check it out!\n\nAlso, in case you were curious, I can help you figure out the relationship Seeds and Trees and I have. It's pretty simple: Trees grows seeds to trees using seeds. I mean trees. Or--oh, wait, did I say it right the first time?\n\nHuh? Anyway, I don't know. I'm still just so stoked to have you here!!"
	thank_text = "You did it! Man, I can tell that we are gonna be friends."
	obj = Objective.new(gv.Objective.LORED_UPGRADED, str(lv.Type.SEEDS))
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.HARDWOOD), "95"))
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.STEEL), "25"))
	rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.STEEL)))
	rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.LIQUID_IRON)))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.STEEL)))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.LIQUID_IRON)))

func construct_a_new_leaf():
	giver = str(lv.Type.WATER)
	help_text = "Whoa!\n\nSeeds, Trees, look! There's others out there! :0 There are so many of them! Whoooooooooooa! Whaaaaat?! !!!!"
	thank_text = "It's really great to meet you!! I'm Water.\n\nHey, come here! Let me show you my pool!"
	obj = Objective.new(gv.Objective.UPGRADE_PURCHASED, "upgrade_name")
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.SEEDS), "2"))
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.SOIL), "25"))
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.WOOD), "80"))
	rew.append(Reward.new(gv.WishReward.TAB, str(gv.Tab.S2)))
	rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.WATER)))
	rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.SEEDS)))
	rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.TREES)))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.WATER)))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.SEEDS)))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.TREES)))
	key_rew.append(Reward.new(gv.WishReward.TAB, str(gv.Tab.S2)))

func construct_joy2():
	giver = str(lv.Type.IRON)
	help_text = "This one just came in straight from the developer himself! No, really! Don't believe me? Ask him!"
	thank_text = "Hey, the developer sent a message for you, as if I were some kind of Post LORED: \"You're a big stinky winky.\"\n\nI swear! It was him!! Not me! I can't believe he made me say that."
	obj = Objective.new(gv.Objective.RESOURCES_PRODUCED, str(gv.Resource.JOY), "10")
	rew.append(Reward.new(gv.WishReward.MAX_RANDOM_WISHES, "", 2))
	key_rew.append(Reward.new(gv.WishReward.MAX_RANDOM_WISHES, "", 2))

func construct_soccer_dude():
	giver = str(lv.Type.COPPER_ORE)
	help_text = "You've got to reset to get this one, boss, see? But, you don't have to reset right now, boss. Do what you want. You're the boss, boss, see, boss?"
	thank_text = "Wicked, boss, real wicked. We're rolling with the big cats, now, boss."
	obj = Objective.new(gv.Objective.UPGRADE_PURCHASED, "SOCCER DUDE")
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.MALIGNANCY), "1000"))

func construct_malignancy():
	giver = str(lv.Type.MALIGNANCY)
	help_text = "Hey!! We just got here. This is a crazy situation we're in! There's a whole bunch of us spawning out of nothing!!! And we noticed that we can throw ourselves overboard to get these wacky Malignant upgrades. But before [i]you[/i] can get the upgrades, you also have to jump off?\n\nI don't know, I was born 20 seconds ago. Just keep clicking buttons."
	thank_text = "Okay, you definitely have to reset to get the Malignant upgrades. You'll see! Good luck."
	obj = Objective.new(gv.Objective.RESOURCES_PRODUCED, str(gv.Resource.MALIGNANCY), "3e3")
	rew.append(Reward.new(gv.WishReward.TAB, str(gv.Tab.MALIGNANT)))
	key_rew.append(Reward.new(gv.WishReward.TAB, str(gv.Tab.MALIGNANT)))

func construct_sand():
	giver = str(lv.Type.JOULES)
	help_text = "If you really want to progress, you could get this Upgrade over here."
	thank_text = "Yeah, uhh... good job."
	obj = Objective.new(gv.Objective.UPGRADE_PURCHASED, "SAND")
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.MALIGNANCY), "10"))
	rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.TARBALLS)))
	rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.OIL)))
	rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.MALIGNANCY)))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.TARBALLS)))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.OIL)))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.MALIGNANCY)))

func construct_rye():
	giver = str(lv.Type.GROWTH)
	help_text = "[i]I CURRENTLY AM IN AN UNFORTUNATE SITUATION."
	thank_text = "[i]IT WOULD APPEAR THAT THERE WILL BE NO END TO MY SUFFERING."
	obj = Objective.new(gv.Objective.UPGRADE_PURCHASED, "RYE")
	rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.JOULES)))
	rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.CONCRETE)))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.JOULES)))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.CONCRETE)))

func construct_joy():
	giver = str(lv.Type.IRON)
	help_text = "Hey, it looks like everyone is opening up to you! They're sharing their Wishes! Isn't that nice?"
	thank_text = "Whoa, look! Growth just showed up!"
	obj = Objective.new(gv.Objective.RESOURCES_PRODUCED, str(gv.Resource.JOY), "3")
	rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.GROWTH)))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.GROWTH)))

func construct_grinder():
	giver = str(lv.Type.STONE)
	help_text = "Whoa?! Does the GRINDER upgrade work on rocks?"
	thank_text = "GRINDER is awesome!"
	obj = Objective.new(gv.Objective.UPGRADE_PURCHASED, "GRINDER")
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.IRON), 30))
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.COPPER), 30))
	rew.append(Reward.new(gv.WishReward.MAX_RANDOM_WISHES, "", 2))
	key_rew.append(Reward.new(gv.WishReward.MAX_RANDOM_WISHES, "", 2))

func construct_upgrades():
	giver = str(lv.Type.COPPER_ORE)
	help_text = "Ey, boss, I see you workin hard, real hard, I like that. But, lemme tell ya--you could be gettin this done a lot easier if you just did it with actual Upgrades. No, not upgrades like y'been doin--[i]Upgrades[/i], boss, [i]Upgrades[/i]! Whataya say to passin me a couple Stone--say, 40--and I tell ya all about Upgrades?"
	thank_text = "That's sweet, boss, that's real sweet. Thanks for the dough, I'm gonna put this to real good use, you'll see. Catch ya later, boss, catch ya later. Oh! Upgrades, right. Just press Q, boss, you can handle it."
	obj = Objective.new(gv.Objective.RESOURCES_PRODUCED, str(gv.Resource.STONE), "40")
	rew.append(Reward.new(gv.WishReward.TAB, str(gv.Tab.NORMAL)))
	key_rew.append(Reward.new(gv.WishReward.TAB, str(gv.Tab.NORMAL)))

func construct_upgrade_stone():
	giver = str(lv.Type.IRON)
	help_text = "Stone seems like he's got a little much to do. Could you upgrade him to make it easier on him?"
	thank_text = "Awesome! I bet he's liking that. Thanks :)" #note replace any :) text found in help_text or thank_text with the Joy icon. DO IT
	obj = Objective.new(gv.Objective.LORED_UPGRADED, str(lv.Type.STONE))
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.STONE), 50))

func construct_importance_of_coal():
	giver = str(lv.Type.COAL)
	help_text = "Yikes!! Everyone is taking my stuff! No rest for the righteous, I guess!"
	thank_text = "Whew."
	obj = Objective.new(gv.Objective.RESOURCES_PRODUCED, str(gv.Resource.COAL), "25")
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.COAL), 50))

func construct_collection():
	giver = str(lv.Type.STONE)
	help_text = "I'm just going to pick up some of these."
	thank_text = "Rocks are neat."
	obj = Objective.new(gv.Objective.RESOURCES_PRODUCED, str(gv.Resource.STONE), "10")
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.IRON), 20))
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.COPPER), 10))
	rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.IRON_ORE)))
	rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.COPPER_ORE)))
	rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.IRON)))
	rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.COPPER)))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.IRON_ORE)))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.COPPER_ORE)))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.IRON)))
	key_rew.append(Reward.new(gv.WishReward.NEW_LORED, str(lv.Type.COPPER)))

func construct_fuel():
	giver = str(lv.Type.COAL)
	help_text = "If Stone wants my stuff, I'm happy to share!"
	thank_text = "Glad I could help. :)"
	obj = Objective.new(gv.Objective.MAXED_FUEL_STORAGE, str(lv.Type.STONE))
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.COAL), 10))
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.STONE), 10))

func construct_stuff():
	giver = str(lv.Type.STONE)
	help_text = "I want to pick up rocks, but I'm out of [i]stuff[/i]. Help!"
	thank_text = "That's the stuff. Thanks!"
	obj = Objective.new(gv.Objective.LORED_UPGRADED, str(lv.Type.COAL))







func construct_veryLowCoal():
	giver = str(lv.Type.COAL)
	match taq.completed_wishes.count("veryLowCoal"):
		0:
			help_text = "For the love of all that is good, please help me! This is [i]way[/i] too much for me to handle!! :("
			thank_text = "Huff. Huff. Hoh my goodness. Thank you. That was crazy. Wow."
		1:
			help_text = "I'm so sorry. It's me again. I need your help again u.u"
			thank_text = "Thanks again. Sorry I keep needing your help u.u"
		2:
			help_text = ":( It's me again. Sorry. Would you help?"
			thank_text = "Thanks so much. You're a livesaver. I should be good from here."
		3:
			help_text = "...heyyy. Long time no see! It's me again."
			thank_text = "Thanks! See you next time."
		4:
			help_text = "What's up! Need your help again :)"
			thank_text = "Hey, see you next time, pal!"
		5:
			help_text = "There he is! Whazaaaaap?! You know the drill, buddy!"
			thank_text = "Bro, you are the best! That's what's up!"
		_:
			help_text = "[pls fix your coal shortage, i've run out of dialogue ideas for frick's sake]"
			thank_text = "[but Coal still sends his best]"
	
	obj = Objective.new(gv.Objective.RESOURCES_PRODUCED, str(gv.Resource.COAL), Big.new(lv.lored[lv.Type.COAL].output).m(10).toString())
	rew.append(Reward.new(gv.WishReward.RESOURCE, str(gv.Resource.COAL), Big.new(lv.lored[lv.Type.COAL].output).m(25)))
	gv.emit_signal("manualLabor")
























func construct_random():
	
	var selected_type: String
	
	if gv.resource[gv.Resource.JOY].greater(8):
		
		var possible_types: Dictionary = get_possible_types()
		
		var total_points: int = 0
		for p in possible_types:
			total_points += possible_types[p]
		
		var roll = randi() % total_points
		var shuffled_possible_types: Array = possible_types.keys()
		shuffled_possible_types.shuffle()
		
		#print("total points: ", total_points)
		for i in shuffled_possible_types.size():
			#print("roll ", i, ": ", roll, "; rolling against ", possible_types[shuffled_possible_types[i]])
			if roll < possible_types[shuffled_possible_types[i]]:
				selected_type = shuffled_possible_types[i]
				break
			roll -= possible_types[shuffled_possible_types[i]]
	
	else:
		selected_type = "random_collect"
	
	key = selected_type
	
	
	var constructMethod := "construct_" + key
	if ":" in key:
		constructMethod = constructMethod.split(":")[0]
	call(constructMethod)
	
	
	generateHelpAndThankText()

func get_possible_types() -> Dictionary:
	
	var possible_types := {
		"random_upgrade_lored": 10,
		"random_collect": 50,
		"random_break_or_hoard": 10,
	}
	
	# buy_upgrade 25
	if notAnotherOngoingWishOfThisType("random_buy_upgrade"):
		for i in gv.Tab.values():
			
			if i == gv.Tab.S1:
				break
			
			var exit := false
			
			for x in gv.list.upgrade["unowned " + str(i)]:
				var time_to_buy = gv.up[x].time_to_buy()
				if not time_to_buy is Big:
					continue
				if time_to_buy.less(120) and gv.up[x].manager.availableToBuy():
					possible_types["random_buy_upgrade:" + x] = 15
					exit = true
					break
			
			if exit:
				break
	
	# max_fuel 100
	if diff.FuelStorage <= 2:
		if notAnotherOngoingWishOfThisType("random_max_fuel"):
			for x in gv.list.lored["active"]:
				print("x should be an int. is it? x is a(n): ", typeof(x))
				if lv.lored[x].currentFuelPercent < 0.25:
					possible_types["random_max_fuel:" + x] = 100
					break
	
	# joy_or_grief 20
	if true:
		if notAnotherOngoingWishOfThisType("random_joy_or_grief"):
			possible_types["random_joy_or_grief"] = 20
	
	return possible_types

func notAnotherOngoingWishOfThisType(_key: String) -> bool:
	# wishes that call this function are limited to 1
	for w in taq.wish:
		if w.key == _key:
			return false
	return true

#   -   -   -   -   -   -   -   -   -   -

func construct_random_upgrade_lored():
	
	setRandomGiver()
	
	obj = Objective.new(gv.Objective.LORED_UPGRADED, randomLORED())
	
	generateRandomRewards(30)

func construct_random_collect():
	
	setRandomGiver()
	
	var resource = str(randomResource())
	
	var difficulty = rand_range(20,80)
	
	if taq.easier:
		difficulty /= 10
	
	var s1_or_s2 = gv.isStage1Or2LORED(resource)
	
	# stage 1 or 2
	if s1_or_s2:
		difficulty /= gv.g[resource].speed.t
	
	var amount: Big = Big.new(difficulty).m(gv.g[resource].d.t)
	
	# stage 1 or 2
	if s1_or_s2:
		if gv.g[resource].stage == "2" and gv.run2 == 1:
			amount.d(10)
	
	amount.mantissa = floor(amount.mantissa)
	
	obj = Objective.new(gv.Objective.RESOURCES_PRODUCED, resource, amount.toScientific())
	
	generateRandomRewards(difficulty / 2)

func construct_random_break_or_hoard():
	
	setRandomGiver()
	
	var roll: int = randi() % 2
	
	var _type = gv.Objective.BREAK if roll == 0 else gv.Objective.HOARD
	
	if _type == gv.Objective.HOARD:
		while gv.g[giver].used_by.size() == 0:
			setRandomGiver()
	
	var duration = randi() % 20 + 10 # 10-30
	
	if taq.easier:
		duration /= 10
	
	obj = Objective.new(_type, giver, str(duration))
	
	generateRandomRewards(25)

func construct_random_buy_upgrade():
	
	var selected_upgrade = fixKeyAndGetSurplus()
	setRandomGiver()
	
	obj = Objective.new(gv.Objective.UPGRADE_PURCHASED, selected_upgrade)
	
	generateRandomRewards(30)

func construct_random_max_fuel():
	
	var selected_lored = fixKeyAndGetSurplus()
	giver = selected_lored
	
	obj = Objective.new(gv.Objective.MAXED_FUEL_STORAGE, selected_lored)
	
	generateRandomRewards(0)

func construct_random_joy_or_grief():
	
	setRandomGiver()
	
	var roll = randi() % 10
	var resource = "grief" if roll < 2 else "joy"
	var count = str(randi() % 2 + 3)
	
	obj = Objective.new(gv.Objective.RESOURCES_PRODUCED, resource, count)
	
	generateRandomRewards(60)

#   -   -   -   -   -   -   -   -   -   -

func fixKeyAndGetSurplus() -> String:
	var split = key.split(":")
	var surplus = split[1]
	key = split[0]
	print_debug("surplus: ", surplus, "; key: ", key)
	return surplus

func setRandomGiver():
	giver = gv.list.lored["active"][randi() % gv.list.lored["active"].size()]

func randomLORED() -> String:
	return gv.list.lored["active"][randi() % gv.list.lored["active"].size()]

func randomResource() -> int:
	return gv.list["unlocked resources"][randi() % gv.list["unlocked resources"].size()]

func generateRandomRewards(reward_mod := 0.0):
	
	reward_mod = 10 + reward_mod
	reward_mod *= rand_range(0.5,1.5)
	
	var reward_size := 1
	
	var roll = rand_range(1, 100)
	if roll > 75:
		reward_size = 2
	
	for i in reward_size:
		
		var resource = str(randomResource())
		if not gv.everyStage2LOREDunlocked():
			while resource in gv.list.lored[gv.Tab.S2]:
				resource = str(randomResource())
		var amount: Big
		
		if gv.isStage1Or2LORED(resource):
			amount = Big.max(Big.new(reward_mod).m(rand_range(0.5,1.5)).m(Big.max(gv.g[resource].net(true, false)[0], 1)), 1.0)
		
		amount.roundDown()
		
		if i == 1 and resource == rew[0].key:
			#print("doubling up on rewards; combining")
			rew[0].amount.a(amount)
		else:
			rew.append(Reward.new(gv.WishReward.RESOURCE, resource, amount.toScientific()))

func generateHelpAndThankText():
	
	var roll: int = randi() % 3
	
	match key:
		#note still need random_reset
		"random_max_fuel":
			match giver:
				"cop":
					match roll:
						0: help_text = "Shucks, fam! I'm out of Coal!"
						1: help_text = "We're out of Coal?! Well, I'm confident we can keep the fire going without it."
						2: help_text = "Coca-Coal, what's happening, bro? Fill me up, baby! No homo."
					thank_text = "Thanks, bro. We're stocked and ready to lock and load!"
				"iron":
					match roll:
						0: help_text = "Ope! I'm out of Coal!"
						1: help_text = "I'm just gonna... pluck... a little bit of Coal! For myself!"
						2: help_text = "Coal me up, Coaler!"
					thank_text = "Thanks, Coal!"
				"copo":
					match roll:
						0: help_text = "Hey, we're out of Coal in the mine, and out of Coal in the game, too! Look at that, boss!"
						1: help_text = "C'mon, now, Coal, you've got it, lad. You're a good worker, see, real good. You can do it, pal."
						2: help_text = "Top us off, now, Coal, baby. Thanks a million."
					thank_text = "Truly righteous, Coal. Well-done, well-done."
				"irono":
					match roll:
						0: help_text = "Coal, are you kidding me? Hurry it up."
						1: help_text = "Are you kidding me? How did I get this low on fuel? Did you upgrade me too quickly? Coal better not have a negative net output. I will [i]LOSE[/i] my [i]MIND[/i]. I will [i]FIND YOU[/i]. [i]FUEL ME UP. NOW.[/i]"
						2: help_text = "I have a very important role in this system. Don't you understand? I [i]CAN'T[/i] have low fuel. FIX IT."
					thank_text = "Thanks. Dummy. Make sure it doesn't happen again."
				"coal":
					match roll:
						0: help_text = "Just give me a sec, I'll topped off in a flash."
						1: help_text = "Heeheeeee, I literally have priority over everyone else when it comes to fueling up. THAT'S RIGHT, YOU SICK FREAKS. NO MATTER HOW MUCH YOU TAKE, I'LL [i]ALWAYS[/i] BE ABLE TO HIT MAX FUEL. Oh! Gosh, I lost it for just a bit, there! Tee hee. Sorry!"
						2: help_text = "Yup, yup! Won't take me but a moment."
					thank_text = "That's what I'm talking about, baby! Woo!"
				"stone":
					match roll:
						0: help_text = "Yo, Coal, help me out, bro!"
						1: help_text = "C'mon, Coal, you've got it!"
						2: help_text = "Just gotta get filled up real quick!"
					thank_text = "Whew! :)"
		"random_joy_or_grief":
			match obj.key:
				"grief":
					match giver:
						"cop":
							thank_text = "Oh, never mind! It all worked out!"
							match roll:
								0: help_text = "This site was already reserved? Oh..."
								1:
									help_text = "I envisioned a future where there were no trees, no campsites. The air was poisonous. The bug balance of life was messed up. Farm food rotted, billions died. Marshmallow factories went bankrupt, as there were no campers to buy marshmallows. [i]S'mores[/i]... more like [i]n'mores[/i]. We followed soon after. I was the only one left, in a desert, my lips chapped, unable to move, as the lack of any moisture left my skin taut and crusty. I sat before a circle of rocks, a rod in my hand... with no wood for a fire, nothing stuck on the rod, and no one to share any of it with anyway. I waited for death, but it never came."
									thank_text = "In truth, I died when those factories went under. I am not [i]a'live[/i] without [i]s'mores[/i]. But, it's okay. In real life, people wouldn't stop buying marshmallows, even if all the trees were gone. ...Right?"
								2: help_text = "We have to go back to town for toilet paper? ... :("
						"iron":
							match roll:
								0: help_text = "Awh, shucks! Grief? Why am I Wishing for this again?"
								1: help_text = "Hey, ban that Griefer! Wait, it's me?!"
								2: help_text = "Don't worry, friends, it will only hurt for a little while. Just a little while."
							thank_text = "Oh, thank the Lord that's through."
						"copo":
							match roll:
								0: help_text = "Used to it, boss, used to it."
								1: help_text = "If you want Grief, just talk to the women and children left behind by our lost workers."
								2: help_text = "Oh, sure, boss, we can fix you up with some Grief, no problem, no problem at all. See, just hang around a minute, boss, maybe two, and another of us will turn up dead. You wait and see, just you wait and see, there, bossy boss, I'll mark my job on it. Er.. actually, boss, scratch that last comment from the record."
							thank_text = "Oh, look, boss, more Grief. What a surprise."
						"irono":
							match roll:
								0: help_text = "YEESSSSSS. O, HOW I'VE WAITED FOR THIS MOMENT."
								1: help_text = "EACH STEP HAS LED TO THIS WISH. PLEASE DON'T DISCARD IT. BWWWAAAA HEAHUEAHUWA!!! [i]FEEEEEEL[/i] THE PAIN!"
								2: help_text = "Oh, wow. I'm gonna [i][CENSORED][/i]."
							thank_text = "HAHAHAhe-w--whuh?! It's over? No! NOooo!!! That's it?! I waited all this time for just " + obj.required_count.toString() + " Grief?!\n\nWell, I'll just take out my disappointment on this iron ore deposit. [i]DIE"
						"coal":
							match roll:
								0: help_text = "THAAAAAAAAT'S IT. Y'AAAALL CAN DIE. JUST DIE!"
								1: help_text = "NO MORE FUN. NO. NO MORE, YOU LOSERS."
								2: help_text = "I'VE HAD IT WITH YOU MISERABLE FREAKS. THIS IS WHAT YOU DESERVE."
							thank_text = "Golly, did I say all that? Sorry! Tee hee!"
						"stone":
							match roll:
								0: help_text = "I'm sick of you guys messing with my rocks."
								1: help_text = "Mwuahuwahwa >:D"
								2: help_text = "Behold! Dr. Confusion is back in town, to cause misery to everyone!"
							thank_text = "Okay, sorry, but not that sorry."
				"joy":
					match giver:
						"cop":
							match roll:
								0: help_text = "You want to talk about Joy? There was an extra piece of graham cracker in the bottom of the box."
								1: help_text = "Let's en[i]joy[/i] some s'mores! Ha, ahah! What? Someone already made that joke?"
								2: help_text = "Squad--now's our chance! Go Joy!"
							thank_text = "Wooo! I'm back! Who's hungry?!"
						"stone":
							thank_text = "Good job!"
							match roll:
								0: help_text = "If you guys want Joy so much, just pick up some rocks! Trust me!"
								1:
									help_text = "Oh, we need Joy?! Uh--wait. Um... Do you want to hear a joke about ghosts?"
									thank_text = "That's the spirit."
								2: help_text = "Joyyyyy. Yup! On it!"
						"copo":
							match roll:
								0: help_text = "All right, boss, it's been a good long while since the lads had some of this [i]Joy[/i], now, see? Let's hop on it real quick like, see!"
								1: help_text = "Huh? Boss--[i]Joy?[/i] What's that?"
								2: help_text = "All right, now, lads, listen up--Big Wig's comin' down from the capital, see, and we've got to act real Joyous-like if we're to have any hope of scoring those nickel raises we've been pining for, you hear? Remember, now:\n[i]Bok choy-busboys' ploy for employ leaves their wallets coy, you know,\nso deploy bellboy, playboy, albeit decoy, Joy, for dough.[/i]"
							thank_text = "Well carry me out with the tongs, boss, that Joy was wicked, real wicked!"
						"irono":
							match roll:
								0: help_text = "In order for there to be misery, there must first exist Joy."
								1: help_text = "Without Joy, torture is meaningless."
								2: help_text = "Joy and Grief are but two emotions on the coin of our brains, except our brains are full of coins. Wait, does that make any cents?"
							thank_text = "JOY-TIME OVER."
						"coal":
							match roll:
								0: help_text = "Let's see some Joy!"
								1: help_text = "C'mon Joy!"
								2: help_text = "Let's en[i]joy[/i] ourselves :D"
							thank_text = "Sweet."
						"iron":
							match roll:
								0: help_text = "Let's spread Joy!"
								1: help_text = "Yay, Joy!"
								2: help_text = "Joy!!"
							thank_text = "Good job."
		"random_buy_upgrade":
			match giver:
				"cop":
					match roll:
						0: help_text = "We should have upgraded campsites!"
						1: help_text = "Okay, okay. Let's get an Upgrade, boys!"
						2: help_text = "Um... yep! I want this one!"
					thank_text = "The power of game mechanics in action!"
				"iron":
					match roll:
						0: help_text = "Does this Upgrade help me make toast?"
						1: help_text = "Let's get this one!"
						2: help_text = "C'mon, guys! Upgrade time!"
					thank_text = "Woo-hoo!!"
				"copo":
					match roll:
						0: help_text = "I see you figured out all about Upgrades, boss! Way to go, pal."
						1: help_text = "This one, see, this one--what an [i]Upgrade[/i], boss! This will be [i]huge[/i], boss, [i]huge[/i]!"
						2: help_text = "I'd take an upgrade to our air conditioning, life and health insurance, wages, and hours, boss, but this Upgrade is good, too!"
					thank_text = "Slick, boss, real slick."
				"irono":
					match roll:
						0: help_text = "Should have upgraded my weapon."
						1: help_text = "Would rather upgrade my kill count."
						2: help_text = "Oh, sure, let's get [i]" + gv.up[obj.key].name + "[/i] out of all of the available Upgrades. Why this one? Who knows? Who cares. Just buy it, we know you're going to."
					thank_text = "Mwahahaha."
				"coal":
					thank_text = "Yay! Back to work. :)"
					match roll:
						0: help_text = "Yay Upgrades!"
						1:
							help_text = "CAN'T YOU BUY AN UPGRADE THAT BENEFITS [i]ME?!"
							thank_text = "Tee hee. I was only joking around! Kind of! Hee hee."
						2: help_text = "Can't wait to get this one!"
				"stone":
					match roll:
						0: help_text = "Upgrades are somewhat as cool as rocks."
						1: help_text = "Well, more Upgrades, more Stone! Probably!"
						2: help_text = "Let's... uprade our passports?"
					thank_text = "Yay."
		"random_collect":
			match giver:
				# need: growth, jo, conc, oil, tar, malig
				# oil ipad joke?
				# spirit bomb joke. lend me your energy
				"cop":
					match obj.key:
						"malig":
							help_text = "Oh, shit!! They on X-games mode, bruh!!! What the hell even is that?!"
							thank_text = "I still can't believe my eyes, bro! Bruh!! Brooooo! BRuhhhhh brobrobrobro bruhhhhhhhhhhhhh!!!!!"
						"tar":
							help_text = "That dude probably likes Magic the Gathering and anime.\n\nI do, too!!! We gotta get together!!"
							thank_text = "We have a playdate scheduled. We're gonna compare the English and Japanese dubs for the final episode of Death Note. Siiiick!"
						"oil":
							help_text = "Look at that baby! That's got to be the funniest thing I've ever seen!"
							thank_text = "I literally can't stop laughing at that baby, yo!!"
						"conc":
							help_text = "My amigo, yo! I'm just a gringo, ahaha!"
							thank_text = "He's sick!"
						"jo":
							help_text = "That dude gives me discounts, yooo!! Let's goo!!"
							thank_text = "Yuss! Cut up!"
						"growth":
							help_text = "That junt smells hella fire, yo."
							thank_text = "What? Why would I sniff that? Mane, don't come at me like that."
						"cop":
							help_text = "IT'S ALL ABOUT ME, BABY, THAT'S WHAT I'M SAYIN, HELL YEAH, BOY! LET ME STRUT MY STUFF, HOMIE."
							thank_text = "Yo I killed it. Hell yeah."
						"iron":
							help_text = "Yoooo--that's my fam, dude--I mean, dude, my dude, fam!"
							thank_text = "That's what I'm smokin', dude fam!"
						"copo":
							help_text = "My son! My beloved baby! Yes, help him out!"
							thank_text = "Heck yes!"
						"irono":
							help_text = "Uh... can we not talk about him?"
							thank_text = "Anyway."
						"coal":
							help_text = "Did someone say Coal?"
							thank_text = "Huh?"
						"stone":
							help_text = "Stone, you'd be perfect for finding firewood. Would you, could you?"
							thank_text = "Oh. Well, then! Fine."
				"iron":
					match obj.key:
						"malig":
							help_text = "Malignancy has probably the most important role out of all of us. We need them more than anything to get stronger!"
							thank_text = "Nice."
						"tar":
							help_text = "That guy isn't the best with people, but he's here specifically to help us all out! We need him for Malignancy!! So let's help!!!"
							thank_text = "He wrote a script for my toaster that improves toastiness by 11%. I don't know what that means, but I'm glad he's around!"
						"oil":
							help_text = "I don't know if you'll remember this, Oil, since you're just a baby, but I think you're cool!"
							thank_text = "He burped and laughed at me. What a funny guy!"
						"conc":
							help_text = "We need to succeed, right? Well, if Concrete succeeds, so do we!! Let's help him out!!!"
							thank_text = "Woooo!!"
						"jo":
							help_text = "This strapping young guy's in charge of supplying [i]every single electric LORED[/i] with energy! Isn't that impressive?!"
							thank_text = "Well, I'm glad y'all agree! And I know he appreciated y'all, too. Thanks!"
						"growth":
							help_text = "That moist guy takes my stuff sometimes. Yeah, you could say we're pals."
							thank_text = "I hope he grows out of that phase."
						"cop":
							help_text = "My best friend! Send him some love, y'all."
							thank_text = ":) Yeah!"
						"iron":
							help_text = "Heheheh... [i]HEHEHEHHEHHHHH!!"
							thank_text = "Aw. It was nice while it lasted, everybody!"
						"copo":
							help_text = "Oh, whoa, [i]whoa, WHOA[/i]! Talk about [i]Stone[/i] working hard--[i]LOOK AT THIS DUDE[/i]! SEND SOME HELP DOWN THERE!"
							thank_text = "Oh, it didn't matter? He's going to work there until he dies, leaving his family in debt? I see. Rough time, early 1900s, real rough, see, boss?\nOops, what was that? Did I catch something?"
						"irono":
							help_text = "Ugh. The [i]Boromir when you were 10 years old seeing the movie for the first time and just thinking Boromir was Walmart-Aragorn[/i] of this game. What a creep."
							thank_text = "Hold on. You're telling me Iron Ore sees me as Aragorn?\n\nWow, that's awkward."
						"coal":
							help_text = "Let's help out Coal!"
							thank_text = "Hooray!"
						"stone":
							help_text = "Ah, that's the stuff. Stone works hard!"
							thank_text = "I'm happy for him!"
				"copo":# respects coal and conc
					match obj.key:
						"malig":
							help_text = "I just ain't got nothing to say to that, boss, no sir."
							thank_text = "I simply cannot comprehend what my eyes are feeding into my brain, boss, I simply cannot."
						"tar":
							help_text = "Sitting in your cushy office chairs all day and still finding something to complain about, is that it? *Scoff*"
							thank_text = "No, boss, see, my mama told me that if I didn't have anything kind to say, I ought to simply not say it! There may come a day when he asks for my opinion, and on that day I will give it to him, boss, I really will. But until then, I have nothing to say, and that's that, boss, that's just that."
						"oil":
							help_text = "Good God, look at how young those corporate fat heads have lowered the minimum working age to! It's downright horrific, see! I won't stand for it, boss, I just won't, y'see?!"
							thank_text = "Well, it'll toughen him up. I was in the mine even before I was his age, and look at me--I turned out okay, boss, don't you think so?"
						"conc":
							help_text = "No doubt he's been through his fair share of hardships, boss."
							thank_text = "He'll be all right."
						"jo":
							help_text = "SEND A TEAM DOWN THAT SHAFT RIGHT AWAY, SEE!"
							thank_text = "I get a little intense on ocasion, boss. Don't pay me no mind, boss!"
						"growth":
							help_text = "I ain't none to sure on that, boss, no sir. Boy looks like he could use some life insurance, if he could even get approved for it."
							thank_text = "God be with him, boss, God be with him."
						"cop":
							help_text = "Nononono-not more Copper, lads, we're good."
							thank_text = "I SAID WE DIDN'T NEED MORE COPPER, LADS. Now a fire's started. See, that's now fixing to consume what little oxygen we have left down here, boss. Yep, takes a real man to brave these absolute bullshit work conditions, boss. Complete and total, unspeakably-bullshit work conditions. Just have Iron Ore shoot me now, boss, just have him shoot me now."
						"iron":
							help_text = "Need more Iron for the supports in the mine, here, boss, need it quick."
							thank_text = "JEREMY, PUT YOUR HARD HAT BACK ON, SEE. I know it's hard to breathe, Jeremy, real hard. But until the earth above is is properly supported, the hat there increases your chances of survival by 1% in the unlikely (but actually likely, see) event of a complete collapse of the tunnel. All right, now, let's get these supports set up, Jeremy. There's a good lad. Boy's only 17 years old, boss, 17. Brings a tear to my eye, boss. I'll make sure he has a Bud Light 'fore the sun sets, boss. Get it, boss? We ain't seen the sun in years, boss. That's a classic joke, see, real classic. He ain't never gonna get that Bud Light, boss. We're all gonna die down here, for $1.70 per day, boss. That's a historically accurate number, boss, look it up. It's fucked up down here, real fucked up."
						"copo":
							help_text = "Ho-ho, boss, ho-ho! Now we're talking. While we're on the subject, I think it's only fair this Wish become infinitely repeatable, seeing as I'm a slave to work and will likely die in the mine before I quit, see."
							thank_text = "Oh, alright, then, boss, alright. Fine with me, I'm used to it, see--get declined for healthcare every year, boss."
						"irono":
							help_text = "Unfortunately, I am seen as the brother or equal of this one, see, and that just ain't right. No, it's not right at all, boss, not right at all, boss, at all, boss, all boss.\nWhoa, I just blacked out, there, boss, am I okay?"
							thank_text = "This fat head would ricochet-murder at least 5 workers in the mine, here, shootin' wild-like like that."
						"coal":
							help_text = "Now, see this one here, boss? This one's the only one who could make it in the mine, here, boss. He's tough, real tough. Of course, I'd never want him to work here. No, this mine should be shut down. But a man's gotta do what a man's gotta do, see?"
							thank_text = "Oh, right! Coal, good job, there, that's real swell. Cherish the sunlight, now."
						"stone":
							help_text = "You're cute, Stone, real cute."
							thank_text = "That's sweet, Stone, real sweet."
				"irono":
					match obj.key:
						"malig":
							help_text = "They're getting what they deserve, no doubt. We all go out like that in the end, anyway."
							thank_text = "Whatever."
						"tar":
							help_text = "That moron thinks he's smart, but all he does is create matter out of oil and cancer juice.\n\nWait, what? He does that? Holy crap."
							thank_text = "Well, I still don't like him."
						"oil":
							help_text = "That baby is absolutely, positively [i]disgusting.[/i]"
							thank_text = "Yep. I'm the villain of LORED. I called Oil [i]disgusting[/i] and I'm going to get away with it, too."
						"conc":
							help_text = "Actually, it's pretty impressive that he is here right now. He's left a lot behind. It's all a sacrifice for his family."
							thank_text = "He's aight."
						"jo":
							help_text = "This guy upsells you when you only go in for an oil change, and I bet he is [i]proud[/i] of it."
							thank_text = "Despicable scum."
						"growth":
							help_text = "Look at this idiot! Ever heard of chemotherapy, you ding dong?!"
							thank_text = "Good gawd."
						"cop":
							help_text = "Screw that guy. He's stupid. Those aren't s'mores."
							thank_text = "All right. Moving on."
						"iron":
							help_text = "Iron LORED. I follow you, my brother. My captain. My king."
							thank_text = "You bow to no one."
						"copo":
							help_text = "He is putting entirely too much effort into killing that ore deposit. I feel like I'm getting calluses just [i]hearing[/i] him whack away over there. Plus, he talks too much."
							thank_text = "Oof! Well, he's still going. Good on him! [i]I[/i] choose to work [i]smarter[/i]."
						"irono":
							help_text = "I'm... already.. what? I [i]obviously[/i] want more Iron Ore. How come I can even Wish for this? I'm a psychopath, and even I think something is up here. What would happen if you discarded this Wish? Why would you even do that? I'm not going to stop. I'm [i]never[/i] going to stop. You know what? I don't care. Discard it. See what happens. Go on. Do it. I double-homicide-dare you."
							thank_text = "Okay. Whatever. You'll get free random resources out of thin air for not lifting a dang finger, as if that makes any sense. Take it to the bank, you three-dimensional freak. If I could aim out of the screen and at you, I would."
						"coal":
							help_text = "Yes. [i]JAB[/i] that shovel in, real deep."
							thank_text = "EXCELLENT."
						"stone":
							help_text = "Stone, you're next."
							thank_text = "I'm coming for you, Stone. Just... after this Iron Ore deposit actually deteriorates."
				"coal":
					match obj.key:
						"malig":
							help_text = "Some families just have as many dang kids as they want, apparently."
							thank_text = "They've had 100 more since the last time I blinked!!!"
						"tar":
							help_text = "Wow!!! Can that guy hack into my ex's Facebook account?"
							thank_text = "He said that \"with great power comes great responsibility\" and then told me to get lost. :("
						"oil":
							help_text = "That baby is sucking oil. Now, I have truly seen it all."
							thank_text = "I want a taste."
						"conc":
							help_text = "Ah, donde esta mi amor?"
							thank_text = "I don't think I said it right."
						"jo":
							help_text = "Oh, oh!! -- Ahem... I saw this guy redirecting lightning, and I thought it was quite... [i]SHOCKING!!!![/i] :)"
							thank_text = "Why didn't you laugh?"
						"growth":
							help_text = "What in tarnation is that guy doing?"
							thank_text = "Somebody help him."
						"cop":
							help_text = "Copper."
							thank_text = "Thank."
						"iron":
							help_text = "All right, team. Go all in on Iron!"
							thank_text = "That was okay."
						"copo":
							help_text = "Copper Ore's mine looks scary."
							thank_text = "He did it!"
						"irono":
							help_text = "Iron Ore's good for something, I guess!"
							thank_text = "Yup!"
						"coal":
							help_text = "THAT'S DAMN RIGHT. WE NEED MORE COAL! YOU ALL WON'T FREAKING GIVE ME A SECOND'S BREAK!"
							thank_text = "Oops! Excuse me! Hee hee."
						"stone":
							help_text = "More Stone, more Coal!"
							thank_text = "Good job, team! I mean, Stone."
				"stone":
					match obj.key:
						"malig":
							help_text = "Wow, there are a lot of them. They need help."
							thank_text = "Now there's even more."
						"tar":
							help_text = "That guy seems pretty smart. Let's help him out!!"
							thank_text = "He called me an idiot."
						"oil":
							help_text = "Is it alright that that baby is slurping up oil? Uh... well, I'm sure his parents know what they're doing!"
							thank_text = "Can I pet the baby? Wait, is that what adults do to babies? Maybe I should just smile and nod. Okay, then! :) *nod*"
						"conc":
							help_text = "My buddy!! He likes stones more than anybody. Oh! Except for me, of course. Let's help him out!!"
							thank_text = "Buenos nachos, my amigo!!!"
						"jo":
							help_text = "That guy helped me with my car, once."
							thank_text = "Yay."
						"growth":
							help_text = "I'm thirsty. Let's get some more juice!!!"
							thank_text = "Delicio--[i]oh god, what have i done[/i]"
						"cop":
							help_text = "That stuff looks delicious!!! And part-rock!!!"
							thank_text = "Mmmm! :)"
						"iron":
							help_text = "MORE IRON COULD EVENTUALLY MEAN MORE STONE! LET'S DO IT!"
							thank_text = "YEAHH!!"
						"copo":
							help_text = "Oh, okay! More Copper Ore! Yeah!"
							thank_text = "Yay!"
						"irono":
							help_text = ":( Iron Ore keeps shooting rocks :("
							thank_text = ":("
						"coal":
							help_text = "Let's get some more Coal!"
							thank_text = "Yay :)"
						"stone":
							help_text = "We need more rocks, duh!"
							thank_text = "[i]Wooo!!! Stones!!!![/i]"
		"random_break_or_hoard":
			match obj.type:
				gv.Objective.BREAK:
					match giver:
						"malig":
							match roll:
								0: help_text = "I refuse to be born and for [i]this[/i] to be my purpose."
								1: help_text = "I was born only 5 seconds ago, but I already need a break. This sucks."
								2: help_text = "Everyone else has gotten a break but me! That's no fair!"
							thank_text = "I know, I know. [i]Back to the edge of the boat with you lot.[/i] Ugh."
						"jo":
							thank_text = "Nooo! Was that it?!"
							match roll:
								0: help_text = "Here's a thought: Let's take a quick joy ride!"
								1: help_text = "What if I were to, for example, stop working and do absolutely nothing? Hypothetically, of course. What would you, or anyone else, say in a situation such as what I just pretended to suggest?"
								2:
									help_text = "I'M SICK OF THIS JOB. I QUIT."
									thank_text = "Remember that time I said I quit? Yeah, sorry about that."
						"conc":
							match roll:
								0: help_text = "No tuve mi descanso de quince minutos."
								1: help_text = "Jefe, necesito ir al baño."
								2: help_text = "Primo, let me go!"
							thank_text = "¡Gracias! Volvamos al trabajo."
						"tar":
							match roll:
								0: help_text = "I'm concerned that this will turn into an addiction."
								1: help_text = "My elbow aches. There is a possibility that I have obtained repetitive strain injury."
								2: help_text = "I'm approaching the burn-out phase. If I do not rest, I may lose my marbles."
							thank_text = "Anyway! No rest for the wicked, as they say!"
						"oil":
							match roll:
								0: help_text = "Waahh!!"
								1: help_text = "I go boopy."
								2: help_text = ">:("
							thank_text = "Scallom. Wa-googie!"
						"growth":
							match roll:
								0: help_text = "FOR THE LOVE OF ALL THAT IS GOOD. LET ME TAKE A BREAK."
								1: help_text = "If I don't get a reprieve from this madness, I will go insane."
								2: help_text = "My skin is raw and wriggling."
							thank_text = "Please don't make me go back to work. [i]Please.[/i]"
						"cop":
							match roll:
								0: help_text = "I'll be behind that tree over there."
								1: help_text = "Shoot! Oh, no, guys, it's okay. I've got more graham crackers in the car."
								2: help_text = "I've been sitting by this fire for ages. I might be developing burn-tissue."
							thank_text = "Wooo! I'm back! Who's hungry?!"
						"iron":
							match roll:
								0: help_text = "I'm tired!"
								1: help_text = "My toaster is overheating. Can we let it take a break?"
								2: help_text = "I need to go find some band-aids for my forehead."
							thank_text = "All-righty! Back to work!"
						"copo":
							match roll:
								0: help_text = "Listen, boss, listen. I'm tired, all right? I'm real tired. I can't do this no more. I need a break, boss. Gotta have it."
								1: help_text = "Boss, I'm fed up, real fed up. If I go on like this, I won't make it, see, I really won't make it. I need to relax."
								2: help_text = "Breather, boss, breather! Need to take five. You'll barely notice I was gone, boss, truly!"
							thank_text = "Hoo-wee, boss, hoo-wee! What a relief! That was definitely worth it, boss, you'll see. Production will go up seven-hundred percent, boss, [i]seven-hundred percent[/i]! Don't quote me on that."
						"irono":
							match roll:
								0: help_text = "Must rest."
								1: help_text = "Need more shells."
								2: help_text = "Require reprieve."
							thank_text = "BACK TO [i]MURDERING![/i]"
						"coal":
							match roll:
								0: help_text = "My body aches!"
								1: help_text = "I hope the others will be fine, but I really need to take a moment."
								2: help_text = "I'd love to take a second to relax!"
							thank_text = "Yay! Back to work. :)"
						"stone":
							match roll:
								0: help_text = "My back hurts."
								1: help_text = "Yeah, rocks, but, you know--my legs are about to give out!"
								2: help_text = "Can I get a break so I can think about the best way to pick up rocks?"
							thank_text = "Whew!"
				
				gv.Objective.HOARD:
					match giver:
						"malig":
							match roll:
								0: help_text = "No! You can't make us jump off this boat!!"
								1: help_text = "Spare us!! We were just born yesterday!!"
								2: help_text = "Let us go potty, first."
							thank_text = "If it's our purpose, then so be it."
						"tar":
							match roll:
								0: help_text = "This is required for my upcoming test."
								1: help_text = "If you take one more tarball, I will initiate Covid 2."
								2: help_text = "If you'll excuse me, I want to briefly take one of these to the bathroom. Don't worry, I won't even need one minute."
							thank_text = "I'd be willing to part with these once more... for a price. Just kiddin."
						"oil":
							match roll:
								0: help_text = "MINE MINE MINE MINE MINE MIIIIIIIIIIIIIIINE!"
								1: help_text = "*is now screaming and farting*"
								2: help_text = "*very angry slurps*"
							thank_text = "Bapa poopa. Blabble-abble. Hee-hee!"
						"jo":
							thank_text = "Okie dokie! Let's get back to business!"
							match roll:
								0:
									help_text = "Don't. Touch. The jewels."
									thank_text = "What's that? You meant you wanted my [i]joules[/i]? Ohh..."
								1: help_text = "I've got to keep some of these. I have to overclock my Playstation 5. I'm gonna blast it with energy."
								2: help_text = "Sorry, my Tesla is almost out of charge. I'll be stranded if I don't keep some of these to fill up."
						"conc":
							match roll:
								0: help_text = "No, es mio!"
								1: help_text = "Pero mi mami dijo que no tengo que darte mi concreto si no quiero."
								2: help_text = "Si quieres este concreto, simplemente tendrás que esperar. Cara de trasero."
							thank_text = "Okay. Lo siento. You take some."
						"growth":
							match roll:
								0: help_text = "What use would you have for MY JUICE, ANYWAY?"
								1: help_text = "It's [i]my[/i] juice! Go pinch off your own juice!"
								2: help_text = "Wait. I might have dropped my keys in one of those juice sacks back there. Let me look."
							thank_text = "Well, I guess I make enough juice for all of us. Okay. You can have some again."
						"cop":
							match roll:
								0: help_text = "There's plenty to come, wait your turn. This batch looks especially good!"
								1: help_text = "Wait, can I just--this one was cooked perfectly. You can have the next two, I promise!"
								2: help_text = "It's... uh... winter is coming? I need to stockpile. Yep!"
							thank_text = "Okay, okay! Everyone hop in!"
						"iron":
							match roll:
								0: help_text = "I'm somewhat, slightly, partially [i]starving to death[/i], so I'm going to need to eat some of these."
								1: help_text = "Toaster and I have a unique relationship, but in the end it is [i]our[/i] relationship. We can't be swinging every moment of every day!"
								2: help_text = "Ummm... nah. This is mine."
							thank_text = "Okay! That was fun, but I missed sharing with y'all."
						"copo":
							match roll:
								0: help_text = "All right, now, listen up. You've all had just about enough of this here dough. No, I don't want to hear it. I'm working my hands near down to the bone, see, and I think I deserve to keep a little of what is really mine. You all get it, don'tcha?"
								1: help_text = "Boss, don't let them take anymore from me. I've had it up to here, boss, up to here!"
								2: help_text = "Now, you've all had yours, see, but now it's time I had mine. Fair's fair, and what's mine is mine, see? It's only right, now, it's only right."
							thank_text = "All right, now, friends, you've been mighty patient, I've seen you be mighty patient. You can have at it again. You, too, boss, you too."
						"irono":
							match roll:
								0: help_text = "ALL MINE."
								1: help_text = "I GOT YOU FOR THREE MINUTES. THREE MINUTES OF [i]PLAYTIME[/i]."
								2: help_text = "[i]No one to save you, now.[/i]"
							thank_text = "You're safe... for now."
						"coal":
							match roll:
								0: help_text = "THAT'S IT! YOU'VE ALL HAD ENOUGH! [i]I'M SICK OF IT!"
								1: help_text = "NO MORE COAL FOR YOU MOTHERFRICKERS, GODDARNIT. [i]I DON'T HAVE ENOUGH FOR MYSELF!"
								2: help_text = "ABSOLUTELY NO MORE COAL FOR [i]ANNNNNYYYYY[/i] OF YOU STUPID FREAKS. [i]I'M NOT DOING THIS SHIT ANYMORE[/i]."
							thank_text = "Hee hee! Sorry about that. I didn't mean it. Tee hee! :)"
						"stone":
							match roll:
								0: help_text = "I found these rocks, so they're mine!"
								1: help_text = "I don't feel like sharing."
								2: help_text = "I just want a chance to feel these ones."
							thank_text = "All right, fine! I don't really mind sharing, anyway."
