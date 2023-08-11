class_name Emote
extends Resource



enum Type {
	TEST,
	
	STONE_HAPPY, STONE_HAPPY_COAL0, STONE_HAPPY_STONE0, STONE_HAPPY_COAL1,
	COAL_WHOA,
	COAL_GREET,
	
	RANDOM_STONE,
	STONE7_IRON_ORE,
	
	RANDOM_COAL,
	COAL5_COPPER_ORE0,
	COAL5_CONCRETE0,
	COAL5_JOULES0,
	
	RANDOM_IRON_ORE,
	IRON_ORE8_STONE_REPLY0,
	IRON_ORE9_JOULES0,
	
	RANDOM_COPPER_ORE,
	
	RANDOM_IRON,
	IRON1_STONE0,
	IRON2_STONE0,
	IRON2_IRON_ORE0,
	IRON4_HARDWOOD0,
	
	RANDOM_COPPER,
	COPPER4_WOOD0,
	COPPER7_COPPER_ORE0,
	
	RANDOM_GROWTH,
	GROWTH0_OIL0,
	GROWTH3_TARBALLS0,
	GROWTH6_JOULES0,
	GROWTH9_IRON0,
	
	RANDOM_CONCRETE,
	
	RANDOM_JOULES,
	JOULES4_COAL0,
	JOULES6_OIL0,
	
	RANDOM_OIL,
	
	RANDOM_TARBALLS,
	TARBALLS5_GROWTH0,
	
	RANDOM_MALIGNANCY,
	
	RANDOM_WATER,
	WATER6_TREES0,
	WATER6_DRAW_PLATE0,
	
	RANDOM_HUMUS,
	HUMUS7_GALENA0,
	
	RANDOM_SEEDS,
	
	RANDOM_DRAW_PLATE,
	DRAW_PLATE7_WIRE0,
	DRAW_PLATE7_DRAW_PLATE0,
	DRAW_PLATE7_WIRE1,
	
	RANDOM_TREES,
	TREES0_GROWTH0,
	TREES0_SOIL0,
	TREES2_WATER0,
	TREES2_TREES0,
	TREES8_SEEDS0,
	
	RANDOM_SOIL,
	SOIL5_HUMUS0,
}

signal became_ready_to_emote
signal finished_emoting
signal just_fully_displayed

var TYPE_KEYS := Type.keys()

var type: int
var key: String

var ready_to_emote := false

var speaker: LORED
var dialogue: String
var reply := -1
var possible_replies := []

var posing := false
var pose_texture: Texture

var color: Color

var duration := 0.0



func _init(_type: int) -> void:
	type = _type
	key = TYPE_KEYS[type]
	
	call(key)
	
	color = speaker.color
	
	if possible_replies.size() > 0:
		reply = possible_replies[randi() % possible_replies.size()]
	
	posing = pose_texture != null
	
	if duration == 0:
		var automatic_duration = 3 + (float(dialogue.length()) / 25) + (3 if posing else 0)
		duration = automatic_duration
	
	if not has_method("await_" + key):
		ready_to_emote = true
		emit_signal("became_ready_to_emote")
	else:
		call("await_" + key)
		await became_ready_to_emote
		ready_to_emote = true
	
	if type < Type.RANDOM_STONE:
		await finished_emoting
		em.completed_emotes.append(type)



func await_COAL_GREET() -> void:
	await lv.get_lored(LORED.Type.COAL).leveled_up
	emit_signal("became_ready_to_emote")


func await_COAL_WHOA() -> void:
	while await lv.get_lored(LORED.Type.COAL).leveled_up != 2:
		pass
	emit_signal("became_ready_to_emote")


func await_STONE_HAPPY() -> void:
	while await wi.wish_completed != Wish.Type.FUEL:
		pass
	emit_signal("became_ready_to_emote")



func TEST():
	speaker = lv.get_lored(LORED.Type.COAL)
	dialogue = "Once upon a time, there was a little baby boy who was a stinky. But then, he did something insane! He freaked out! Like, wow. Isn't that crazy? I think so, anyway. Yep! Signing off!"



func STONE_HAPPY():
	speaker = lv.get_lored(LORED.Type.STONE)
	dialogue = "I'm so glad to have Coal back again."
	reply = Type.STONE_HAPPY_COAL0


func STONE_HAPPY_COAL0():
	speaker = lv.get_lored(LORED.Type.COAL)
	dialogue = "Thank you!"
	reply = Type.STONE_HAPPY_STONE0


func STONE_HAPPY_STONE0():
	speaker = lv.get_lored(LORED.Type.STONE)
	dialogue = "No, thank you!"
	pose_texture = load("res://Sprites/reactions/STONE_HAPPY_STONE0.png")
	reply = Type.STONE_HAPPY_COAL1


func STONE_HAPPY_COAL1():
	speaker = lv.get_lored(LORED.Type.COAL)
	pose_texture = load("res://Sprites/reactions/STONE_HAPPY_COAL1.png")



func COAL_WHOA():
	speaker = lv.get_lored(LORED.Type.COAL)
	dialogue = "Whoa!"


func COAL_GREET():
	speaker = lv.get_lored(LORED.Type.COAL)
	dialogue = "Hello!"



func RANDOM_COAL() -> void:
	speaker = lv.get_lored(LORED.Type.COAL)
	match randi() % 8:
		0: dialogue = "Dig, dig!"
		1: dialogue = "Glad to help!"
		2: dialogue = "Is this lump yours?\nJust kidding!"
		3: dialogue = "I hope my posture is good."
		4: dialogue = "I sure am grateful for this shovel."
		5:
			dialogue = "If you didn't get enough, go ahead and take some more!"
			possible_replies = [
				Type.COAL5_COPPER_ORE0,
				Type.COAL5_CONCRETE0,
				Type.COAL5_JOULES0,
			]
		6: dialogue = "I always liked playing support."
		7: dialogue = "Why is this stuff purple?"


func COAL5_COPPER_ORE0():
	speaker = lv.get_lored(LORED.Type.COPPER_ORE)
	dialogue = "Well, shoot, there, boss, don't mind if I do!"


func COAL5_CONCRETE0():
	speaker = lv.get_lored(LORED.Type.CONCRETE)
	dialogue = "Gracias, amigo."


func COAL5_JOULES0():
	speaker = lv.get_lored(LORED.Type.JOULES)
	dialogue = "Thank you."



func RANDOM_STONE() -> void:
	speaker = lv.get_lored(LORED.Type.STONE)
	match randi() % 8:
		0: dialogue = "This one has a sweet edge!"
		1: dialogue = "Was that a hacky sack?"
		2:
			dialogue = "My bag is getting heavy! :("
			pose_texture = load("res://Sprites/reactions/STONE2.png")
		3: dialogue = "My back smarts.\n:("
		4: dialogue = "Hey, I found one you might like!"
		5: dialogue = "Gotta go fast!"
		6: dialogue = "I wonder how much this one is worth."
		7:
			dialogue = "I don't like it when Iron Ore shoots rocks."
			reply = Type.STONE7_IRON_ORE


func STONE7_IRON_ORE():
	speaker = lv.get_lored(LORED.Type.IRON_ORE)
	dialogue = "You rather I shoot you?"
	pose_texture = load("res://Sprites/reactions/IRON_ORE_REPLY0.png")



func RANDOM_IRON_ORE() -> void:
	speaker = lv.get_lored(LORED.Type.IRON_ORE)
	match randi() % 11:
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
			reply = Type.IRON_ORE8_STONE_REPLY0
		9:
			dialogue = "I learned something about myself the other day. I want literally everyone to die."
			reply = Type.IRON_ORE9_JOULES0
		10:
			pose_texture = load("res://Sprites/reactions/IRON_ORE10.png")


func IRON_ORE8_STONE_REPLY0():
	speaker = lv.get_lored(LORED.Type.STONE)
	dialogue = "No, you creep!"


func IRON_ORE9_JOULES0():
	speaker = lv.get_lored(LORED.Type.JOULES)
	dialogue = "That's not even shocking, dude."



func RANDOM_COPPER_ORE() -> void:
	speaker = lv.get_lored(LORED.Type.COPPER_ORE)
	match randi() % 13:
		0: dialogue = "It's a working man I am!"
		1: dialogue = "I've been down underground."
		2: dialogue = "I swear to god if I ever see the sun,"
		3: dialogue = "or for any length of time, I can hold it in my mind,"
		4: dialogue = "I never again will go down underground!"
		5: dialogue = "At the age of sixteen years, I quarreled with my peers."
		6: dialogue = "I swear there will never be another one."
		7: dialogue = "In the dark recess of the mine, where you age before your time,"
		8: dialogue = "and the coal dust lies heavy on your lungs."
		9: dialogue = "At the age of sixty-four, if I live that long,"
		10: dialogue = "I'll greet you at the door and gently lead you by the arm."
		11: dialogue = "In the dark recess of the mine, I can take you back in time,"
		12: dialogue = "and tell you of the hardships that were there!"



func RANDOM_IRON() -> void:
	speaker = lv.get_lored(LORED.Type.IRON)
	match randi() % 8:
		0: dialogue = "Bread is good, but [b]toast[/b]... Toast is better."
		1:
			dialogue = "Thank you for working so hard, Stone!"
			reply = Type.IRON1_STONE0
		2:
			dialogue = "Iron Ore's methods may be extreme, but we need him nonetheless."
			possible_replies = [
				Type.IRON2_IRON_ORE0,
				Type.IRON2_STONE0,
			]
		3: dialogue = "I haven't cleaned this toaster since I bought it!"
		4:
			dialogue = "Can I borrow anyone's helmet?"
			reply = Type.IRON4_HARDWOOD0
		5: dialogue = "I shouldn't have left that one in for so long."
		6: dialogue = "At this point, I'm going to need more toasters."
		7: dialogue = "My arm is getting tired."


func IRON1_STONE0():
	speaker = lv.get_lored(LORED.Type.STONE)
	dialogue = "I couldn't do it without you, buddy!"


func IRON2_IRON_ORE0():
	speaker = lv.get_lored(LORED.Type.IRON_ORE)
	dialogue = "I can hear you, but I'm going to pretend like I can't."


func IRON4_HARDWOOD0():
	speaker = lv.get_lored(LORED.Type.HARDWOOD)
	dialogue = "Yes, but actually, no!"


func IRON2_STONE0():
	speaker = lv.get_lored(LORED.Type.STONE)
	dialogue = "Are you sure about that?"



func RANDOM_COPPER() -> void:
	speaker = lv.get_lored(LORED.Type.COPPER)
	match randi() % 8:
		0: dialogue = "This stuff's the bee's knees!"
		1: pose_texture = load("res://Sprites/reactions/COPPER1.png")
		2: dialogue = "Anyone want sm' more?"
		3: dialogue = "C'mon 'n rest ya dogs--try one of these bad bad boys!"
		4:
			dialogue = "Can I get some firewood?"
			reply = Type.COPPER4_WOOD0
		5: dialogue = "Stay awhile and listen to the fire."
		6: dialogue = "Mmm! Gith ith good!"
		7: dialogue = "Copper Ore, these puppies are amazing!"


func COPPER4_WOOD0():
	speaker = lv.get_lored(LORED.Type.WOOD)
	dialogue = "I got you, bro!"
	reply = Type.COPPER7_COPPER_ORE0


func COPPER7_COPPER_ORE0():
	speaker = lv.get_lored(LORED.Type.COPPER_ORE)
	dialogue = "Gee, thanks, pal! All in a hard day's work, see?"



func RANDOM_JOULES() -> void:
	speaker = lv.get_lored(LORED.Type.JOULES)
	match randi() % 8:
		0: dialogue = "It took me 12 years to be able to redirect lightning!"
		1: dialogue = "My batteries are shock-full!"
		2: dialogue = "Anyone's car need a jump-start?"
		3: dialogue = "I can offer you parts at a reduced price!"
		4:
			dialogue = "Thanks for the parts again, Coal. Same time, same place?"
			reply = Type.JOULES4_COAL0
		5: dialogue = "Cars! Cars! Cars! Cars! Cars! Cars! Cars!"
		6:
			dialogue = "Anyone need an oil change?"
			reply = Type.JOULES6_OIL0
		7: dialogue = "Have you heard about the new Mazda Corada Tesla Chevy Chevy Tahoe Master Blaster Zipper Street Crippler with an all-electric diesel 50,000 horse power V90 engine capable of 1 to 60 in 0.13 giggywiggynano seconds? They just announced it. It will hit the market in 2420, or even sooner! I already sent a downpayment on it, I know it will be the future of all cars."


func JOULES4_COAL0():
	speaker = lv.get_lored(LORED.Type.COAL)
	dialogue = "See you next week!"


func JOULES6_OIL0():
	speaker = lv.get_lored(LORED.Type.OIL)
	dialogue = "Blblblfsh!!"



func RANDOM_GROWTH() -> void:
	speaker = lv.get_lored(LORED.Type.GROWTH)
	match randi() % 10:
		0:
			dialogue = "I think Oil just made a boom-boom."
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


func GROWTH0_OIL0():
	speaker = lv.get_lored(LORED.Type.OIL)
	dialogue = "Hahahahaha!!"


func GROWTH3_TARBALLS0():
	speaker = lv.get_lored(LORED.Type.TARBALLS)
	dialogue = "Nope."


func GROWTH6_JOULES0():
	speaker = lv.get_lored(LORED.Type.JOULES)
	dialogue = "Someone say shock?"


func GROWTH9_IRON0():
	speaker = lv.get_lored(LORED.Type.IRON)
	dialogue = "I'd say you're pretty clever for it, buddy!"



func RANDOM_CONCRETE() -> void:
	speaker = lv.get_lored(LORED.Type.CONCRETE)
	match randi() % 8:
		0: dialogue = "Que?"
		1: dialogue = "Thank you, Primo!"
		2: dialogue = "Quítate, chingada!"
		3: dialogue = "Mi casa es su casa, hombre!"
		4: dialogue = "Que pasa, jefe?"
		5: dialogue = "No hablo Ingles. Can you translate?"
		6: dialogue = "What channel is the soccer game on?"
		7: dialogue = "Buenas noches, mi amor!"



func RANDOM_OIL() -> void:
	speaker = lv.get_lored(LORED.Type.OIL)
	match randi() % 11:
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
	speaker = lv.get_lored(LORED.Type.TARBALLS)
	match randi() % 9:
		0: dialogue = "I'm still working on the perfect mixture."
		1: dialogue = "That was good, but I can do better."
		2: dialogue = "I lost some important notes. I need to be more careful."
		3: dialogue = "I'm glad I'm able to work right now. I'm easily distracted."
		4: dialogue = "I only live so long. I need to get this right!"
		5:
			dialogue = "Thank you for your un-ending donations, Growth."
			reply = Type.TARBALLS5_GROWTH0
		6: dialogue = "I can't wait for the next chapter of One-Punch Man!"
		7: dialogue = "I'd like to see you wiggle, wiggle, for sure."
		8: dialogue = "This makes me want to dribble, dribble."


func TARBALLS5_GROWTH0():
	speaker = lv.get_lored(LORED.Type.GROWTH)
	dialogue = "I'm not donating it! How are you getting it??"



func RANDOM_MALIGNANCY() -> void:
	speaker = lv.get_lored(LORED.Type.MALIGNANCY)
	match randi() % 14:
		0: dialogue = "Hiya. I just coalesced out of sticky, oily stuff and cancer juice. How's your day going?"
		1: dialogue = "Hi. Oh, wow, there are a lot of me."
		2: dialogue = "Whoa, hello! I'm Malignancy... Oh, so are all of you?"
		3: dialogue = "OH GOd--oh, hello."
		4: dialogue = "Oh, hi! Nice to meet y'all!"
		5: dialogue = "Wow! So THAT's what being born is like!"
		6: dialogue = "Literally 1 second ago I did not exist. Isn't that weird to think about?"
		7: dialogue = "Oop--hi! I'm Malignancy. Nice to meet you."
		8: dialogue = "Hello!"
		9: dialogue = "Hi!"
		10: dialogue = "Hey!"
		11: dialogue = "What's up?"
		12: dialogue = "Hi, guys!"
		13: dialogue = "Hey, I guess."



func RANDOM_WATER() -> void:
	speaker = lv.get_lored(LORED.Type.WATER)
	match randi() % 10:
		0: dialogue = "Ew, there's bugs in the water!"
		1: pose_texture = load("res://Sprites/reactions/WATER1.png")
		2: pose_texture = load("res://Sprites/reactions/WATER2.png")
		3: dialogue = "I bet I have a sunburn."
		4: dialogue = "Oh, no! I'm cramping!"
		5: dialogue = "I don't need it. I definitely don't need it."
		6:
			dialogue = "Does anyone want to play with me?"
			possible_replies = [
				Type.WATER6_TREES0,
				Type.WATER6_DRAW_PLATE0,
			]
		7: dialogue = "My ears are clogged with water!"
		8: dialogue = "I wish I had a noodle!"
		9: pose_texture = load("res://Sprites/reactions/WATER9.png")


func WATER6_TREES0():
	speaker = lv.get_lored(LORED.Type.TREES)
	dialogue = "I do!"


func WATER6_DRAW_PLATE0():
	speaker = lv.get_lored(LORED.Type.DRAW_PLATE)
	dialogue = "Me!!!!"



func RANDOM_HUMUS() -> void:
	speaker = lv.get_lored(LORED.Type.HUMUS)
	match randi() % 9:
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
		8: dialogue = "*Browsing http://localmares.com.* Wait--no! I meant--UH--I meant to search local [b]wares!!"


func HUMUS7_GALENA0():
	speaker = lv.get_lored(LORED.Type.GALENA)
	dialogue = "No problem, boss! I'll fix yer up straight away!"



func RANDOM_SEEDS() -> void:
	speaker = lv.get_lored(LORED.Type.SEEDS)
	match randi() % 9:
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
	speaker = lv.get_lored(LORED.Type.TREES)
	match randi() % 9:
		0:
			dialogue = "Have you ever been through as much crap as I have?"
			possible_replies = [
				Type.TREES0_GROWTH0,
				Type.TREES0_SOIL0,
			]
		1: dialogue = "They call me Green Face!"
		2:
			dialogue = "Thanks for the water, friend!"
			reply = Type.TREES2_WATER0
		3: dialogue = "Acrobatics level up!"
		4: dialogue = "I want to try rock climbing one day!"
		5: dialogue = "Want to see me do a cool trick? Watch!"
		6: dialogue = "These sprouts blasting me have given me rock-hard abs!"
		7: dialogue = "These volatile seeds won't leaf me alone!"
		8:
			dialogue = "Maybe, these seeds are poppin'!"
			reply = Type.TREES8_SEEDS0


func TREES0_GROWTH0():
	speaker = lv.get_lored(LORED.Type.GROWTH)
	dialogue = "Are you freakin joking me, Trees?"


func TREES0_SOIL0():
	speaker = lv.get_lored(LORED.Type.SOIL)
	dialogue = "Um, hello??"


func TREES2_WATER0():
	speaker = lv.get_lored(LORED.Type.WATER)
	dialogue = "It has chlorine in it!"
	reply = Type.TREES2_TREES0


func TREES2_TREES0():
	speaker = lv.get_lored(LORED.Type.TREES)
	dialogue = "Come again?"
	pose_texture = load("res://Sprites/reactions/TREES2_TREES0.png")


func TREES8_SEEDS0():
	speaker = lv.get_lored(LORED.Type.SEEDS)
	dialogue = "Too bad I'm not the Corn LORED!"



func RANDOM_SOIL() -> void:
	speaker = lv.get_lored(LORED.Type.SOIL)
	match randi() % 8:
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
	speaker = lv.get_lored(LORED.Type.HUMUS)
	dialogue = "Hah, poor guy! Every time he turns around, I add to his pile."



func RANDOM_DRAW_PLATE() -> void:
	speaker = lv.get_lored(LORED.Type.DRAW_PLATE)
	match randi() % 11:
		0: dialogue = "Next, I'm going to draw a castle!"
		1: dialogue = "Who is your favorite superhero?"
		2: dialogue = "I wish I could have pizza for dinner every night!"
		3: dialogue = "My favorite color is orange. What about you?"
		4: dialogue = "Can we go to the park later?"
		5: dialogue = "My favorite animal is a panda."
		6: dialogue = "I don't want to go to bed early tonight."
		7:
			dialogue = "Can I have some ice cream?"
			reply = Type.DRAW_PLATE7_WIRE0
		8: dialogue = "Can I have some ice cream after I finish my drawing?"
		9: dialogue = "I don't like doing homework!"
		10: dialogue = "Have you ever been to the park? What's your favorite part about the park?"


func DRAW_PLATE7_WIRE0() -> void:
	speaker = lv.get_lored(LORED.Type.WIRE)
	dialogue = "No, honey."
	reply = Type.DRAW_PLATE7_DRAW_PLATE0


func DRAW_PLATE7_DRAW_PLATE0() -> void:
	speaker = lv.get_lored(LORED.Type.DRAW_PLATE)
	dialogue = "What about after I finish my drawing?"
	reply = Type.DRAW_PLATE7_WIRE1


func DRAW_PLATE7_WIRE1() -> void:
	speaker = lv.get_lored(LORED.Type.WIRE)
	dialogue = "We'll see."



# - Get

func has_dialogue() -> bool:
	return dialogue != ""


func has_reply() -> bool:
	return reply != -1
