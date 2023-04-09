extends MarginContainer



var type: int
var speaker: int
var random := false
var posing := false
var hasURL := false
var mouseIn := false
var duration := 0.0
var reply: Array
var dialogue: String



func _ready():
	get_node("%label").connect("meta_clicked", self, "metaClicked")


func setup(_type: int):
	
	type = _type
	
	call(EmoteManager.Type.keys()[type])
	
	get_node("%bg").modulate = lv.lored[speaker].color
	get_node("%info").modulate = lv.lored[speaker].color
	
	
	hasURL = "[url]" in dialogue
	
	get_node("%info").hide()
	if duration == -1:
		get_node("%progress").hide()
	
	
	if posing:
		get_node("%pose").show()
		get_node("%sprite").modulate = lv.lored[speaker].color
		#get_node("%sprite").texture = gv.sprite[EmoteManager.Type.keys()[type]]
		get_node("%sprite").texture = load("res://Sprites/reactions/" + EmoteManager.Type.keys()[type] + ".png")
		get_node("%sprite/shadow").texture = get_node("%sprite").texture
	
	var textLength = dialogue.length()
	duration = automateDuration(textLength)
	automateSize(textLength)
	
	get_node("%progress").value = 0
	get_node("%progress/shadow").value = 0
	
	if dialogue == "":
		get_node("%ScrollContainer").hide()
	else:
		get_node("%label").bbcode_text = "[center]" + dialogue

func automateDuration(textLength: int) -> float:
	return duration if duration != 0.0 else 5.0 + (float(textLength) / 25) + (3 if posing else 0)
func automateSize(textLength: int):
	get_node("%label").rect_min_size.x = min(180, max(50 + textLength * 2, rect_min_size.x))
	rect_min_size.y = stepify(max(32, min(48, textLength * 2)), 16) + 20
func pose():
	posing = true



func TEST():
	speaker = lv.Type.COAL
	dialogue = "Once upon a time, there was a little baby boy who was a stinky. But then, he did something insane! He freaked out! Like, wow. Isn't that crazy? I think so, anyway. Yep! Signing off!"

func STONE_HAPPY():
	speaker = lv.Type.STONE
	dialogue = "I'm so glad to have Coal back again."
	reply.append(EmoteManager.Type.COAL_REPLY_STONE_HAPPY)
func COAL_REPLY_STONE_HAPPY():
	speaker = lv.Type.COAL
	dialogue = "Thank you!"
	reply.append(EmoteManager.Type.STONE_REPLY_COAL_REPLY_STONE_HAPPY)
func STONE_REPLY_COAL_REPLY_STONE_HAPPY():
	speaker = lv.Type.STONE
	dialogue = "No, thank you!"
	posing = true
	reply.append(EmoteManager.Type.COAL_REPLY_STONE_COAL_STONE_HAPPY)
func COAL_REPLY_STONE_COAL_STONE_HAPPY():
	speaker = lv.Type.COAL
	posing = true

func COAL_WHOA():
	speaker = lv.Type.COAL
	dialogue = "Whoa!"
func COAL_GREET():
	speaker = lv.Type.COAL
	dialogue = "Hello!"


# random emotes

func COAL0():
	speaker = lv.Type.COAL
	dialogue = "Dig, dig!"
func COAL1():
	speaker = lv.Type.COAL
	dialogue = "Glad to help!"
func COAL2():
	speaker = lv.Type.COAL
	dialogue = "Is this lump yours?\nJust kidding!"
func COAL3():
	speaker = lv.Type.COAL
	dialogue = "I hope my posture is good."
func COAL4():
	speaker = lv.Type.COAL
	dialogue = "I sure am grateful for this shovel."
func COAL5():
	speaker = lv.Type.COAL
	dialogue = "If you didn't get enough, go ahead and take some more!"
	var possibleReplies = [
		EmoteManager.Type.JOULES_REPLY0,
		EmoteManager.Type.COPPER_ORE_REPLY0,
		EmoteManager.Type.CONCRETE_REPLY0,
	]
	reply.append(possibleReplies[randi() % possibleReplies.size()])
func COPPER_ORE_REPLY0():
	speaker = lv.Type.COPPER_ORE
	dialogue = "Well, shoot, there, boss, don't mind if I do!"
func CONCRETE_REPLY0():
	speaker = lv.Type.CONCRETE
	dialogue = "Gracias, amigo."
func JOULES_REPLY0():
	speaker = lv.Type.JOULES
	dialogue = "Thank you."
func COAL6():
	speaker = lv.Type.COAL
	dialogue = "I always liked playing support."
func COAL7():
	speaker = lv.Type.COAL
	dialogue = "Why is this stuff purple?"

func STONE0():
	speaker = lv.Type.STONE
	dialogue = "This one has a sweet edge!"
func STONE1():
	speaker = lv.Type.STONE
	dialogue = "Was that a hacky sack?"
func STONE2():
	speaker = lv.Type.STONE
	dialogue = "My bag is getting heavy! :("
	posing = true
func STONE3():
	speaker = lv.Type.STONE
	dialogue = "My back smarts. :("
func STONE4():
	speaker = lv.Type.STONE
	dialogue = "Hey, I found one you might like!"
func STONE5():
	speaker = lv.Type.STONE
	dialogue = "Gotta go fast!"
func STONE6():
	speaker = lv.Type.STONE
	dialogue = "I wonder how much this one is worth."
func STONE7():
	speaker = lv.Type.STONE
	dialogue = "I don't like it when Iron Ore shoots rocks."
	reply.append(EmoteManager.Type.IRON_ORE_REPLY0)
func IRON_ORE_REPLY0():
	speaker = lv.Type.IRON_ORE
	dialogue = "You rather I shoot you?"
	posing = true

func IRON_ORE0():
	speaker = lv.Type.IRON_ORE
	dialogue = "DIE!"
func IRON_ORE1():
	speaker = lv.Type.IRON_ORE
	dialogue = "KILL!"
func IRON_ORE2():
	speaker = lv.Type.IRON_ORE
	dialogue = "GAH!"
func IRON_ORE3():
	speaker = lv.Type.IRON_ORE
	dialogue = "BAH!"
func IRON_ORE4():
	speaker = lv.Type.IRON_ORE
	dialogue = "This is what you GET!"
func IRON_ORE5():
	speaker = lv.Type.IRON_ORE
	dialogue = "RAHHugH!"
func IRON_ORE6():
	speaker = lv.Type.IRON_ORE
	dialogue = "MMUHRRaahhHRcK!"
func IRON_ORE7():
	speaker = lv.Type.IRON_ORE
	dialogue = "Would you please die? Thank you."
func IRON_ORE8():
	speaker = lv.Type.IRON_ORE
	dialogue = "Can someone pass me some more shells?"
func IRON_ORE8_STONE_REPLY0():
	speaker = lv.Type.STONE
	dialogue = "No, you creep!"
func IRON_ORE9():
	speaker = lv.Type.IRON_ORE
	dialogue = "I learned something about myself the other day. I want literally everyone to die."
func IRON_ORE9_JOULES0():
	speaker = lv.Type.JOULES
	dialogue = "That's not even shocking, dude."
func IRON_ORE10():
	speaker = lv.Type.IRON_ORE
	pose()

func COPPER_ORE0():
	speaker = lv.Type.COPPER_ORE
	dialogue = "It's a working man I am!"
func COPPER_ORE1():
	speaker = lv.Type.COPPER_ORE
	dialogue = "I've been down underground."
func COPPER_ORE2():
	speaker = lv.Type.COPPER_ORE
	dialogue = "I swear to god if I ever see the sun,"
func COPPER_ORE3():
	speaker = lv.Type.COPPER_ORE
	dialogue = "or for any length of time, I can hold it in my mind,"
func COPPER_ORE4():
	speaker = lv.Type.COPPER_ORE
	dialogue = "I never again will go down underground!"
func COPPER_ORE5():
	speaker = lv.Type.COPPER_ORE
	dialogue = "At the age of sixteen years, I quarreled with my peers."
func COPPER_ORE6():
	speaker = lv.Type.COPPER_ORE
	dialogue = "I swear there will never be another one."
func COPPER_ORE7():
	speaker = lv.Type.COPPER_ORE
	dialogue = "In the dark recess of the mine, where you age before your time,"
func COPPER_ORE8():
	speaker = lv.Type.COPPER_ORE
	dialogue = "and the coal dust lies heavy on your lungs."
func COPPER_ORE9():
	speaker = lv.Type.COPPER_ORE
	dialogue = "At the age of sixty-four, if I live that long,"
func COPPER_ORE10():
	speaker = lv.Type.COPPER_ORE
	dialogue = "I'll greet you at the door and gently lead you by the arm."
func COPPER_ORE11():
	speaker = lv.Type.COPPER_ORE
	dialogue = "In the dark recess of the mine, I can take you back in time,"
func COPPER_ORE12():
	speaker = lv.Type.COPPER_ORE
	dialogue = "and tell you of the hardships that were there!"

func COPPER0():
	speaker = lv.Type.COPPER
	dialogue = "This stuff's the bee's knees!"
func COPPER1():
	speaker = lv.Type.COPPER
	pose()
func COPPER2():
	speaker = lv.Type.COPPER
	dialogue = "Anyone want sm' more?"
func COPPER3():
	speaker = lv.Type.COPPER
	dialogue = "C'mon 'n rest ya dogs--try one of these bad bad boys!"
func COPPER4():
	speaker = lv.Type.COPPER
	dialogue = "Can I get some firewood?"
	reply.append(EmoteManager.Type.COPPER4_WOOD0)
func COPPER4_WOOD0():
	speaker = lv.Type.WOOD
	dialogue = "I got you, bro!"
func COPPER5():
	speaker = lv.Type.COPPER
	dialogue = "Stay awhile and listen to the fire."
func COPPER6():
	speaker = lv.Type.COPPER
	dialogue = "Mmm! Gith ith good!"
func COPPER7():
	speaker = lv.Type.COPPER
	dialogue = "Copper Ore, these puppies are amazing!"
	reply.append(EmoteManager.Type.COPPER7_COPPER_ORE0)
func COPPER7_COPPER_ORE0():
	speaker = lv.Type.COPPER_ORE
	dialogue = "Gee, thanks, pal! All in a hard day's work, see?"

func IRON0():
	speaker = lv.Type.IRON
	dialogue = "Bread is good, but toast... Toast is better."
func IRON1():
	speaker = lv.Type.IRON
	dialogue = "Thank you for working so hard, Stone!"
	reply.append(EmoteManager.Type.IRON1_STONE0)
func IRON1_STONE0():
	speaker = lv.Type.STONE
	dialogue = "I couldn't do it without you, buddy!"
func IRON2():
	speaker = lv.Type.IRON
	dialogue = "Iron Ore's methods may be extreme, but we need him nonetheless."
	reply.append(EmoteManager.Type.IRON2_IRON_ORE0)
func IRON2_IRON_ORE0():
	speaker = lv.Type.IRON_ORE
	dialogue = "I can hear you, but I'm going to pretend like I can't."
func IRON4():
	speaker = lv.Type.IRON
	dialogue = "Can I borrow anyone's helmet?"
	reply.append(EmoteManager.Type.IRON4_HARDWOOD0)
func IRON4_HARDWOOD0():
	speaker = lv.Type.HARDWOOD
	dialogue = "Yes, but actually, no!"
func IRON5():
	speaker = lv.Type.IRON
	dialogue = "I shouldn't have left that one in for so long."
func IRON6():
	speaker = lv.Type.IRON
	dialogue = "At this point, I'm going to need more toasters."
func IRON7():
	speaker = lv.Type.IRON
	dialogue = "My arm is getting tired."

func JOULES0():
	speaker = lv.Type.JOULES
	dialogue = "It took me 12 years to be able to redirect lightning!"
func JOULES1():
	speaker = lv.Type.JOULES
	dialogue = "My batteries are shock-full!"
func JOULES2():
	speaker = lv.Type.JOULES
	dialogue = "Anyone's car need a jump-start?"
func JOULES3():
	speaker = lv.Type.JOULES
	dialogue = "I can offer you parts at a reduced price!"
func JOULES4():
	speaker = lv.Type.JOULES
	dialogue = "Thanks for the parts again, Coal. Same time, same place?"
	reply.append(EmoteManager.Type.JOULES4_COAL0)
func JOULES4_COAL0():
	speaker = lv.Type.COAL
	dialogue = "See you next week!"
func JOULES5():
	speaker = lv.Type.JOULES
	dialogue = "Cars! Cars! Cars! Cars! Cars! Cars! Cars!"
func JOULES6():
	speaker = lv.Type.JOULES
	dialogue = "Anyone need an oil change?"
	reply.append(EmoteManager.Type.JOULES6_OIL0)
func JOULES6_OIL0():
	speaker = lv.Type.OIL
	dialogue = "Blblblfsh!!"
func JOULES7():
	speaker = lv.Type.JOULES
	dialogue = "Have you heard about the new Mazda Corada Tesla Chevy Chevy Tahoe Master Blaster Zipper Street Crippler with an all-electric diesel 50,000 horse power V90 engine capable of 1 to 60 in 0.13 giggywiggynano seconds? They just announced it. It will hit the market in 2420, or even sooner! I already sent a downpayment on it, I know it will be the future of all cars."

func GROWTH0():
	speaker = lv.Type.GROWTH
	dialogue = "I think Oil just made a boom-boom."
	reply.append(EmoteManager.Type.GROWTH0_OIL0)
func GROWTH0_OIL0():
	speaker = lv.Type.OIL
	dialogue = "Hahahahaha!!"
func GROWTH1():
	speaker = lv.Type.GROWTH
	dialogue = "Oh, your grandma got cancer three times? Must be nice."
func GROWTH2():
	speaker = lv.Type.GROWTH
	dialogue = "Oh, your grandma got cancer three times? Must be nice."
func GROWTH3():
	speaker = lv.Type.GROWTH
	dialogue = "Does such a thing as a chemotherapy water bed exist?"
	reply.append(EmoteManager.Type.GROWTH3_TARBALLS0)
func GROWTH3_TARBALLS0():
	speaker = lv.Type.TARBALLS
	dialogue = "Nope."
func GROWTH4():
	speaker = lv.Type.GROWTH
	dialogue = "Call 9-1-1."
func GROWTH5():
	speaker = lv.Type.GROWTH
	dialogue = "Send help."
func GROWTH6():
	speaker = lv.Type.GROWTH
	dialogue = "The amount of water I need daily would shock anyone."
	reply.append(EmoteManager.Type.GROWTH6_JOULES0)
func GROWTH6_JOULES0():
	speaker = lv.Type.JOULES
	dialogue = "Someone say shock?"
func GROWTH7():
	speaker = lv.Type.GROWTH
	dialogue = "I had to go bald, I couldn't take the constant re-grooming."
func GROWTH8():
	speaker = lv.Type.GROWTH
	dialogue = "But, in a way, this is satisfying!"
func GROWTH9():
	speaker = lv.Type.GROWTH
	dialogue = "Whatever you do, just don't ask me how I make growth out of iron and copper."
	reply.append(EmoteManager.Type.GROWTH9_IRON0)
func GROWTH9_IRON0():
	speaker = lv.Type.IRON
	dialogue = "I'd say you're pretty clever for it, buddy!"

func CONCRETE0():
	speaker = lv.Type.CONCRETE
	dialogue = "Que?"
func CONCRETE1():
	speaker = lv.Type.CONCRETE
	dialogue = "Thank you, Primo!"
func CONCRETE2():
	speaker = lv.Type.CONCRETE
	dialogue = "Quítate, chingada!"
func CONCRETE3():
	speaker = lv.Type.CONCRETE
	dialogue = "Mi casa es su casa, hombre!"
func CONCRETE4():
	speaker = lv.Type.CONCRETE
	dialogue = "Que pasa, jefe?"
func CONCRETE5():
	speaker = lv.Type.CONCRETE
	dialogue = "No hablo Ingles. Can you translate?"
func CONCRETE6():
	speaker = lv.Type.CONCRETE
	dialogue = "What channel is the soccer game on?"
func CONCRETE7():
	speaker = lv.Type.CONCRETE
	dialogue = "Buenas noches, mi amor!"

func OIL0():
	speaker = lv.Type.OIL
	dialogue = "But I just a baby!"
func OIL1():
	speaker = lv.Type.OIL
	dialogue = "Plbdffffffffshh!"
func OIL2():
	speaker = lv.Type.OIL
	dialogue = "Pow! Pow pow! Pow pow pow pow pow!"
func OIL3():
	speaker = lv.Type.OIL
	dialogue = "AHHHHHHH!"
func OIL4():
	speaker = lv.Type.OIL
	dialogue = "Waaaahhhhh!!!"
func OIL5():
	speaker = lv.Type.OIL
	pose()
func OIL6():
	speaker = lv.Type.OIL
	dialogue = "*Pooped a little.*"
func OIL7():
	speaker = lv.Type.OIL
	pose()
func OIL8():
	speaker = lv.Type.OIL
	dialogue = "Slurp!!!"
func OIL9():
	speaker = lv.Type.OIL
	dialogue = "Dada?"
func OIL10():
	speaker = lv.Type.OIL
	dialogue = "Mama?"

func TARBALLS0():
	speaker = lv.Type.TARBALLS
	dialogue = "I'm still working on the perfect mixture."
func TARBALLS1():
	speaker = lv.Type.TARBALLS
	dialogue = "That was good, but I can do better."
func TARBALLS2():
	speaker = lv.Type.TARBALLS
	dialogue = "I lost some important notes. I need to be more careful."
func TARBALLS3():
	speaker = lv.Type.TARBALLS
	dialogue = "I'm glad I'm able to work right now. I'm easily distracted."
func TARBALLS4():
	speaker = lv.Type.TARBALLS
	dialogue = "I only live so long. I need to get this right!"
func TARBALLS5():
	speaker = lv.Type.TARBALLS
	dialogue = "Thank you for your un-ending donations, Growth."
	reply.append(EmoteManager.Type.TARBALLS5_GROWTH0)
func TARBALLS5_GROWTH0():
	speaker = lv.Type.GROWTH
	dialogue = "I'm not donating it! How are you getting it??"
func TARBALLS6():
	speaker = lv.Type.TARBALLS
	dialogue = "I can't wait for the next chapter of One-Punch Man!"
func TARBALLS7():
	speaker = lv.Type.TARBALLS
	dialogue = "I'd like to see you wiggle, wiggle, for sure."
func TARBALLS8():
	speaker = lv.Type.TARBALLS
	dialogue = "This makes me want to dribble, dribble."

func MALIGNANCY0():
	speaker = lv.Type.MALIGNANCY
	dialogue = "Hiya. I just coalesced out of sticky, oily stuff and cancer juice. How's your day going?"
func MALIGNANCY1():
	speaker = lv.Type.MALIGNANCY
	dialogue = "Hi. Oh, wow, there are a lot of me."
func MALIGNANCY2():
	speaker = lv.Type.MALIGNANCY
	dialogue = "Whoa, hello! I'm Malignancy... Oh, so are all of you?"
func MALIGNANCY3():
	speaker = lv.Type.MALIGNANCY
	dialogue = "OH GOd--oh, hello."
func MALIGNANCY4():
	speaker = lv.Type.MALIGNANCY
	dialogue = "Oh, hi! Nice to meet y'all!"
func MALIGNANCY5():
	speaker = lv.Type.MALIGNANCY
	dialogue = "Wow! So THAT's what being born is like!"
func MALIGNANCY6():
	speaker = lv.Type.MALIGNANCY
	dialogue = "Literally 1 second ago I did not exist. Isn't that weird to think about?"
func MALIGNANCY7():
	speaker = lv.Type.MALIGNANCY
	dialogue = "Oop--hi! I'm Malignancy. Nice to meet you."
func MALIGNANCY8():
	speaker = lv.Type.MALIGNANCY
	dialogue = "Hello!"
func MALIGNANCY9():
	speaker = lv.Type.MALIGNANCY
	dialogue = "Hi!"
func MALIGNANCY10():
	speaker = lv.Type.MALIGNANCY
	dialogue = "Hey!"
func MALIGNANCY11():
	speaker = lv.Type.MALIGNANCY
	dialogue = "What's up?"
func MALIGNANCY12():
	speaker = lv.Type.MALIGNANCY
	dialogue = "Hi, guys!"
func MALIGNANCY13():
	speaker = lv.Type.MALIGNANCY
	dialogue = "Hey, I guess."

func WATER0():
	speaker = lv.Type.WATER
	dialogue = "Ew, there's bugs in the water!"
func WATER1():
	speaker = lv.Type.WATER
	pose()
func WATER2():
	speaker = lv.Type.WATER
	pose()
func WATER3():
	speaker = lv.Type.WATER
	dialogue = "I bet I have a sunburn."
func WATER4():
	speaker = lv.Type.WATER
	dialogue = "Oh, no! I'm cramping!"
func WATER5():
	speaker = lv.Type.WATER
	dialogue = "I don't need it. I definitely don't need it."
func WATER6():
	speaker = lv.Type.WATER
	dialogue = "Does anyone want to play with me?"
	reply.append(EmoteManager.Type.WATER6_TREES0)
func WATER6_TREES0():
	speaker = lv.Type.TREES
	dialogue = "I do!"
func WATER7():
	speaker = lv.Type.WATER
	dialogue = "My ears are clogged with water!"
func WATER8():
	speaker = lv.Type.WATER
	dialogue = "I wish I had a noodle!"
func WATER9():
	speaker = lv.Type.WATER
	pose()

func HUMUS0():
	speaker = lv.Type.HUMUS
	dialogue = "Heigh, give me an apple, I'm a freakin horse."
func HUMUS1():
	speaker = lv.Type.HUMUS
	dialogue = "First I champ, then I stamp, then I stand still!"
func HUMUS2():
	speaker = lv.Type.HUMUS
	dialogue = "Y'all are doing WHAT with my poop?!"
func HUMUS3():
	speaker = lv.Type.HUMUS
	pose()
func HUMUS4():
	speaker = lv.Type.HUMUS
	dialogue = "No, don't put that saddle on me--I cannot be tamed!"
func HUMUS5():
	speaker = lv.Type.HUMUS
	dialogue = "I am a beautiful stallion!"
func HUMUS6():
	speaker = lv.Type.HUMUS
	dialogue = "Winnie... the Pooh!"
func HUMUS7():
	speaker = lv.Type.HUMUS
	dialogue = "Somebody, please trim my damn hooves before I keel over."
	reply.append(EmoteManager.Type.HUMUS7_GALENA0)
func HUMUS7_GALENA0():
	speaker = lv.Type.GALENA
	dialogue = "No problem, boss! I'll fix yer up straight away!"
func HUMUS8():
	speaker = lv.Type.HUMUS
	dialogue = "*Browsing http://localmares.com.* Wait--no! I meant--UH--I meant to search local [i]wares[/i]!!"

func SEEDS0():
	speaker = lv.Type.SEEDS
	dialogue = "Buzz, buzz!"
func SEEDS1():
	speaker = lv.Type.SEEDS
	dialogue = "Honey is good."
func SEEDS2():
	speaker = lv.Type.SEEDS
	dialogue = "Don't comb your hair, it'll get sticky!!!"
func SEEDS3():
	speaker = lv.Type.SEEDS
	dialogue = "Don't mind me, I wouldn't sting a fly."
func SEEDS4():
	speaker = lv.Type.SEEDS
	dialogue = "Guess what kind of gum I chew! ... Bumble gum!"
func SEEDS5():
	speaker = lv.Type.SEEDS
	dialogue = "Oh, sorry, am I droning on?"
func SEEDS6():
	speaker = lv.Type.SEEDS
	dialogue = "Later today, I'm going to the barber for a buzz cut!"
func SEEDS7():
	speaker = lv.Type.SEEDS
	dialogue = "If it's raining, I never forget my yellow jacket!"
func SEEDS8():
	speaker = lv.Type.SEEDS
	dialogue = "My birthday is in May, that's where I got my name from!"

func TREES0():
	speaker = lv.Type.TREES
	dialogue = "Have you ever been through as much crap as I have?"
	var possibleReplies = [
		EmoteManager.Type.TREES0_GROWTH0,
		EmoteManager.Type.TREES0_SOIL0,
	]
	reply.append(possibleReplies[randi() % possibleReplies.size()])
func TREES0_GROWTH0():
	speaker = lv.Type.GROWTH
	dialogue = "Are you freakin joking me, Trees?"
func TREES0_SOIL0():
	speaker = lv.Type.SOIL
	dialogue = "Um, hello??"
func TREES1():
	speaker = lv.Type.TREES
	dialogue = "They call me Green Face!"
func TREES2():
	speaker = lv.Type.TREES
	dialogue = "Thanks for the water, friend!"
	reply.append(EmoteManager.Type.TREES2_WATER0)
func TREES2_WATER0():
	speaker = lv.Type.WATER
	dialogue = "It has chlorine in it!"
	reply.append(EmoteManager.Type.TREES2_TREES0)
func TREES2_TREES0():
	speaker = lv.Type.TREES
	dialogue = "Come again?"
	pose()
func TREES3():
	speaker = lv.Type.TREES
	dialogue = "Acrobatics level up!"
func TREES4():
	speaker = lv.Type.TREES
	dialogue = "I want to try rock climbing one day!"
func TREES5():
	speaker = lv.Type.TREES
	dialogue = "Want to see me do a cool trick? Watch!"
func TREES6():
	speaker = lv.Type.TREES
	dialogue = "These sprouts blasting me have given me rock-hard abs!"
func TREES7():
	speaker = lv.Type.TREES
	dialogue = "These volatile seeds won't leaf me alone!"
func TREES8():
	speaker = lv.Type.TREES
	dialogue = "Maybe, these seeds are poppin'!"
	reply.append(EmoteManager.Type.TREES8_SEEDS0)
func TREES8_SEEDS0():
	speaker = lv.Type.SEEDS
	dialogue = "Too bad I'm not the Corn LORED!"

func SOIL0():
	speaker = lv.Type.SOIL
	dialogue = "Gosh, what a sticky situation."
func SOIL1():
	speaker = lv.Type.SOIL
	dialogue = "This stinks."
func SOIL2():
	speaker = lv.Type.SOIL
	dialogue = "Wee!"
func SOIL3():
	speaker = lv.Type.SOIL
	dialogue = "What are gloves?"
func SOIL4():
	speaker = lv.Type.SOIL
	dialogue = "Do you think there is a Candle LORED?"
func SOIL5():
	speaker = lv.Type.SOIL
	dialogue = "I only have this one poo pile remaining. Then I'll be done for good!"
	reply.append(EmoteManager.Type.SOIL5_HUMUS0)
func SOIL5_HUMUS0():
	speaker = lv.Type.HUMUS
	dialogue = "Hah, poor guy! Every time he turns around, I add to his pile."
func SOIL6():
	speaker = lv.Type.SOIL
	dialogue = "Even though I'm pretty good at programming, I ended up working in the poopy industry!"
func SOIL7():
	speaker = lv.Type.SOIL
	dialogue = "I wish I were at home in a hot bath with fresh coffee and cookies, and a whole lot of soap."

func DRAW_PLATE0():
	speaker = lv.Type.DRAW_PLATE
	dialogue = "Next, I'm going to draw a castle!"
func DRAW_PLATE1():
	speaker = lv.Type.DRAW_PLATE
	dialogue = "Who is your favorite superhero?"
func DRAW_PLATE2():
	speaker = lv.Type.DRAW_PLATE
	dialogue = "I wish I could have pizza for dinner every night!"
func DRAW_PLATE3():
	speaker = lv.Type.DRAW_PLATE
	dialogue = "My favorite color is orange. What about you?"
func DRAW_PLATE4():
	speaker = lv.Type.DRAW_PLATE
	dialogue = "Can we go to the park later?"
func DRAW_PLATE5():
	speaker = lv.Type.DRAW_PLATE
	dialogue = "My favorite animal is a panda."
func DRAW_PLATE6():
	speaker = lv.Type.DRAW_PLATE
	dialogue = "I don't want to go to bed early tonight."
func DRAW_PLATE7():
	speaker = lv.Type.DRAW_PLATE
	dialogue = "Can I have some ice cream?"
func DRAW_PLATE8():
	speaker = lv.Type.DRAW_PLATE
	dialogue = "Can I have some ice cream after I finish my drawing?"
func DRAW_PLATE9():
	speaker = lv.Type.DRAW_PLATE
	dialogue = "I don't like doing homework!"
func DRAW_PLATE10():
	speaker = lv.Type.DRAW_PLATE
	dialogue = "Have you ever been to the park? What's your favorite part about the park?"



# - Signals

func _exit_tree() -> void:
	EmoteManager.emoteFreed(type, speaker)
func metaClicked(meta):
	call("meta_" + EmoteManager.Type.keys()[type], meta)
	queue_free()

func _on_m_mouse_entered() -> void:
	mouseIn = true
	#modulate = Color(1,1,1,0.1)
	#return
	if not hasURL:
		get_node("%info").show()
func _on_m_mouse_exited() -> void:
	mouseIn = false
	#modulate = Color(1,1,1,1)

func _on_Button_pressed() -> void:
	queue_free()
func _on_Button_mouse_entered() -> void:
	mouseIn = true

func _on_progress_value_changed(value: float) -> void:
	get_node("%progress/shadow").value = value




# - Cool shit

func go():
	displayText()
	hideTimer()

func displayText():
	
	var label = get_node("%label")
	label.visible_characters = 0
	var t := Timer.new()
	add_child(t)
	
	if dialogue == "":
		t.start(5)
		yield(t, "timeout")
	else:
		while not is_queued_for_deletion():
			
			label.visible_characters += 1
			if label.percent_visible == 1:
				break
			
			if label.text[label.visible_characters - 1] in ["!", ",", ".", "?"]:
				t.start(0.25)
			else:
				t.start(0.04)
			
			yield(t, "timeout")
		
		t.start(1.5)
		yield(t, "timeout")
	
	allDialogueDisplayed()
	t.queue_free()

func hideTimer():
	
	if duration == -1.0:
		# does not go away automatically
		return
	
	var t := Timer.new()
	add_child(t)
	
	var startingTime = OS.get_unix_time()
	
	while not is_queued_for_deletion():
		
		t.start(1)
		yield(t, "timeout")
		
		if mouseIn:
			startingTime += 1
			continue
		
		var timePassed = OS.get_unix_time() - startingTime
		
		get_node("%progress").value = (timePassed / duration) * 100
		
		if timePassed >= duration:
			queue_free()
	
	t.queue_free()


func allDialogueDisplayed():
	for r in reply:
		EmoteManager.emote(r)



