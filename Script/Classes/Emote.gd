class_name Emote
extends RefCounted



enum Type {
	# add new emotes below, but above random_stone
	COAL_HUM,
	STONE_HAPPY, STONE_HAPPY_COAL0, STONE_HAPPY_STONE0, STONE_HAPPY_COAL1,
	COAL_WHOA,
	COAL_GREET,
	
	RANDOM_STONE,
	STONE7_REPLY,
	STONE8_REPLY,
	
	RANDOM_COAL,
	COAL16_REPLY,
	COAL16_REPLY_REPLY,
	COAL14_REPLY,
	COAL14_REPLY_REPLY,
	COAL13_REPLY,
	COAL12_REPLY,
	COAL10_REPLY,
	COAL9_REPLY,
	COAL8_REPLY,
	COAL8_REPLY_REPLY,
	COAL5_REPLY,
	
	RANDOM_IRON_ORE,
	IRON_ORE8_REPLY,
	IRON_ORE9_REPLY,
	IRON_ORE14_REPLY,
	IRON_ORE15_REPLY,
	
	RANDOM_COPPER_ORE,
	COPPER_ORE0_REPLY,
	COPPER_ORE6_REPLY,
	COPPER_ORE7_REPLY,
	
	RANDOM_IRON,
	IRON1_REPLY,
	IRON2_REPLY,
	IRON4_REPLY,
	
	RANDOM_COPPER,
	COPPER12_REPLY,
	COPPER12_REPLY0_REPLY,
	COPPER12_REPLY2_REPLY,
	COPPER4_REPLY,
	COPPER7_REPLY,
	
	RANDOM_GROWTH,
	GROWTH0_OIL0,
	GROWTH3_TARBALLS0,
	GROWTH6_JOULES0,
	GROWTH9_IRON0,
	GROWTH10_REPLY,
	GROWTH_RANDOM_SCREAM,
	
	RANDOM_CONCRETE,
	
	RANDOM_JOULES,
	JOULES4_COAL0,
	JOULES6_OIL0,
	
	RANDOM_OIL,
	
	RANDOM_TARBALLS,
	TARBALLS5_GROWTH0,
	
	RANDOM_MALIGNANCY,
	
	RANDOM_WATER,
	WATER6_REPLY,
	
	RANDOM_HUMUS,
	HUMUS7_GALENA0,
	
	RANDOM_SEEDS,
	
	RANDOM_DRAW_PLATE,
	DRAW_PLATE7_REPLY,
	DRAW_PLATE7_REPLY_REPLY,
	DRAW_PLATE7_REPLY_REPLY_REPLY,
	DRAW_PLATE7_REPLY_REPLY_REPLY_REPLY,
	
	RANDOM_TREES,
	TREES0_REPLY,
	TREES0_SOIL0,
	TREES2_REPLY,
	TREES2_REPLY_REPLY,
	TREES8_REPLY,
	
	RANDOM_SOIL,
	SOIL5_HUMUS0,
}

signal just_ready(emote)
signal finished(emote)
signal text_display_finished(emote)

var TYPE_KEYS := Type.keys()

var type: int
var key: String

var ready := false: # do not replace with Bool. as it is set up, must emit sending self as an arg.
	set(val):
		ready = val
		if val:
			emit_signal("just_ready", self)

var speaker: int
var dialogue: String
var reply := -1

const growth_scream_pool = [
	"AHHHHH!!!",
	"AWOOOOOOO!!!",
	"HUUUUGGHHH!!!",
	"OOOOOOOOO!!!",
	"EEEEEEEE!!!",
	"OH GAWWWWWWWWWWWWWWWWD!!!",
	"HEEEEEELLLLLLLLP!!!",
	"BAAAAAAGGGHHHH!!!",
	"ARGH!!!",
	"aaAAAAHEEEE!!!",
]

var posing := false
var pose_texture: Texture

var color: Color

var duration := 0.0



func _init(_type: int) -> void:
	type = _type
	key = TYPE_KEYS[type]
	
	randomize()
	
	call(key)
	
	color = lv.get_color(speaker)
	
	posing = pose_texture != null
	
	if duration == 0:
		var automatic_duration = 4 #(float(dialogue.length()) / 50) + (3 if posing else 0)
		duration = automatic_duration
	
	if not has_method("await_" + key):
		ready = true
	else:
		call("await_" + key)
	
	finished.connect(emote_finished)


func emote_finished(_emote: Emote) -> void:
	if not is_random():
		em.completed_emotes.append(type)



func await_COAL_GREET() -> void:
	lv.get_lored(LORED.Type.COAL).purchased.became_true.connect(connect_COAL_GREET)
func connect_COAL_GREET() -> void:
	ready = true
	lv.get_lored(LORED.Type.COAL).purchased.became_true.disconnect(connect_COAL_GREET)


func await_COAL_WHOA() -> void:
	lv.get_lored(LORED.Type.COAL).level.changed.connect(connect_COAL_WHOA)
func connect_COAL_WHOA() -> void:
	if lv.get_level(LORED.Type.COAL) == 2:
		ready = true
		lv.get_lored(LORED.Type.COAL).level.changed.disconnect(connect_COAL_WHOA)


func await_STONE_HAPPY() -> void:
	wi.connect("wish_completed", connect_STONE_HAPPY)
func connect_STONE_HAPPY(wish_type: int) -> void:
	if wish_type == Wish.Type.FUEL:
		ready = true
		wi.disconnect("wish_completed", connect_STONE_HAPPY)


func COAL_HUM() -> void:
	speaker = LORED.Type.COAL
	match em.coal_hum:
		23:
			dialogue = "ok the dev is outta ideas. more importantly, he wants to save you from yourself. it's been %s, dude. bye" % gv.parse_time_int(gv.session_duration.get_value())
			em.coal_hum = -1
		22: dialogue = "[b][shake rate=40.0 level=5 connected=1]CLICK THE[/shake] [shake rate=80.0 level=5 connected=1]BUTTOOOOOOOOOOOOOOON![/shake][/b]"
		21: dialogue = "[shake rate=30.0 level=5 connected=1]EEEEEEEEEEEEEEEEEEEEEEEEEEEEEE!!!!!!!![/shake]"
		20: dialogue = "[b]HELL NAWH, CLICK THE ----ING BUTTON YOU PIECE OF ----. I'M ACTUALLY ----ING DONE AT THIS POINT, ALRIGHT? CLICK. THE BUTTON. YOU ----FACE.[/b]"
		19:
			var a = lv.get_colored_name(LORED.Type.STONE)
			dialogue = "Look at %s. He's totally out of fuel. He's been waiting for you this entire time. If you don't do it for me, do it for him." % a
		18: dialogue = "Look, I--I... I just... holy crap. Click the button. Please."
		17: dialogue = "I'd rather you not level me up at this point. It would just mean that I have to spend this entire game with [b]you.[/b]"
		16: dialogue = "Gotcha, nerd! Now that I told you to do it, you won't. It won't be cool or funny anymore. IT'LL BE CRINGE, JUST LIKE YOU!"
		15: dialogue = "How about this: I dare you to screenshot this and post it online."
		14: dialogue = "[shake rate=30.0 level=5 connected=1]BROOOOOOOOOOOOOOOOO!!!!!!!!!!!!!!!![/shake]"
		13: dialogue = "[shake rate=20.0 level=5 connected=1]WHAT ARE YOU DOING!!![/shake] [b]CLICK THE BUTTON!!![/b]"
		12: dialogue = "Nah, nah, I ain't mad. I'm calm."
		11: dialogue = "LEVEL ME UP, BRO!! WHAT ARE YOU DOING??!"
		10: dialogue = "CLICK THE STAR BUTTON."
		9: dialogue = "If you ain't afk and you're just trickin me, I swear to frickin frick, bro."
		8: dialogue = "You had better be afk, bro! Frfr ong, bro, tch."
		7: dialogue = "For the love of [b]gawd[/b], click the freakin star button!!!"
		6: dialogue = "Don't you want to play the game, bro?"
		5: dialogue = "Are you ever going to level me up?"
		4: dialogue = "*Clicks tongue, turns into a sick beat box.*"
		3: dialogue = "*Whistles.*"
		2: dialogue = "Dododooo!"
		1: dialogue = "Hmhmhmmm!"
		0: dialogue = "Lalala!~"
	em.coal_hum += 1


func STONE_HAPPY():
	speaker = LORED.Type.STONE
	var name = lv.get_colored_name(LORED.Type.COAL)
	dialogue = "I'm so glad to have %s back again." % name
	reply = Type.STONE_HAPPY_COAL0


func STONE_HAPPY_COAL0():
	speaker = LORED.Type.COAL
	dialogue = "Thank you!"
	reply = Type.STONE_HAPPY_STONE0


func STONE_HAPPY_STONE0():
	speaker = LORED.Type.STONE
	dialogue = "No, thank you!"
	pose_texture = load("res://Sprites/reactions/STONE_HAPPY_STONE0.png")
	reply = Type.STONE_HAPPY_COAL1


func STONE_HAPPY_COAL1():
	speaker = LORED.Type.COAL
	pose_texture = load("res://Sprites/reactions/STONE_HAPPY_COAL1.png")



func COAL_WHOA():
	speaker = LORED.Type.COAL
	dialogue = "Whoa!"


func COAL_GREET():
	speaker = LORED.Type.COAL
	dialogue = "Hello!"



func RANDOM_COAL() -> void:
	speaker = LORED.Type.COAL
	var d = [0,1,2,3,4,5,6,7,10,13,15,]
	
	if lv.can_lored_emote(LORED.Type.TARBALLS):
		d.append(8)
		d.append(9)
	if lv.can_lored_emote(LORED.Type.JOULES):
		d.append(11)
	if lv.can_lored_emote(LORED.Type.COPPER_ORE):
		d.append(12)
	if not wa.is_rate_positive(Currency.Type.COAL):
		d.append(14)
	if lv.get_fuel_percent(speaker) <= lv.FUEL_WARNING:
		d.append(17)
	match d[randi() % d.size()]:
		17:
			dialogue = "Heeheeeee, I literally have priority over everyone else when it comes to fueling up. THAT'S RIGHT, YOU SICK FREAKS. NO MATTER HOW MUCH YOU TAKE, I'LL [b]ALWAYS[/b] BE ABLE TO HIT MAX FUEL."
			reply = Type.COAL14_REPLY
		16:
			dialogue = "I want to have kids someday!"
			if lv.can_lored_emote(LORED.Type.OIL):
				reply = Type.COAL16_REPLY
		15:
			var text = wa.get_icon_and_name_text(Currency.Type.COAL)
			dialogue = "Sometimes I take my %s with salt." % text
		14:
			var icon = wa.get_currency(Currency.Type.COAL).details.icon_text
			var text = wa.get_currency(Currency.Type.COAL).details.color_text % "COAL"
			dialogue = "WE NEED MORE %s %s! NONE OF YOU ARE GIVING ME A SECOND'S BREAK!" % [icon, text]
			reply = Type.COAL14_REPLY
		13:
			var stone_text = wa.get_icon_and_name_text(Currency.Type.STONE)
			var coal_text = wa.get_icon_and_name_text(Currency.Type.COAL)
			dialogue = "More %s, more %s! It's simple trickle-down %senomics." % [stone_text, coal_text, coal_text]
			reply = Type.COAL13_REPLY
		12:
			var text = lv.get_colored_name(LORED.Type.COPPER_ORE)
			dialogue = "%s's mine looks scary." % text
			reply = Type.COAL12_REPLY
		11:
			var text = lv.get_colored_name(LORED.Type.GROWTH)
			dialogue = "What in tarnation is %s doing? Somebody help him." % text
			reply = Type.GROWTH_RANDOM_SCREAM
		10:
			var f = [0]
			if lv.can_lored_emote(LORED.Type.JOULES):
				f.append(1)
			match f[randi() % f.size()]:
				0:
					dialogue = "I plugged my shovel into a socket, and it was... tee hee hee... [b]ELECTRIFYING!!![/b]"
				1:
					var text = lv.get_colored_name(LORED.Type.JOULES)
					dialogue = "Oh, oh!! Hey, %s. I saw you redirect lightning, and I thought it was quite... [b]SHOCKING!!!![/b] :)" % text
			reply = Type.COAL10_REPLY
		9:
			dialogue = "That baby is sucking oil. Now I have truly seen it all."
			reply = Type.COAL9_REPLY
		8:
			var text = lv.get_colored_name(LORED.Type.TARBALLS)
			dialogue = "Wow!!! Can %s hack into my ex's Facebook account?" % text
			reply = Type.COAL8_REPLY
		7: dialogue = "Why is this stuff purple?"
		6: dialogue = "I always liked playing support."
		5:
			dialogue = "If you didn't get enough, go ahead and take some more!"
			if lv.can_lored_emote(LORED.Type.COPPER_ORE):
				reply = Type.COAL5_REPLY
		4: dialogue = "I sure am grateful for this shovel."
		3: dialogue = "I hope my posture is good."
		2: dialogue = "Is this lump yours?\nJust kidding!"
		1: dialogue = "Glad to help!"
		0: dialogue = "Dig, dig!"


func COAL16_REPLY():
	speaker = LORED.Type.OIL
	dialogue = "*Farts and poops and sharts and toots.*"
	reply = Type.COAL16_REPLY_REPLY


func COAL16_REPLY_REPLY():
	speaker = LORED.Type.COAL
	dialogue = "Never mind."


func COAL14_REPLY():
	var d = [0,]
	if lv.can_lored_emote(LORED.Type.MALIGNANCY):
		d.append(8)
		d.append(7)
	if lv.can_lored_emote(LORED.Type.CONCRETE):
		d.append(6)
	if lv.can_lored_emote(LORED.Type.JOULES):
		d.append(5)
	if lv.can_lored_emote(LORED.Type.IRON):
		d.append(1)
		d.append(2)
		d.append(3)
		d.append(4)
	
	match d[randi() % d.size()]:
		0:
			speaker = LORED.Type.STONE
			dialogue = "Whoa."
		1:
			speaker = LORED.Type.IRON_ORE
			var text = lv.get_colored_name(LORED.Type.COAL)
			dialogue = "Yes, %s, embrace the dark side." % text
		2:
			speaker = LORED.Type.COPPER_ORE
			dialogue = "Fella's gettin' burnt out, I know all about that, boss, yessir."
		3:
			speaker = LORED.Type.IRON
			dialogue = "Um... Everyone needs to blow off some steam from time to time."
		4:
			speaker = LORED.Type.COPPER
			dialogue = "Hey, hey. Chill! Take it easy, brother! This is just a game!"
		5:
			speaker = LORED.Type.JOULES
			var text = lv.get_colored_name(LORED.Type.COAL)
			dialogue = "No, %s! You must never give in to despair! Allow yourself to slip down that road, and you surrender to your lowest instincts! In the darkest times, hope is something you give [b]yourself[/b]. That is the meaning of [b]inner strength[/b]." % text
		6:
			speaker = LORED.Type.CONCRETE
			dialogue = "Pinche loco."
		7:
			speaker = LORED.Type.TARBALLS
			var text = lv.get_colored_name(LORED.Type.COAL)
			dialogue = "%s's tilted." % text
		8:
			speaker = LORED.Type.OIL
			dialogue = "AH!!! ... :'("
			pose_texture = load("res://Sprites/reactions/OIL5.png")
	
	reply = Type.COAL14_REPLY_REPLY


func COAL14_REPLY_REPLY():
	speaker = LORED.Type.COAL
	dialogue = "Oops! Excuse me! Hee hee."


func COAL13_REPLY():
	speaker = LORED.Type.STONE
	var text = lv.get_colored_name(LORED.Type.COAL)
	dialogue = "%s's smart, listen to him!" % text


func COAL12_REPLY():
	var d = [0,]
	if lv.can_lored_emote(LORED.Type.CONCRETE):
		d.append(1)
	match d[randi() % d.size()]:
		0:
			speaker = LORED.Type.COPPER_ORE
			dialogue = "It is, see, boss, it is--JEREMY, PUT YOUR HARD HAT BACK ON, SEE. I know it's hard to breathe, Jeremy, real hard. But until the earth above is is properly supported, the hat there increases your chances of survival by 1% in the unlikely (but actually likely, see) event of a complete collapse of the tunnel. All right, now, let's get these supports set up, Jeremy. There's a good lad. Boy's only 17 years old, boss, 17. Brings a tear to my eye, boss. I'll make sure he has a Tallboy 'fore the sun sets, boss. Get it, boss? We ain't seen the sun in years, boss. That's a classic joke, see, real classic. He ain't never gonna get that Tallboy, boss. We're all gonna die down here, for $1.70 per day, boss. That's a historically accurate number, boss, look it up. It's sick down here, real sick."
		1:
			speaker = LORED.Type.CONCRETE
			dialogue = "Trabajo fácil. I could do it."


func COAL10_REPLY():
	var d = [0,]
	if lv.can_lored_emote(LORED.Type.JOULES):
		d.append(1)
	match d[randi() % d.size()]:
		0:
			speaker = LORED.Type.COAL
			dialogue = "Why didn't anyone laugh?"
		1:
			speaker = LORED.Type.JOULES
			dialogue = "Leaf me alone, I'm bushed."


func COAL9_REPLY():
	speaker = LORED.Type.COAL
	dialogue = "I want a taste."


func COAL8_REPLY():
	speaker = LORED.Type.TARBALLS
	dialogue = "With great power comes great responsibility. In other words, get lost."
	reply = Type.COAL8_REPLY_REPLY


func COAL8_REPLY_REPLY():
	var d = [0, 1]
	match d[randi() % d.size()]:
		0:
			speaker = LORED.Type.COAL
			dialogue = "True."
		1:
			speaker = LORED.Type.COPPER
			dialogue = "! Is that Spider-man?! Broo!"


func COAL5_REPLY():
	var d = [0,]
	if lv.can_lored_emote(LORED.Type.CONCRETE):
		d.append(1)
	if lv.can_lored_emote(LORED.Type.JOULES):
		d.append(1)
	match d[randi() % d.size()]:
		0:
			speaker = LORED.Type.COPPER_ORE
			dialogue = "Well, shoot, there, boss, don't mind if I do!"
		1:
			speaker = LORED.Type.CONCRETE
			dialogue = "Gracias, amigo."
		1:
			speaker = LORED.Type.JOULES
			dialogue = "Thank you."



func RANDOM_STONE() -> void:
	speaker = LORED.Type.STONE
	var d = [0,1,2,3,4,5,6,]
	
	if lv.can_lored_emote(LORED.Type.IRON_ORE):
		d.append(7)
	if lv.can_lored_emote(LORED.Type.TARBALLS):
		d.append(8)
		d.append(10)
	
	match d[randi() % d.size()]:
		10:
			var text = wa.get_icon_and_name_text(LORED.Type.OIL)
			dialogue = "Is it alright that that baby is slurping up %s? Uh... well, I'm sure his parents know what they're doing!" % text
		9: dialogue = "I like chocolate with peanut butter!"
		8:
			var text = lv.get_colored_name(LORED.Type.TARBALLS)
			dialogue = "%s seems pretty smart." % text
			reply = Type.STONE8_REPLY
		7:
			var name = lv.get_colored_name(LORED.Type.IRON_ORE)
			dialogue = "I don't like it when %s shoots rocks." % name
			reply = Type.STONE7_REPLY
		6: dialogue = "I wonder how much this one is worth."
		5: dialogue = "Gotta go fast!"
		4: dialogue = "Hey, I found one you might like!"
		3: dialogue = "My back smarts. :("
		2:
			dialogue = "My bag is getting heavy! :("
			pose_texture = load("res://Sprites/reactions/STONE2.png")
		1: dialogue = "Was that a hacky sack?"
		0: dialogue = "This one has a sweet edge!"


func STONE8_REPLY():
	var d = [0,]
	match d[randi() % d.size()]:
		0:
			speaker = LORED.Type.TARBALLS
			var text = lv.get_colored_name(LORED.Type.STONE)
			dialogue = "%s seems pretty stupid." % text


func STONE7_REPLY():
	speaker = LORED.Type.IRON_ORE
	dialogue = "Would you rather I shoot you?"
	pose_texture = load("res://Sprites/reactions/IRON_ORE_REPLY0.png")



func RANDOM_IRON_ORE() -> void:
	speaker = LORED.Type.IRON_ORE
	var d = [0, 1, 2, 3, 4, 5, 6, 7,8,9,10,11,12,13,14,19,20,21,22,23,25,]
	if lv.can_lored_emote(LORED.Type.TARBALLS):
		d.append(15)
		d.append(16)
	if lv.can_lored_emote(LORED.Type.JOULES):
		d.append(17)
	if lv.can_lored_emote(LORED.Type.GROWTH):
		d.append(18)
	if lv.get_fuel_percent(speaker) <= lv.FUEL_DANGER:
		d.append(24)
	match d[randi() % d.size()]:
		25: dialogue = "Joy and Grief are but two emotions on the coin of our brains, except our brains are full of coins. Wait, does that make any cents?"
		24:
			var text = lv.get_colored_name(LORED.Type.COAL)
			match randi() % 2:
				0: dialogue = "Are you kidding me? How did I get this low on fuel? Did you upgrade me too quickly? %s better not have a negative net output. I will [b]LOSE[/b] my [b]MIND[/b]. I will [b]FIND YOU[/b]. [b]FUEL ME UP. NOW.[/b]" % text
				1: dialogue = "I have a very important role in this system. Don't you understand? I [b]CAN'T[/b] have low fuel. [b]FIX IT.[/b]"
		23:
			var text = lv.get_colored_name(LORED.Type.STONE)
			dialogue = "%s. You're next." % text
		22:
			dialogue = "Yes. [b]JAB[/b] that shovel in, [b]real[/b] deep! Excellent!"
		21:
			var text = lv.get_colored_name(LORED.Type.COPPER_ORE)
			dialogue = "%s. That incessant whacking and clanging. [b]I[/b] choose to work [b]smarter[/b]." % text
		20:
			var text = lv.get_lored(LORED.Type.IRON).details.colored_alt_name
			dialogue = "%s. I follow you, my brother. My captain. My king." % text
		19:
			dialogue = "Hey, guess what, buddy? Those [b]aren't[/b] s'mores."
			reply = Type.IRON_ORE15_REPLY
		18:
			dialogue = "Look at that idiot! Ever heard of chemotherapy, you ding dong?!"
			reply = Type.IRON_ORE14_REPLY
		17:
			var text = lv.get_colored_name(LORED.Type.JOULES)
			dialogue = "%s upsells you when you go in for only an oil change, he is [b]proud[/b] of it." % text
		16: dialogue = "That baby is absolutely, positively [b]disgusting[/b]."
		15:
			var text = lv.get_colored_name(LORED.Type.TARBALLS)
			dialogue = "That moron %s thinks he's smart, but all he does is create matter out of oil and cancer juice.\n\nWait, what? He does that? Holy crap. Well, I still don't like him." % text
		14: dialogue = "I hate existing."
		13: dialogue = "My ribcage is starting to hurt."
		12: dialogue = "I hate children."
		11: dialogue = "I hate chocolate, and I hate peanut butter."
		0: dialogue = "DIE!"
		1: dialogue = "KILL!"
		2: dialogue = "GAH!"
		3: dialogue = "BAH!"
		4: dialogue = "This is what you [b]GET!"
		5: dialogue = "RAHHugH!"
		6: dialogue = "MMUHRRaahhHRcK!"
		7: dialogue = "Would you please die? Thank you."
		8:
			dialogue = "Can someone pass me some more shells?"
			reply = Type.IRON_ORE8_REPLY
		9:
			dialogue = "I learned something about myself the other day. I want literally everyone to die."
			reply = Type.IRON_ORE9_REPLY
		10:
			pose_texture = load("res://Sprites/reactions/IRON_ORE10.png")


func IRON_ORE15_REPLY():
	speaker = LORED.Type.COPPER
	dialogue = "How could you even say that to me?"


func IRON_ORE14_REPLY():
	speaker = LORED.Type.GROWTH
	dialogue = "It's in remission!!!"


func IRON_ORE8_REPLY():
	speaker = LORED.Type.STONE
	dialogue = "No, you creep!"


func IRON_ORE9_REPLY():
	speaker = LORED.Type.JOULES
	dialogue = "That's not even shocking, dude."



func RANDOM_COPPER_ORE() -> void:
	speaker = LORED.Type.COPPER_ORE
	var d = [0, 1, 2, 3, 4, 5, 6,9,10,11,12,13,14]
	if lv.get_fuel_percent(speaker) < lv.FUEL_DANGER:
		d.append(8)
	if lv.can_lored_emote(LORED.Type.OIL):
		d.append(7)
	match d[randi() % d.size()]:
		14: dialogue = "No escaping the coal dust, boss, no siree!"
		13: dialogue = "Shaft's unstable as usual, boss, watch your step!"
		12: dialogue = "You reckon I'll ever see the sun again, boss?"
		11: dialogue = "My father died in this here mine. Yes he sure did, boss. I was there, saw it with my own two eyes, I did. Soon enough little Jimmy'll be ten and I'll have him in here to see me die as well!"
		10: dialogue = "Little Jimmy asked for a new dog. Ha, ha, ha... Well, you can guess what I said. Money surely doesn't grow on trees, does it, boss?"
		9: dialogue = "Can't wait to get home to get my 4 hours of sleep and beat my wife a little!"
		8:
			var text = wa.get_icon_and_name_text(Currency.Type.COAL)
			dialogue = "Hey, we're out of %s in the mine, and out of %s in the game, too! Look at that, boss!" % [text, text]
		7:
			dialogue = "Good god, look at how young those corporate fat heads have lowered the minimum working age to! It's downright horrific, see! I won't stand for it, boss, I just won't, y'see?!"
			reply = Type.COPPER_ORE7_REPLY
		6:
			var text = lv.get_colored_name(LORED.Type.COPPER)
			var text2 = lv.get_colored_name(LORED.Type.IRON_ORE)
			dialogue = "%s, stop! Ah, see? Now a fire's started. See, that's now fixing to consume what little oxygen we have left down here, boss. Yep, takes a real man to brave these absolute twisted work conditions, boss. Complete and totally, unspeakably-twisted work conditions. Just have %s shoot me now, boss, just have him shoot me now." % [text, text2]
			reply = Type.COPPER_ORE6_REPLY
		5:
			var text = lv.get_colored_name(LORED.Type.IRON_ORE)
			dialogue = "Unfortunately, I am seen as the brother or equal of %s, see, and that just ain't right. This fat head would ricochet-murder at least 5 workers in the mine, here, shootin' wild-like like that. No, it's not right at all, boss, not right at all, boss, at all, boss, all boss--hrrgggk.\nWhoa, I just blacked out, there, boss, am I okay?" % text
		4:
			var text = lv.get_colored_name(LORED.Type.COAL)
			dialogue = "Now, see %s here, boss? This one's the only one who could make it in the mine, here, boss. He's tough, real tough. Of course, I'd never want him to work here. No, this mine should be shut down. But a man's gotta do what a man's gotta do, see?" % text
		3: dialogue = "You gotta be tough as nails to work down in the mines! This ain't no Weenie Hut Jr's, boss!"
		2: dialogue = "Soon as the mortgage is paid off, I'll be clean out of here for good. Yes, sir, boss. I know it only had 3 years remaining when we re-financed, but there was nothin that could be done about it. 30 more years and I'll be free!"
		1: dialogue = "Last time I was down this deep alone, my headlamp went out. Yes, it sure did, boss. I would know. I was there. Anyway, they found me a few days later. Wife thought I was off with some broad! I slapped her around a little to let her know she was the only one for me. Overall, all's right as rain, boss!"
		0:
			dialogue = "Whatever I need to do to put bread on the table, boss!"
			if lv.can_lored_emote(LORED.Type.IRON):
				reply = Type.COPPER_ORE0_REPLY


func COPPER_ORE7_REPLY():
	var d = [0,]
#	if lv.can_lored_emote(LORED.Type.DRAW_PLATE):
#		d.append(1)
	match d[randi() % d.size()]:
		0:
			speaker = LORED.Type.COPPER_ORE
			dialogue = "On second thought, see, I reckon it'll toughen him up. I was in the mine even before I was his age, and look at me--I turned out okay, boss, don't you think so?"


func COPPER_ORE6_REPLY():
	var d = [0]
#	if lv.can_lored_emote(LORED.Type.DRAW_PLATE):
#		d.append(1)
	match d[randi() % d.size()]:
		0:
			speaker = LORED.Type.IRON_ORE
			dialogue = "With [b]extreme[/b] pleasure."


func COPPER_ORE0_REPLY():
	var d = [0]
#	if lv.can_lored_emote(LORED.Type.DRAW_PLATE):
#		d.append(1)
	match d[randi() % d.size()]:
		0:
			speaker = LORED.Type.IRON
			dialogue = "You're going through all that for bread? You should have just come to me!"



func RANDOM_IRON() -> void:
	speaker = LORED.Type.IRON
	var d = [0,1,2,3,4,5,6,7,]
	match d[randi() % d.size()]:
		7: dialogue = "My arm is getting tired."
		6: dialogue = "At this point, I'm going to need more toasters."
		5: dialogue = "I shouldn't have left that one in for so long."
		4:
			dialogue = "Can I borrow anyone's helmet?"
			if lv.can_lored_emote(LORED.Type.COPPER_ORE):
				reply = Type.IRON4_REPLY
		3: dialogue = "I haven't cleaned this toaster since I bought it!"
		2:
			var name = lv.get_colored_name(LORED.Type.IRON_ORE)
			dialogue = "%s's methods may be extreme, but we need him nonetheless." % name
			reply = Type.IRON2_REPLY
		1:
			var name = lv.get_colored_name(LORED.Type.STONE)
			dialogue = "Thank you for working so hard, %s!" % name
			reply = Type.IRON1_REPLY
		0: dialogue = "Bread is good, but [b]toast[/b]... Toast is better."


func IRON1_REPLY():
	speaker = LORED.Type.STONE
	dialogue = "I couldn't do it without you, buddy!"


func IRON2_REPLY():
	var d = [0,1,]
	match d[randi() % d.size()]:
		0:
			speaker = LORED.Type.IRON_ORE
			dialogue = "I can hear you, but I'm going to pretend like I can't."
		1:
			speaker = LORED.Type.STONE
			dialogue = "Are you sure about that?"


func IRON4_REPLY():
	var d = []
	if lv.can_lored_emote(LORED.Type.HARDWOOD):
		d.append(0)
	if lv.can_lored_emote(LORED.Type.COPPER_ORE):
		d.append(1)
	if d.size() == 0:
		return
	match d[randi() % d.size()]:
		0:
			speaker = LORED.Type.HARDWOOD
			dialogue = "Yes, but actually, no!"
		1:
			speaker = LORED.Type.COPPER_ORE
			dialogue = "Get this man his hardhat, now, see?! Boss, this just ain't right, no, it just ain't. Safety must come first, now, y'see!"



func RANDOM_COPPER() -> void:
	speaker = LORED.Type.COPPER
	var d = [0, 1, 2, 3, 4, 5, 6, 7,12,13,14,]
	if lv.can_lored_emote(LORED.Type.OIL):
		d.append(8)
		d.append(9)
		d.append(10)
	if lv.get_fuel_percent(speaker) < lv.FUEL_DANGER:
		d.append(11)
	match d[randi() % d.size()]:
		14: dialogue = "C'mere n get yourself s'more... S'more s'mooches!"
		13: dialogue = "I found an extra piece of graham cracker in the bottom of the box!"
		12:
			dialogue = "I dreamt a future where there were no trees, no campsites. The air was poisonous. The bio balance of life was out of sorts. Farm food rotted, billions died. Marshmallow factories went bankrupt, as there were no campers to buy marshmallows. [b]S'mores[/b]... more like [b]n'mores[/b]. We followed soon after. I was the only one left, in a desert, my lips chapped, unable to move, as the lack of any moisture left my skin taut and crusty. I sat before a circle of rocks, a rod in my hand... with no wood for a fire, nothing stuck on the rod, and no one to share any of it with anyway. I waited for death, but it never came."
			reply = Type.COPPER12_REPLY
		11:
			var icon = lv.get_lored(LORED.Type.COAL).icon_text
			var name = lv.get_colored_name(LORED.Type.COAL)
			var text = lv.get_lored(LORED.Type.COAL).details.color_text % ("Coca-Coal %s" % name)
			dialogue = "%s %s, what's happening, bro? Fill me up, baby! No homo." % [icon, text]
			
		10:
			var text = lv.get_colored_name(LORED.Type.MALIGNANCY)
			dialogue = "Oh, shit!! They on X-games mode, bruh!!! What the hell even is that?! %s you are freaking me the fuh-reak out, bro!!" % text
		9:
			var text = lv.get_colored_name(LORED.Type.TARBALLS)
			dialogue = "%s and I have a playdate scheduled. We're gonna compare the English and Japanese dubs for the final episode of Death Note. Siiiick!" % text
		8: dialogue = "I literally can't stop laughing at that baby, yo!!"
		0: dialogue = "This stuff's the bee's knees!"
		1: pose_texture = load("res://Sprites/reactions/COPPER1.png")
		2: dialogue = "Anyone want s'more?"
		3: dialogue = "C'mon 'n rest ya dogs--try one of these bad bad boys!"
		4:
			dialogue = "Can I get some firewood?"
			if lv.can_lored_emote(LORED.Type.WOOD):
				reply = Type.COPPER4_REPLY
		5: dialogue = "Stay awhile and listen to the fire."
		6: dialogue = "Mmm! Gith ith good!"
		7:
			var name = lv.get_colored_name(LORED.Type.COPPER_ORE)
			dialogue = "%s, these puppies are amazing!" % name
			reply = Type.COPPER7_REPLY


func COPPER12_REPLY():
	var d = [0, 2, 3]
	if lv.can_lored_emote(LORED.Type.TARBALLS):
		d.append(1)
	match d[randi() % d.size()]:
		0:
			speaker = LORED.Type.IRON
			var text = lv.get_colored_name(LORED.Type.COPPER)
			dialogue = "Oh, gosh, %s, are you okay?" % text
			reply = Type.COPPER12_REPLY0_REPLY
		1:
			speaker = LORED.Type.TARBALLS
			dialogue = "I read something like that in a manga once."
		2:
			speaker = LORED.Type.IRON_ORE
			dialogue = "Fascinating. Go on."
			reply = Type.COPPER12_REPLY2_REPLY
		3:
			speaker = LORED.Type.COPPER_ORE
			dialogue = "This fella's showin' signs of being shell-shocked, boss. That's all there is to that. He'll be fine."


func COPPER12_REPLY0_REPLY():
	speaker = LORED.Type.COPPER
	dialogue = "What? Dude, yeah, man! It was just a dream, bro! Ahah!"


func COPPER12_REPLY2_REPLY():
	speaker = LORED.Type.COPPER
	dialogue = "In truth, I died when those factories went under. I am not [b]a'live[/b] without [b]s'mores[/b]. But, it's okay. In real life, people wouldn't stop buying marshmallows, even if all the trees were gone. ...Right?"


func COPPER4_REPLY():
	speaker = LORED.Type.WOOD
	dialogue = "I got you, bro!"


func COPPER7_REPLY():
	speaker = LORED.Type.COPPER_ORE
	dialogue = "Gee, thanks, pal! All in a hard day's work, see?"



func RANDOM_JOULES() -> void:
	speaker = LORED.Type.JOULES

	var d = [0,1,2,3,4,5,6,7,8,]
	match d[randi() % d.size()]:
		8: dialogue = "People always pronounce my name wrong. It's Japanese, just like the best cars! It's \"Nots-ko\"!"
		0: dialogue = "It took me 12 years to be able to redirect lightning!"
		1: dialogue = "My batteries are shock-full!"
		2: dialogue = "Anyone's car need a jump-start?"
		3: dialogue = "I can offer you parts at a reduced price!"
		4:
			var name = lv.get_colored_name(LORED.Type.COAL)
			dialogue = "Thanks for the parts again, %s. Same time, same place next week?" % name
			reply = Type.JOULES4_COAL0
		5: dialogue = "Cars! Cars! Cars! Cars! Cars! Cars! Cars!"
		6:
			dialogue = "Anyone need an oil change?"
			if lv.is_lored_unlocked(LORED.Type.OIL):
				reply = Type.JOULES6_OIL0
		7: dialogue = "Have you heard about the new Mazda Corada Tesla Chevy Chevy Tahoe Master Blaster Zipper Street Crippler with an all-electric diesel 50,000 horse power V90 engine capable of 1 to 60 in 0.13 giggywiggynano seconds? They just announced it. It will hit the market in 2420, or even sooner! I already sent a downpayment on it, I know it will be the future of all cars."


func JOULES4_COAL0():
	speaker = LORED.Type.COAL
	dialogue = "See you next week!"


func JOULES6_OIL0():
	speaker = LORED.Type.OIL
	dialogue = "Blblblfsh!!"



func RANDOM_GROWTH() -> void:
	speaker = LORED.Type.GROWTH
	var d = [1,2,3,4,5,6,7,8,9,10,11,]
	if lv.can_lored_emote(LORED.Type.OIL):
		d.append(0)
	match d[randi() % d.size()]:
		11: dialogue = "My skin is raw and wriggling."
		10:
			dialogue = "Does anyone want some juice?"
			reply = Type.GROWTH10_REPLY
		0:
			var text = lv.get_colored_name(LORED.Type.OIL)
			dialogue = "I think %s just made a boom-boom." % text
			reply = Type.GROWTH0_OIL0
		1: dialogue = "Oh, your grandma got cancer three times? Must be nice."
		2: dialogue = "Junji Ito ain't never thought of this!"
		3:
			dialogue = "Does such a thing as a chemotherapy water bed exist?"
			reply = Type.GROWTH3_TARBALLS0
		4: dialogue = "Call 9-1-1."
		5: dialogue = "Send help."
		6:
			dialogue = "The amount of water I need daily would shock anyone."
			reply = Type.GROWTH6_JOULES0
		7: dialogue = "I had to go bald, I couldn't take the constant re-grooming."
		8: dialogue = "But, in a way, this is satisfying!"
		9:
			dialogue = "Whatever you do, just don't ask me how I make growth out of iron and copper."
			reply = Type.GROWTH9_IRON0


func GROWTH10_REPLY():
	var d = [0]
	if lv.can_lored_emote(LORED.Type.CONCRETE):
		d.append(1)
	match d[randi() % d.size()]:
		0:
			speaker = LORED.Type.STONE
			dialogue = "Sure, don't mind if I do! *Glug glug.* [b]oh god[/b]"
		1:
			speaker = LORED.Type.CONCRETE
			dialogue = "No mames!"


func GROWTH_RANDOM_SCREAM():
	speaker = LORED.Type.GROWTH
	dialogue = growth_scream_pool[randi() % growth_scream_pool.size()]


func GROWTH0_OIL0():
	speaker = LORED.Type.OIL
	dialogue = "Hahahahaha!!"


func GROWTH3_TARBALLS0():
	speaker = LORED.Type.TARBALLS
	dialogue = "Nope."


func GROWTH6_JOULES0():
	speaker = LORED.Type.JOULES
	dialogue = "Someone say shock?"


func GROWTH9_IRON0():
	speaker = LORED.Type.IRON
	dialogue = "I'd say you're pretty clever for it, buddy!"



func RANDOM_CONCRETE() -> void:
	speaker = LORED.Type.CONCRETE
	var d = [0,1,2,3,4,5,6,7,]
	match d[randi() % d.size()]:
		0: dialogue = "Que?"
		1: dialogue = "Thank you, Primo!"
		2: dialogue = "Quítate, chingada!"
		3: dialogue = "Mi casa es su casa, hombre!"
		4: dialogue = "Que pasa, jefe?"
		5: dialogue = "No hablo Ingles. Can you translate?"
		6: dialogue = "What channel is the soccer game on?"
		7: dialogue = "Buenas noches, mi amor!"



func RANDOM_OIL() -> void:
	speaker = LORED.Type.OIL
	var d = [0,1,2,3,4,5,6,7,8,9,10,]
	match d[randi() % d.size()]:
		0: dialogue = "But I just a baby!"
		1: dialogue = "Plbdffffffffshh!"
		2: dialogue = "Pow! Pow pow! Pow pow pow pow pow!"
		3: dialogue = "AHHHHHHH!"
		4: dialogue = "Waaaahhhhh!!!"
		5: pose_texture = load("res://Sprites/reactions/OIL5.png")
		6: dialogue = "*Pooped a little.*"
		7: pose_texture = load("res://Sprites/reactions/OIL7.png")
		8: dialogue = "Slurp!!!"
		9: dialogue = "Dada?"
		10: dialogue = "Mama?"



func RANDOM_TARBALLS() -> void:
	speaker = LORED.Type.TARBALLS
	var d = [0,1,2,3,4,5,6,7,8,]
	match d[randi() % d.size()]:
		0: dialogue = "I'm still working on the perfect mixture."
		1: dialogue = "That was good, but I can do better."
		2: dialogue = "I lost some important notes. I need to be more careful."
		3: dialogue = "I'm glad I'm able to work right now. I'm easily distracted."
		4: dialogue = "I only live so long. I need to get this right!"
		5:
			var name = lv.get_colored_name(LORED.Type.GROWTH)
			dialogue = "Thank you for your un-ending donations, %s." % name
			reply = Type.TARBALLS5_GROWTH0
		6: dialogue = "I can't wait for the next chapter of One-Punch Man!"
		7: dialogue = "I'd like to see you wiggle, wiggle, for sure."
		8: dialogue = "This makes me want to dribble, dribble."


func TARBALLS5_GROWTH0():
	speaker = LORED.Type.GROWTH
	dialogue = "I'm not donating it! How are you getting it??"



func RANDOM_MALIGNANCY() -> void:
	speaker = LORED.Type.MALIGNANCY
	var d = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,]
	match d[randi() % d.size()]:
		0: dialogue = "Hiya. I just coalesced out of sticky, oily stuff and cancer juice. How's your day going?"
		1: dialogue = "Hi. Oh, wow, there are a lot of me."
		2:
			var name = lv.get_colored_name(LORED.Type.MALIGNANCY)
			dialogue = "Whoa, hello! I'm %s... Oh, so are all of you?" % name
		3: dialogue = "OH GOd--oh, hello."
		4: dialogue = "Oh, hi! Nice to meet y'all!"
		5: dialogue = "Wow! So THAT's what being born is like!"
		6: dialogue = "Literally 1 second ago I did not exist. Isn't that weird to think about?"
		7:
			var name = lv.get_colored_name(LORED.Type.MALIGNANCY)
			dialogue = "Oop--hi! I'm %s. Nice to meet you." % name
		8: dialogue = "Hello!"
		9: dialogue = "Hi!"
		10: dialogue = "Hey!"
		11: dialogue = "What's up?"
		12: dialogue = "Hi, guys!"
		13: dialogue = "Hey, I guess."



func RANDOM_WATER() -> void:
	speaker = LORED.Type.WATER
	var d = [0,1,2,3,4,5,6,7,8,9,]
	match d[randi() % d.size()]:
		0: dialogue = "Ew, there's bugs in the water!"
		1: pose_texture = load("res://Sprites/reactions/WATER1.png")
		2: pose_texture = load("res://Sprites/reactions/WATER2.png")
		3: dialogue = "I bet I have a sunburn."
		4: dialogue = "Oh, no! I'm cramping!"
		5: dialogue = "I don't need it. I definitely don't need it."
		6:
			dialogue = "Does anyone want to play with me?"
			reply = Type.WATER6_REPLY
		7: dialogue = "My ears are clogged with water!"
		8: dialogue = "I wish I had a noodle!"
		9: pose_texture = load("res://Sprites/reactions/WATER9.png")


func WATER6_REPLY():
	var d = [0,]
	if lv.can_lored_emote(LORED.Type.DRAW_PLATE):
		d.append(1)
	match d[randi() % d.size()]:
		0:
			speaker = LORED.Type.TREES
			dialogue = "I do!"
		1:
			speaker = LORED.Type.DRAW_PLATE
			dialogue = "Me!!!!"



func RANDOM_HUMUS() -> void:
	speaker = LORED.Type.HUMUS
	var d = [0,1,2,3,4,5,6,7,8,]
	match d[randi() % d.size()]:
		0: dialogue = "Heigh, give me an apple, I'm a freakin horse."
		1: dialogue = "First I champ, then I stamp, then I stand still!"
		2: dialogue = "Y'all are doing WHAT with my poop?!"
		3: pose_texture = load("res://Sprites/reactions/HUMUS3.png")
		4: dialogue = "No, don't put that saddle on me--I cannot be tamed!"
		5: dialogue = "I am a beautiful stallion!"
		6: dialogue = "Whinny... the Pooh!"
		7:
			dialogue = "Somebody, please trim my damn hooves before I keel over."
			reply = Type.HUMUS7_GALENA0
		8: dialogue = "*Browsing [u]http://localmares.com[/u].* Wait--no! I meant--UH--I meant to search local [b]wares!![/b]"


func HUMUS7_GALENA0():
	speaker = LORED.Type.GALENA
	dialogue = "No problem, boss! I'll fix yer up straight away!"



func RANDOM_SEEDS() -> void:
	speaker = LORED.Type.SEEDS
	var d = [0,1,2,3,4,5,6,7,8,]
	match d[randi() % d.size()]:
		0: dialogue = "Buzz, buzz!"
		1: dialogue = "Honey is good."
		2: dialogue = "Don't comb your hair, it'll get sticky!!!"
		3: dialogue = "Don't mind me, I wouldn't sting a fly."
		4: dialogue = "Guess what kind of gum I chew! ... Bumble gum!"
		5: dialogue = "Oh, sorry, am I droning on?"
		6: dialogue = "Later today, I'm going to the barber for a buzz cut!"
		7: dialogue = "If it's raining, I never forget my yellow jacket!"
		8: dialogue = "My birthday is in May, that's where I got my name from!"



func RANDOM_TREES() -> void:
	speaker = LORED.Type.TREES
	var d = [0,1,2,3,4,5,6,7,8,]
	match d[randi() % d.size()]:
		8:
			var name = lv.get_colored_name(LORED.Type.SEEDS)
			dialogue = "%s, these seeds are poppin'!" % name
			reply = Type.TREES8_REPLY
		7: dialogue = "These volatile seeds won't leaf me alone!"
		6: dialogue = "These sprouts blasting me have given me rock-hard abs!"
		5: dialogue = "Want to see me do a cool trick? Watch!"
		4: dialogue = "I want to try rock climbing one day!"
		3: dialogue = "Acrobatics level up!"
		2:
			dialogue = "Thanks for the water, friend!"
			reply = Type.TREES2_REPLY
		1: dialogue = "They call me Green Face!"
		0:
			dialogue = "Have you ever been through as much crap as I have?"
			reply = Type.TREES0_REPLY


func TREES0_REPLY():
	var d = [0,1,]
	if lv.can_lored_emote(LORED.Type.SOIL):
		d.append(2)
	match d[randi() % d.size()]:
		0:
			var text = lv.get_colored_name(LORED.Type.TREES)
			speaker = LORED.Type.GROWTH
			dialogue = "Are you freakin joking me, %s?" % text
		1:
			var text1 = wa.get_icon_and_name_text(Currency.Type.TREES)
			var text2 = lv.get_colored_name(LORED.Type.TREES)
			speaker = LORED.Type.JOULES
			dialogue = "This fella must be jokin. Havin a nice time with the %s in the garden, are ya, %s?" % [text1, text2]
		2:
			speaker = LORED.Type.SOIL
			dialogue = "Um, hello??"


func TREES2_REPLY():
	speaker = LORED.Type.WATER
	dialogue = "It has chlorine in it!"
	reply = Type.TREES2_REPLY_REPLY


func TREES2_REPLY_REPLY():
	speaker = LORED.Type.TREES
	dialogue = "Come again?"
	pose_texture = load("res://Sprites/reactions/TREES2_REPLY_REPLY.png")


func TREES8_REPLY():
	speaker = LORED.Type.SEEDS
	dialogue = "Too bad I'm not the Corn LORED!"



func RANDOM_SOIL() -> void:
	speaker = LORED.Type.SOIL
	var d = [0,1,2,3,4,5,6,7,]
	match d[randi() % d.size()]:
		0: dialogue = "Gosh, what a sticky situation."
		1: dialogue = "This stinks."
		2: dialogue = "Wee!"
		3: dialogue = "What are gloves?"
		4: dialogue = "Do you think there is a Candle LORED?"
		5:
			dialogue = "I only have this one poo pile remaining. Then I'll be done for good!"
			reply = Type.SOIL5_HUMUS0
		6: dialogue = "Even though I'm pretty good at programming, I ended up working in the poopy industry!"
		7: dialogue = "I wish I were at home in a hot bath with fresh coffee and cookies, and a whole lot of soap."


func SOIL5_HUMUS0():
	speaker = LORED.Type.HUMUS
	dialogue = "Hah, poor guy! Every time he turns around, I add to his pile."



func RANDOM_DRAW_PLATE() -> void:
	speaker = LORED.Type.DRAW_PLATE
	var d = [0,1,2,3,4,5,6,7,8,9,10,]
	match d[randi() % d.size()]:
		0: dialogue = "Next, I'm going to draw a castle!"
		1: dialogue = "Who is your favorite superhero?"
		2: dialogue = "I wish I could have pizza for dinner every night!"
		3: dialogue = "My favorite color is orange. What about you?"
		4: dialogue = "Can we go to the park later?"
		5: dialogue = "My favorite animal is a panda."
		6: dialogue = "I don't want to go to bed early tonight."
		7:
			dialogue = "Can I have some ice cream?"
			reply = Type.DRAW_PLATE7_REPLY
		8: dialogue = "Can I have some ice cream after I finish my drawing?"
		9: dialogue = "I don't like doing homework!"
		10: dialogue = "Have you ever been to the park? What's your favorite part about the park?"


func DRAW_PLATE7_REPLY() -> void:
	speaker = LORED.Type.WIRE
	dialogue = "No, honey."
	reply = Type.DRAW_PLATE7_REPLY_REPLY


func DRAW_PLATE7_REPLY_REPLY() -> void:
	speaker = LORED.Type.DRAW_PLATE
	dialogue = "What about after I finish drawing?"
	reply = Type.DRAW_PLATE7_REPLY_REPLY_REPLY


func DRAW_PLATE7_REPLY_REPLY_REPLY() -> void:
	speaker = LORED.Type.WIRE
	dialogue = "We'll see."
	reply = Type.DRAW_PLATE7_REPLY_REPLY_REPLY_REPLY


func DRAW_PLATE7_REPLY_REPLY_REPLY_REPLY() -> void:
	speaker = LORED.Type.DRAW_PLATE
	dialogue = "Ok."



# - Signal

func finished_displaying_text() -> void:
	emit_signal("text_display_finished", self)


func finish() -> void:
	finished.emit(self)


# - Get

func has_dialogue() -> bool:
	return dialogue != ""


func has_reply() -> bool:
	return reply != -1


func is_random() -> bool:
	return type >= Type.RANDOM_STONE
