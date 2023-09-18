extends MarginContainer



@onready var title_bg = %"title bg"
@onready var bottom_title_bg = %"bottom title bg"
@onready var option_title_bg = %"option title bg"
@onready var hamburger = %Hamburger as IconButton
@onready var hamburger2 = %Hamburger2
@onready var pose = %Pose
@onready var dialogue_time_offline = %"dialogue time offline"
@onready var dialogue_negative_fuel = %"dialogue negative fuel"
@onready var dialogue_lost_resources = %"dialogue lost resources"
@onready var loss_parent = %"Loss Parent"
@onready var dialogue_gained_resources = %"dialogue gained resources"
@onready var dialogue_closing = %"dialogue closing"
@onready var nice = %Nice as TextButton
@onready var mean = %Mean as TextButton
@onready var loss = %Loss
@onready var gain = %Gain
@onready var options = %Options
@onready var option_bg = %"option bg"
@onready var gain_s1 = %"Gain S1"
@onready var gain_s2 = %"Gain S2"
@onready var gain_s3 = %"Gain S3"
@onready var gain_s4 = %"Gain S4"


var label = preload("res://Hud/rich_text_label.tscn")

var speech_time_offline := {
	LORED.Type.COAL: "Welcome back! You were offline for %s!",
	LORED.Type.STONE: "Hey!! You were gone for %s!",
	LORED.Type.IRON_ORE: "Ugh, you. You were only gone for %s. If that was multiplied by a zillion, it'd still be too soon.",
	LORED.Type.COPPER_ORE: "Welcome back, there, boss! Long time no see, see? It's been %s, yes, sir, it sure has! I would know, I was here the whole while, see?",
	LORED.Type.IRON: "Hey, buddy! You were away for %s!",
	LORED.Type.COPPER: "There you are! I missed you, man! You've been gone for %s.",
	LORED.Type.GROWTH: "I've been in perpetual turmoil for %s. Will it ever end?",
	LORED.Type.JOULES: "You haven't gotten a tune-up in %s?! Are you out of your mind?!",
	LORED.Type.CONCRETE: "Bienvenido, primo! Tu been gone por %s.",
	LORED.Type.OIL: "Hi! Bfblsshhh! Hahaha. %s.",
	LORED.Type.TARBALLS: "You return! By my count, you've been absent for %s.",
	LORED.Type.MALIGNANCY: "Heyyy! Welcome back! You've been away for %s.",
	LORED.Type.WATER: "Welcome back, friend! You were gone for %s.",
}
var speech_negative_fuel := {
	LORED.Type.COAL: ["Let's get into it! Because I was losing %s when you left, that means every LORED that uses my [b]stuff[/b] performed worse while you were gone.", "Same for %s, too."],
	LORED.Type.STONE: ["Well, bad news! Everyone who uses %s performed worse because when you left, it was going at a loss!", "Same for %s!!!"],
	LORED.Type.IRON_ORE: ["All right, you moron. Are you a newbie, or what? You're really going to just leave the game when one of the most important resources was being produced at a loss? You can't do that. You need %s to have a positive rate! Get that through your skull!", "Not only that, but you did it for %s, too. You are just a wonder of fumbles, aren't you? Ugh, whatever."],
	LORED.Type.COPPER_ORE:
		["Listen here, boss! Got some bad news for you, see, real bad. %s there was at a loss when you left. Yes, boss, I wouldn't say it if it wasn't true, no sir, I wouldn't. That might not be so bad in itself, see, boss, except for the fact that many of us [b]depend[/b] on it, see? Well, that means all of our production while you were gone took a hit, see? Yeah, now you see, don't you, boss? Yes, see, it isn't a pretty sight to see, see?",
		"Along that line, see, the same goes for %s. Yes, boss, it's true. It's a real sire situation, here, boss, it sure is."],
	LORED.Type.IRON: ["So, unfortunately, we lost a lot of %s while you were gone. What that means is that all of our friends who use it produced [b]less[/b] than they would have while you were out!", "The same goes for %s!"],
	LORED.Type.COPPER: ["So, listen, yeah...! %s lost resources while you were gone. So that means, so did all of our amigos who use it for fuel.", "That happened with %s, too."],
	LORED.Type.GROWTH: ["Speaking of perpetual turmoil, %s was at a negative rate when you left, so that means everyone who relies on it for fuel performed worse!", "Same for %s."],
	LORED.Type.JOULES: ["Look. You wouldn't let your car run out of oil, would you? Well, you let %s run out of... positive... production. That's bad.", "Same with %s. Okay so what this means is that every LORED that uses either of these resources for fuel took a production hit while you were gone! It's worse than bad. It's awful."],
	LORED.Type.CONCRETE: ["No mames, pinche barboso. *Types into phone. Robot voice speaks back.* \"%s lost resources while you were gone. All of us lost production because of it. Don't do that again.\"", "Ahh, come on. %s too! No bueno, primo."],
	LORED.Type.OIL: ["%s wasn't good, so, so, um, the rest of us got bad, too.", "%s wasn't good, neither, so. Ya."],
	LORED.Type.TARBALLS: ["Because %s had a negative net production when you left, every single LORED that relies on it for [b]fuel[/b] took a production hit.", "Same for %s, too, unfortunately."],
	LORED.Type.MALIGNANCY: ["Let's not beat around the bush. You messed up. %s was at a loss when you left, so while you were gone, all of the LOREDs that use it for fuel lost production!", "Obviously, the same goes for %s. You can't be doing that!"],
}
var speech_lost_resources := {
	LORED.Type.COAL: "Looks like you lost some resources.",
	LORED.Type.STONE: "Here's some of the resources we lost while you were gone.",
	LORED.Type.IRON_ORE: "Due to incompetence on someone's behalf, resources were lost. Behold and despair:",
	LORED.Type.COPPER_ORE: "Look here, boss. Whatever plan you had didn't work out, see, no, it didn't work out very well at all, seein as we lost these resources, see?",
	LORED.Type.IRON: "So, unfortunately, we lost some resources! Look!",
	LORED.Type.COPPER: "Yeah, so, bad news, brochacho! We lost some of these!",
	LORED.Type.GROWTH: "In further unpleasant news, look at these resources we lost:",
	LORED.Type.JOULES: "Listen, I've got some pretty bad news. We've lost our stuff.",
	LORED.Type.CONCRETE: "Nosotros perdimos estos resorted_cursos. Too bad, so sad.",
	LORED.Type.OIL: "Oh, no!!!",
	LORED.Type.TARBALLS: "Below is a summary of the resources that had a negative production while you were way.",
	LORED.Type.MALIGNANCY: "We lost some money. Check it out:",
}
var speech_gained_resources := {
	LORED.Type.COAL: ["But in brighter news, we gained some, too!", "There's only good news! Look at all the resources we collected!"],
	LORED.Type.STONE: ["Except for all that, things went pretty alright! Look at this!", "Good news!! Look at this!"],
	LORED.Type.IRON_ORE: ["Surprisingly, you didn't ruin [b]everything.[/b]", "Unsurprisingly, there were no complications. Here are the top earners."],
	LORED.Type.COPPER_ORE: ["On the brighter side, boss, looky here! We were productive in the end, see?", "Nothing bad to report today, there, boss, see? All the numbers are on the up! It's a great time to be alive, boss, yes sir, see?!"],
	LORED.Type.IRON: ["But moving on to the good news--look at what we gained while you were gone!", "For your report, I've got nothing but [b]great[/b] news! See?! It's all positive! Woo-hoo!!"],
	LORED.Type.COPPER: ["Anyway, it's not all doom and gloom! We still got something!", "Nah, we aren't good, man. We're [b]great![/b] Only good things going on here, buddy!"],
	LORED.Type.GROWTH: ["But there is some relief! See? We were productive after all.", "However, we were definitely productive while you were out!"],
	LORED.Type.JOULES: ["But there's always hope! Look at this.", "Great news, uncle! We were super productive in your absence!"],
	LORED.Type.CONCRETE: ["But es ok, primo. Look.", "Buenas noticias! Look! Aqui!"],
	LORED.Type.OIL: ["Yay.", "Yay!!!"],
	LORED.Type.TARBALLS: ["But here are the resources we gained!", "Fortune's smiled on us today! In your absence, we were nothing but [b]productive![/b]"],
	LORED.Type.MALIGNANCY: ["In other news, check this out! We did some good!", "No bad news today, friend. We produced all of this and more while you were gone!"],
}
var speech_closing := {
	LORED.Type.COAL: "Well, those are the highlights! We're doing good! Now keep it going!!",
	LORED.Type.STONE: "That's not [b]all[/b] of the information, but the rest is small-time stuff! Overall, we're progressing!",
	LORED.Type.IRON_ORE: "That's the end of the report. Keep it up. I have much planned for you and others like you.",
	LORED.Type.COPPER_ORE: "There's nothing else, there, boss, see? It's the end of the report! We're on our way, boss, I just know we are. Mine on, to greater ends!",
	LORED.Type.IRON: "And that's the report! Exciting stuff, isn't it?! I love giving the report, it's so cool. Okay, then, see you on the field!",
	LORED.Type.COPPER: "That's the \"Best Of\", so to speak! We're doing good, dude! Did I mention you're my hero? You totally are, man. All right, catch you on the flip-side!",
	LORED.Type.GROWTH: "And that's that! Back to my constant sorrow. You could say I'm a man of it!",
	LORED.Type.JOULES: "That's it. There's more, but it's not worth eyeballin. Good-bye.",
	LORED.Type.CONCRETE: "Este es el fin. Es bueno! Si. Ahora jeuga!",
	LORED.Type.OIL: "[b]The end!!![/b]",
	LORED.Type.TARBALLS: "I'll spare you the rest, m'lord, for it surely isn't worth your time to consider. Rest assured, [b]we made progress![/b]",
	LORED.Type.MALIGNANCY: "That's it! We did good, didn't we? Now it's time to [b]play![/b]",
}

var coal_ratio: float
var jo_ratio: float
var lored: int

var limit_gain := true:
	set(val):
		if not limit_gain == val:
			limit_gain = val
			show_or_hide_gain()
var limit_loss := true:
	set(val):
		if not limit_loss == val:
			limit_loss = val
			show_or_hide_loss()



func _ready():
	gv.offline_report_ready.connect(go)
	hamburger.set_icon(preload("res://Sprites/Hud/Menu.png"))
	hamburger.remove_optionals()
	hamburger.modulate = Color(0, 0, 0)
	hamburger.pressed.connect(options.show)
	hamburger2.set_icon(preload("res://Sprites/Hud/Menu.png"))
	hamburger2.remove_optionals()
	hamburger2.modulate = Color(0, 0, 0)
	hamburger2.pressed.connect(options.hide)
	
	nice.text = "Thank you!"
	mean.text = "Shut up."


func _on_fade_gui_input(event):
	if (
		event is InputEventMouseButton
		and event.is_pressed()
		and event.button_index == MOUSE_BUTTON_LEFT
	):
		options.hide()


func _on_limit_gain_pressed():
	limit_gain = not limit_gain


func _on_limit_loss_pressed():
	limit_loss = not limit_loss



func go() -> void:
	coal_ratio = wa.get_currency(Currency.Type.COAL).gain_over_loss
	jo_ratio = wa.get_currency(Currency.Type.JOULES).gain_over_loss
	set_speaker()
	time_offline()
	negative_fuel()
	lost_resources()
	gained_resources()
	closing()
	show()


func set_speaker() -> void:
	lored = lv.get_random_unlocked_lored()
	var color = lv.get_color(lored)
	$bg.modulate = color
	pose.modulate = color
	title_bg.modulate = color
	bottom_title_bg.modulate = color
	nice.color = color
	mean.color = color
	option_title_bg.modulate = color
	option_bg.modulate = color


func time_offline() -> void:
	var date_text := gv.get_time_text_from_dict(gv.time_offline_dict)
	match lored:
		LORED.Type.OIL:
			date_text = date_text.replace("year", "yee").replace("day", "day").replace("hour", "ow").replace("minute", "mimmit").replace("second", "sekkit").replace("and", "n")
		LORED.Type.CONCRETE:
			date_text = date_text.replace("year", "año").replace("day", "dia").replace("hour", "hora").replace("minute", "minuto").replace("second", "segundo").replace("and", "y")
	
	dialogue_time_offline.text = "[i]" + speech_time_offline[lored] % ("[b]" + date_text + "[/b]")


func negative_fuel() -> void:
	if (
		coal_ratio == 1.0
		and jo_ratio == 1.0
	):
		dialogue_negative_fuel.hide()
		return
	
	var coal_text: String
	var jo_text: String
	if coal_ratio < 1:
		coal_text = wa.get_icon_and_colored_name(Currency.Type.COAL)
	if jo_ratio < 1:
		jo_text = wa.get_icon_and_colored_name(Currency.Type.JOULES)
	
	var text: String
	
	text = speech_negative_fuel[lored][0] % coal_text if coal_ratio < 1.0 else jo_text
	if coal_ratio < 1.0 and jo_ratio < 1.0:
		text += "\n\n" + (speech_negative_fuel[lored][1] % jo_text)
	
	dialogue_negative_fuel.text = "[i]" + text


func lost_resources() -> void:
	var negative_resources := []
	for cur in gv.offline_earnings:
		if not gv.offline_earnings[cur]["positive"]:
			negative_resources.append(cur)
	
	if negative_resources.size() == 0:
		dialogue_lost_resources.hide()
		loss.hide()
		return
	
	negative_resources.sort_custom(
		func sort(a: int, b: int):
			return (
				wa.get_currency(a).gain_over_loss
				<= wa.get_currency(b).gain_over_loss
			)
	)
	var i = 0
	for cur in negative_resources:
		instance_label(cur, loss_parent)
		i += 1
	
	show_or_hide_loss()
	
	dialogue_lost_resources.text = "[i]" + speech_lost_resources[lored]


func gained_resources() -> void:
	var s1 = []
	var s2 = []
	var s3 = []
	var s4 = []
	for cur in gv.offline_earnings:
		if gv.offline_earnings[cur]["positive"]:
			match wa.get_currency_stage(cur):
				1: s1.append(cur)
				2: s2.append(cur)
				3: s3.append(cur)
				4: s4.append(cur)
	
	if s1.size() == 0:
		gain.hide()
		dialogue_gained_resources.hide()
		return
	
	s1.sort_custom(
		func sort(a: int, b: int):
			return gv.offline_earnings[a]["rate"].greater_equal(gv.offline_earnings[b]["rate"])
	)
	if s2.size() >= 2:
		s2.sort_custom(
			func sort(a: int, b: int):
				return gv.offline_earnings[a]["rate"].greater_equal(gv.offline_earnings[b]["rate"])
		)
	if s3.size() >= 2:
		s3.sort_custom(
			func sort(a: int, b: int):
				return gv.offline_earnings[a]["rate"].greater_equal(gv.offline_earnings[b]["rate"])
		)
	if s4.size() >= 2:
		s4.sort_custom(
			func sort(a: int, b: int):
				return gv.offline_earnings[a]["rate"].greater_equal(gv.offline_earnings[b]["rate"])
		)
	
	var i = 0
	add_stage_gain(1, s1)
	if s2.size() > 0:
		add_stage_gain(2, s2)
		if s3.size() > 0:
			add_stage_gain(3, s3)
			if s4.size() > 0:
				add_stage_gain(4, s4)
	
	show_or_hide_gain()
	
	if dialogue_negative_fuel.visible or loss.visible:
		i = 0
	else:
		i = 1
	dialogue_gained_resources.text = speech_gained_resources[lored][i]


func closing() -> void:
	dialogue_closing.text = "[i]" + speech_closing[lored]



func instance_label(cur: int, parent: Node) -> void:
	var x = label.instantiate()
	var currency = wa.get_currency(cur)
	var _text = "%s" + currency.offline_production.text
	_text = _text % ("+" if currency.positive_offline_rate else "-")
	_text = currency.color_text % _text
	var _name = currency.icon_and_colored_name
	x.text = _text + " " + _name
	parent.add_child(x)


func add_stage_gain(stage: int, list: Array) -> void:
	for cur in list:
		instance_label(cur, get("gain_s" + str(stage)))


func show_or_hide_gain() -> void:
	var i = 0
	for node in gain_s1.get_children():
		if i >= 3:
			node.visible = not limit_gain
		i += 1
	i = 0
	for node in gain_s2.get_children():
		if i >= 3:
			node.visible = not limit_gain
		i += 1
	i = 0
	for node in gain_s3.get_children():
		if i >= 3:
			node.visible = not limit_gain
		i += 1
	i = 0
	for node in gain_s4.get_children():
		if i >= 3:
			node.visible = not limit_gain
		i += 1


func show_or_hide_loss() -> void:
	var i = 0
	for node in loss_parent.get_children():
		if i >= 6:
			node.visible = not limit_loss
		i += 1
