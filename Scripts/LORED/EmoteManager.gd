extends Node


const scriptedEmotes := 7
enum Type {
	IRON_WISH_LOG,
	STONE_HAPPY,
	COAL_REPLY_STONE_HAPPY,
	STONE_REPLY_COAL_REPLY_STONE_HAPPY,
	COAL_REPLY_STONE_COAL_STONE_HAPPY,
	COAL_WHOA,
	COAL_GREET,
	
	# RANDOM BELOW
	TREES0,
	TREES0_GROWTH0,
	TREES0_SOIL0,
	TREES1,
	TREES2,
	TREES2_WATER0,
	TREES2_TREES0,
	TREES3,
	TREES4,
	TREES5,
	TREES6,
	TREES7,
	TREES8,
	TREES8_SEEDS0,
	SOIL0,
	SOIL1,
	SOIL2,
	SOIL3,
	SOIL4,
	SOIL5,
	SOIL5_HUMUS0,
	SOIL6,
	SOIL7,
	HUMUS0,
	HUMUS1,
	HUMUS2,
	HUMUS3,
	HUMUS4,
	HUMUS5,
	HUMUS6,
	HUMUS7,
	HUMUS7_GALENA0,
	HUMUS8,
	SEEDS0,
	SEEDS1,
	SEEDS2,
	SEEDS3,
	SEEDS4,
	SEEDS5,
	SEEDS6,
	SEEDS7,
	SEEDS8,
	WATER0,
	WATER1,
	WATER2,
	WATER3,
	WATER4,
	WATER5,
	WATER6,
	WATER6_TREES0,
	WATER7,
	WATER8,
	WATER9,
	COAL0,
	COAL1,
	COAL2,
	COAL3,
	COAL4,
	COAL5,
	COAL6,
	COAL7,
	COPPER_ORE_REPLY0,
	CONCRETE_REPLY0,
	JOULES_REPLY0,
	STONE0,
	STONE1,
	STONE2,
	STONE3,
	STONE4,
	STONE5,
	STONE6,
	STONE7,
	IRON_ORE_REPLY0,
	IRON_ORE0,
	IRON_ORE1,
	IRON_ORE2,
	IRON_ORE3,
	IRON_ORE4,
	IRON_ORE5,
	IRON_ORE6,
	IRON_ORE7,
	IRON_ORE8,
	IRON_ORE8_STONE_REPLY0
	IRON_ORE9,
	IRON_ORE9_JOULES0,
	IRON_ORE10,
	COPPER_ORE0,
	COPPER_ORE1,
	COPPER_ORE2,
	COPPER_ORE3,
	COPPER_ORE4,
	COPPER_ORE5,
	COPPER_ORE6,
	COPPER_ORE7,
	COPPER_ORE8,
	COPPER_ORE9,
	COPPER_ORE10,
	COPPER_ORE11,
	COPPER_ORE12,
	COPPER0,
	COPPER1,
	COPPER2,
	COPPER3,
	COPPER4,
	COPPER4_WOOD0,
	COPPER5,
	COPPER6,
	COPPER7,
	COPPER7_COPPER_ORE0,
	IRON0,
	IRON1,
	IRON1_STONE0,
	IRON2,
	IRON2_IRON_ORE0,
	IRON4,
	IRON4_HARDWOOD0,
	IRON5,
	IRON6,
	IRON7,
	JOULES0,
	JOULES1,
	JOULES2,
	JOULES3,
	JOULES4,
	JOULES4_COAL0,
	JOULES5,
	JOULES6,
	JOULES6_OIL0,
	JOULES7,
	GROWTH0,
	GROWTH0_OIL0,
	GROWTH1,
	GROWTH2,
	GROWTH3,
	GROWTH3_TARBALLS0,
	GROWTH4,
	GROWTH5,
	GROWTH6,
	GROWTH6_JOULES0,
	GROWTH7,
	GROWTH8,
	GROWTH9,
	GROWTH9_IRON0,
	CONCRETE0,
	CONCRETE1,
	CONCRETE2,
	CONCRETE3,
	CONCRETE4,
	CONCRETE5,
	CONCRETE6,
	CONCRETE7,
	OIL0,
	OIL1,
	OIL2,
	OIL3,
	OIL4,
	OIL5,
	OIL6,
	OIL7,
	OIL8,
	OIL9,
	OIL10,
	TARBALLS0,
	TARBALLS1,
	TARBALLS2,
	TARBALLS3,
	TARBALLS4,
	TARBALLS5,
	TARBALLS5_GROWTH0,
	TARBALLS6,
	TARBALLS7,
	TARBALLS8,
	MALIGNANCY0,
	MALIGNANCY1,
	MALIGNANCY2,
	MALIGNANCY3,
	MALIGNANCY4,
	MALIGNANCY5,
	MALIGNANCY6,
	MALIGNANCY7,
	MALIGNANCY8,
	MALIGNANCY9,
	MALIGNANCY10,
	MALIGNANCY11,
	MALIGNANCY12,
	MALIGNANCY13,
}


var queue: Dictionary
var emotingLOREDs: Array

var completedEmotes: Array

var saved_vars := ["completedEmotes"]

var randomEmotesAllowed := false



func save() -> String:
	
	var data := {}
	
	for x in saved_vars:
		data[x] = var2str(get(x))
	
	return var2str(data)

func load(data: Dictionary):
	
	#* Copy-paste this block to a script where saving a Dictionary is necessary
	var saved_vars_dict := {}
	
	for x in saved_vars:
		saved_vars_dict[x] = get(x)
	
	var loadedVars = SaveManager.loadSavedVars(saved_vars_dict, data)
	
	for x in saved_vars:
		if not x in loadedVars:
			continue
		set(x, loadedVars[x])
	#*



func emote(type: int):
	
	if Type.keys()[type] in completedEmotes:
		return
	
	if isRandomEmote(type):
		if not randomEmotesAllowed:
			return
	
	var emote = gv.SRC["emote"].instance()
	emote.setup(type)
	
	if not lv.lored[emote.speaker].unlocked:
		emote.queue_free()
		return
	
	if emote.speaker in emotingLOREDs:
		if emote.random:
			emote.queue_free()
			return
		queue(emote)
		return
	
	finalizeEmote(emote)

func queue(emote: MarginContainer):
	if emote.speaker in queue.keys():
		emote.queue_free()
		return
	queue[emote.speaker] = emote

func emoteFreed(type: int, speaker: int):
	emotingLOREDs.erase(speaker)
	
	var key: String = Type.keys()[type]
	if not key in completedEmotes:
		if isScriptedEmote(type):
			completedEmotes.append(key)
	
	if speaker in queue.keys():
		resumeEmote(queue[speaker])

func resumeEmote(emote: MarginContainer):
	queue.erase(emote.speaker)
	finalizeEmote(emote)

func finalizeEmote(emote: MarginContainer):
	lv.lored[emote.speaker].emote(emote)
	emotingLOREDs.append(emote.speaker)

func isRandomEmote(type: int) -> bool:
	return type >= scriptedEmotes
func isScriptedEmote(type: int) -> bool:
	return not isRandomEmote(type)

func close():
	completedEmotes.clear()
	emotingLOREDs.clear()
	queue.clear()
	randomEmotesAllowed = false
