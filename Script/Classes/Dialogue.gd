class_name Dialogue
extends Resource



const saved_vars := [
	"read",
]



enum Type {
	END,
	BACK_TO_HUB,
	COAL_HUB,
		WHAT_IS_FUEL,
			RUN_OUT_OF_FUEL,
			RUN_OUT_OF_FUEL2,
			SUCKERS,
		WHY_IS_FUEL,
			WHY_IS_FUEL2,
	STONE_HUB,
		HOW_LEVEL_UP,
			WHAT_IS_IRON,
			WHAT_LEVEL_UP_DO,
			WHAT_IS_FUEL_BAD,
		WHAT_IS_LORED,
			WHY_IS_LORED,
		WHY_LIKE_ROCKS,
			WHY_LIKE_ROCKS2,
	IRON_ORE_HUB,
		IRON_ORE_WHAT_DOING,
		IRON_ORE_WHAT_DOING2,
		IRON_ORE_WHAT_DOING3,
}



var type: Type
var key: String
var text: String
var pose: Texture2D
var speaker := LORED.Type.NO_LORED
var replies := {}
var read := LoudBool.new(false)
var condition: LoudBool
var reply_chain_read := LoudBool.new(false)
var chain_parent: Dialogue.Type
var end_of_chain := false




func _init(_type: Type):
	type = _type
	key = Type.keys()[type]
	
	# set speaker & chain_parent (except for HUBS)
	match type:
		Type.WHY_LIKE_ROCKS2, Type.WHY_LIKE_ROCKS, Type.WHY_IS_LORED, Type.HOW_LEVEL_UP, Type.WHAT_IS_IRON, Type.WHAT_LEVEL_UP_DO, Type.WHAT_IS_FUEL_BAD, Type.WHAT_IS_LORED:
			speaker = LORED.Type.STONE
			chain_parent = Type.STONE_HUB
		Type.WHAT_IS_FUEL, Type.RUN_OUT_OF_FUEL, Type.RUN_OUT_OF_FUEL2, Type.SUCKERS, Type.WHY_IS_FUEL, Type.WHY_IS_FUEL2:
			speaker = LORED.Type.COAL
			chain_parent = Type.COAL_HUB
		Type.IRON_ORE_WHAT_DOING2, Type.IRON_ORE_WHAT_DOING3, Type.IRON_ORE_WHAT_DOING:
			speaker = LORED.Type.IRON_ORE
			chain_parent = Type.IRON_ORE_HUB
	
	match type:
		Type.IRON_ORE_HUB:
			speaker = LORED.Type.IRON_ORE
			text = "*Murderous mumbling*"
			replies[Type.IRON_ORE_WHAT_DOING2] = "Don't you have any useful advice for me?"
			replies[Type.IRON_ORE_WHAT_DOING] = "What are you even doing?"
		Type.IRON_ORE_WHAT_DOING2:
			text = "No."
			replies[Type.BACK_TO_HUB] = "I accept your decision and respect your boundaries."
			replies[Type.IRON_ORE_WHAT_DOING3] = "You must provide advice; I am the player and so I demand it."
		Type.IRON_ORE_WHAT_DOING3:
			text = "Alt-F4 is actually a secret hotkey implemented by the dev to give you 1% of you current resources per second. He did that so that no one except babies would accidentally press it, and to more quickly test and debug the game. Go on! Press it!"
			replies[Type.BACK_TO_HUB] = ""
		Type.IRON_ORE_WHAT_DOING:
			#condition
			text = "I'm practicing for you."
			replies[Type.BACK_TO_HUB] = "Okay, anyway--"
		
		
		Type.STONE_HUB:
			speaker = LORED.Type.STONE
			text = "Lalala~!"
			replies[Type.HOW_LEVEL_UP] = "How do I level you up?"
			replies[Type.WHAT_IS_LORED] = "What is a LORED?"
			replies[Type.WHY_LIKE_ROCKS] = "Why do you like picking up rocks? Are you acoustic?"
		Type.HOW_LEVEL_UP:
			text = "Just click on the %s button! But it costs resources, so if you don't have enough, it won't work." % res.get_icon_text("Level")
			replies[Type.WHAT_IS_IRON] = "Leveling you up costs %s and %s. What is that?" % [
				wa.get_icon_and_name_text(Currency.Type.IRON),
				wa.get_icon_and_name_text(Currency.Type.COPPER)
			]
			replies[Type.WHAT_LEVEL_UP_DO] = "What does leveling you up do?"
		Type.WHAT_IS_IRON:
			text = "If you don't have them unlocked yet, then I guess you'll just have to wait until it's unlocked to find out! " + gv.color_text(Color.WEB_GRAY, "But keep this in mind: %s goes super well with peanut butter and honey." % wa.get_icon_and_name_text(Currency.Type.IRON))
			replies[Type.HOW_LEVEL_UP] = "Alrighty, then."
			end_of_chain = true
		Type.WHAT_LEVEL_UP_DO:
			text = "It wrinkles my brain by 200%! ... Actually, it doubles most of my stats. I'll make 2x as much " + wa.get_icon_and_name_text(Currency.Type.STONE) + ", for example. [shake rate=20.0 level=5 connected=0]BUT!!![/shake] It also doubles my fuel usage!!! So be careful!!!"
			replies[Type.WHAT_IS_FUEL_BAD] = "What is fuel?"
		Type.WHAT_IS_FUEL_BAD:
			text = "Uhm... I don't really know. You should ask " + lv.get_colored_name(LORED.Type.COAL) + "."
			replies[Type.BACK_TO_HUB] = ""
		
		Type.WHAT_IS_LORED:
			text = "Uh... me. I'm a LORED. So is " + lv.get_colored_name(LORED.Type.COAL) + "."
			replies[Type.WHY_IS_LORED] = "Why is a LORED?"
		Type.WHY_IS_LORED:
			condition = gv.dialogue[Type.WHY_IS_FUEL].reply_chain_read
			text = "[shake rate=20.0 level=5 connected=0]Oh, no!!![/shake] " + lv.get_colored_name(LORED.Type.COAL) + " told me all about you! You won't trick me!!! I'm gettin da heck outta here!!!"
			replies[Type.BACK_TO_HUB] = ""
		Type.WHY_LIKE_ROCKS:
			text = "What?! No! I'm artistic!"
			replies[Type.WHY_LIKE_ROCKS2] = "Artistic...?"
		Type.WHY_LIKE_ROCKS2:
			text = "Yep! I crumble these up and splash these onto a big canvas and then crush them flat with a huge press! You would be surprised at the colors that are possible with rocks. Do you want to see one of my pieces?!"
			replies[Type.BACK_TO_HUB] = "No."
		
		
		
		Type.COAL_HUB:
			speaker = LORED.Type.COAL
			text = "Don't mind me! Just diggin' around!"
			replies[Type.WHAT_IS_FUEL] = "What is fuel?"
			replies[Type.WHY_IS_FUEL] = "Why is fuel?"
		Type.WHAT_IS_FUEL:
			condition = lv.get_lored(LORED.Type.COAL).purchased
			text = "Dude! Don't you have a car or something? What about a phone? Lots of things need fuel. So do we! Duh! My fuel is %s, which is convenient because that's what I produce!" % wa.get_icon_and_name_text(Currency.Type.COAL)
			replies[Type.RUN_OUT_OF_FUEL] = "What happens if you run out of fuel?"
		Type.RUN_OUT_OF_FUEL:
			text = "Tee hee! There's a secret about that! Actually, nobody can take any " + wa.get_icon_and_name_text(Currency.Type.COAL) + " if I have less than 50% fuel! You could say I'm a pretty important guy."
			replies[Type.RUN_OUT_OF_FUEL2] = "What if other LOREDs run out of fuel?"
		Type.RUN_OUT_OF_FUEL2:
			text = "Oh, then they just can't do anything. Suckers."
			replies[Type.SUCKERS] = "Yeah, what a bunch of suckers!"
		Type.SUCKERS:
			text = "Yeah, man!!!"
			replies[Type.BACK_TO_HUB] = "[b]Yeah!!!!!![/b]"
		
		Type.WHY_IS_FUEL:
			condition = gv.dialogue[Type.WHAT_IS_FUEL].reply_chain_read
			text = "What are you talking about?"
			replies[Type.WHY_IS_FUEL2] = "Why is this a mechanic in the game?"
		Type.WHY_IS_FUEL2:
			text = "You've lost your mind, dude! Leave me alone!"
			replies[Type.BACK_TO_HUB] = "(Back)"
		
		Type.END, Type.BACK_TO_HUB:
			read.set_to(true)
			reply_chain_read.set_to(true)
	
	
	
	if has_condition():
		condition.became_true.connect(condition_fulfilled)
		condition.became_false.connect(condition_unfulfilled)
	if not has_replies() or Type.END in replies.keys():
		end_of_chain = true
	if Type.BACK_TO_HUB in replies.keys():
		if replies.size() == 1:
			end_of_chain = true
		if replies[Type.BACK_TO_HUB] != "(Back)":
			replies[Type.BACK_TO_HUB] = "(Back) " + replies[Type.BACK_TO_HUB]
		replies[chain_parent] = replies[Type.BACK_TO_HUB]
		replies.erase(Type.BACK_TO_HUB)



# - Signal


func condition_fulfilled() -> void:
	condition.set_to(true)


func condition_unfulfilled() -> void:
	condition.set_to(false)



# - Action


func mark_chain_read() -> void:
	if has_chain_parent():
		reply_chain_read.set_to(true)
		gv.dialogue[chain_parent].is_reply_chain_read()



# - Get


func has_condition() -> bool:
	return condition != null


func has_speaker() -> bool:
	return speaker != LORED.Type.NO_LORED


func has_pose() -> bool:
	return pose != null


func has_replies() -> bool:
	return replies.size() > 0


func has_valid_replies() -> bool:
	for r in replies:
		var reply_d: Dialogue = gv.dialogue[r]
		if reply_d.has_condition() and reply_d.condition.is_false():
			continue
		return true
	return false


func is_unlocked() -> bool:
	if has_condition():
		return condition.get_value()
	return true


func is_reply_chain_read(chain := []) -> bool:
	if self in chain:
		return true
	else:
		chain.append(self)
	
	if reply_chain_read.is_true():
		return true
	if read.is_false():
		return false
	if not end_of_chain:
		for reply in replies:
			if not gv.dialogue[reply].is_reply_chain_read(chain):
				return false
	reply_chain_read.set_to(true)
	return true


func has_chain_parent() -> bool:
	return chain_parent != null
