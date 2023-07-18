extends Node



var saved_vars := ["flower_seeds", "wallet"]



enum Type {
	NEBULA_NECTAR, # - - - 5
	MOONLIGHT_BLOSSOM, # produces mana
	BLOODROOT, # produces blood
	MALIGNANT_MAGNOLIA, # produces 
	STARDUST_ORCHID,
	CELESTIA_ROSE,
	TWILIGHT_DAISY,
	EMBER_TULIP,
	PHOENIX_PETAL,
	QUEEN_OF_THE_NIGHT,
	RADIANT_DAHLIA,
	STARLILY,
	BLACK_ROSE,
	STARFIRE_SUNFLOWER,
	SLIPPER_GINGER,
	CHOCOLATE_COSMOS,
	CORPSE_LILY,
	ENCHANTED_IRIS,
	SHIMMERING_ROSE,
	ENIGMA_DAFFODIL,
	FROSTFIRE_SNAP,
	JADE_VINE,
	TITAN_ARUM,
	PETALWING_LILY,
	GHOST_ORCHID, # - - - 4
	CELESTIAL_ZINNIA,
	SPARKLEFERN,
	LUMINARA_STARLILY,
	MOONFLOWER,
	BLACK_ORCHID,
	RAINBOW_EUCALYPTUS,
	SERAPHINA_SPARKLEFERN,
	EVERBLOOM,
	FLAMINGO_FLOWER,
	AMETHYST_LILY,
	SAPPHIRE_POPPY,
	EBONY_DAISY,
	CRYSTAL_TWILIGHT_BLOSSOM,
	EMBERGLADE,
	VELVET_PANSY,
	TRANQUIL_LILY,
	WHISPERING_WISTERIA,
	ASTRAL_PETUNIA,
	IMPERIAL_IRIS,
	DREAMLEAF_FERN,
	MOONLIGHT_ORCHID, # - - - 3
	RADIANT_ROSE,
	DREAMSHADE,
	AURORA_LILY,
	SILVERBELL_BELLFLOWER,
	CRYSTAL_LOTUS,
	BLUE_PUYA,
	MARBLE_TULIP,
	JACARANDA,
	ANGELIC_DAFFODIL,
	ETERNAL_BLOSSOM,
	PETALWISP,
	FROSTBLOOM_JASMINE,
	CELESTIAL_GLADIOLUS,
	CHERRY_BLOSSOM,
	WISPFLOWER,
	PRISMATIC_IRIS,
	VELVET_VIOLET,
	OPALINE_PETUNIA,
	ENCHANTED_CARNATION,
	ROSE, # - - - 2
	ORCHID,
	LILY,
	DAISY,
	IRIS,
	CARNATION,
	PANSY,
	CHRYSANTHEMUM,
	GERBERA,
	PEONY,
	SNAPDRAGON,
	LAVENDER,
	LOTUS,
	POPPY,
	HIBISCUS,
	DAFFODIL,
	ZINNIA,
	JASMINE,
	LAVATERA,
	STATICE,
	PROTEA,
	LISIANTHUS,
	CAMELLIA,
	RANUNCULUS,
	FOXGLOVE,
	WISTERIA, # - - - 1
	YARROW,
	GAILLARDIA,
	SWEETPEA,
	MORNING_GLORY,
	PETUNIA,
	GAZANIA,
	MILKWEED,
	PITCHER_PLANT,
	COCKSCOMB,
	PINCUSHION,
	JACOBS_LADDER,
	BABYS_BREATH,
	BEE_BALM,
	ROSEMARY,
	SUNFLOWER,
	DANDELION,
	GERANIUM,
	MARIGOLD,
	TULIP,
	VIOLET,
	HYDRANGEA,
	GINGER_ROOT,
	RAGWORT, # - - - 0
	GOOGRASS,
	STINKWEED,
	SNEEZEWEED,
	BITTERWEED,
	GOUTWEED,
	SKUNK_CABBAGE,
	DEADNETTLE,
	KNAPWEED,
	KNOTWEED,
	SNOTWEED,
	SCHLONKWEED,
	POOPGRASS,
	ASSGRASS,
	PEEWEED,
	BOOGERBLOSSOM,
	HEMHORROID_HERB,
	DONKY_DAISY,
	SCHLONKY_DAISY,
	BLEACHBLOOM,
	SLIMEWEED,
	PUS_POSY,
	OOZEWORT,
	SCABLEAF,
	GURGLEGRASS,
	BLISTERBRANCH,
	PIMPLEGRASS,
	SPLATROOT,
	RETCHLEAF,
	SLOPDRAGON,
	EVERSTAIN,
}

const TIER_WEIGHT := {
	tier0 = 100,
	tier1 = 600,
	tier2 = 200,
	tier3 = 50,
	tier4 = 10,
	tier5 = 1,
}

const Icons := {
	
	# misc
	
	"flowers": preload("res://Sprites/flowers/001.png"),
	
	# 2
	
	"LAVENDER": preload("res://Sprites/flowers/021.png"),
	"DAISY": preload("res://Sprites/flowers/043.png"),
	"CARNATION": preload("res://Sprites/flowers/090.png"),
	"ROSE": preload("res://Sprites/flowers/091.png"),
	
	# 1 
	
	"BABYS_BREATH": preload("res://Sprites/flowers/004.png"),
	"MILKWEED": preload("res://Sprites/flowers/007.png"),
	"BEE_BALM": preload("res://Sprites/flowers/012.png"),
	"VIOLET": preload("res://Sprites/flowers/018.png"),
	"PINCUSHION": preload("res://Sprites/flowers/020.png"),
	"ROSEMARY": preload("res://Sprites/flowers/051.png"),
	"JACOBS_LADDER": preload("res://Sprites/flowers/053.png"),
	"HYDRANGEA": preload("res://Sprites/flowers/056.png"),
	"DANDELION": preload("res://Sprites/flowers/062.png"),
	"YARROW": preload("res://Sprites/flowers/062.png"),
	"SUNFLOWER": preload("res://Sprites/flowers/063.png"),
	"GINGER_ROOT": preload("res://Sprites/flowers/078.png"),
	"TULIP": preload("res://Sprites/flowers/079.png"),
	"MORNING_GLORY": preload("res://Sprites/flowers/084.png"),
	"GERANIUM": preload("res://Sprites/flowers/093.png"),
	"COCKSCOMB": preload("res://Sprites/flowers/096.png"),
	"PITCHER_PLANT": preload("res://Sprites/flowers/096.png"),
	"MARIGOLD": preload("res://Sprites/flowers/099.png"),
	
	# 0 
	
	"RAGWORT": preload("res://Sprites/flowers/027.png"),
	"SCHLONKWEED": preload("res://Sprites/flowers/027.png"),
	"PUS_POSY": preload("res://Sprites/flowers/027.png"),
	"GOOGRASS": preload("res://Sprites/flowers/028.png"),
	"POOPGRASS": preload("res://Sprites/flowers/028.png"),
	"OOZEWORT": preload("res://Sprites/flowers/028.png"),
	"STINKWEED": preload("res://Sprites/flowers/029.png"),
	"ASSGRASS": preload("res://Sprites/flowers/029.png"),
	"SCABLEAF": preload("res://Sprites/flowers/029.png"),
	"SNEEZEWEED": preload("res://Sprites/flowers/030.png"),
	"PEEWEED": preload("res://Sprites/flowers/030.png"),
	"GURGLEGRASS": preload("res://Sprites/flowers/030.png"),
	"BITTERWEED": preload("res://Sprites/flowers/031.png"),
	"BOOGERBLOSSOM": preload("res://Sprites/flowers/031.png"),
	"BLISTERBRANCH": preload("res://Sprites/flowers/031.png"),
	"GOUTWEED": preload("res://Sprites/flowers/032.png"),
	"HEMHORROID_HERB": preload("res://Sprites/flowers/032.png"),
	"PIMPLEGRASS": preload("res://Sprites/flowers/032.png"),
	"DEADKNETTLE": preload("res://Sprites/flowers/033.png"),
	"DONKY_DAISY": preload("res://Sprites/flowers/033.png"),
	"SPLATROOT": preload("res://Sprites/flowers/033.png"),
	"KNAPWEED": preload("res://Sprites/flowers/034.png"),
	"SCHLONKY_DAISY": preload("res://Sprites/flowers/034.png"),
	"RETCHLEAF": preload("res://Sprites/flowers/034.png"),
	"KNOTWEED": preload("res://Sprites/flowers/035.png"),
	"BLEACHBLOOM": preload("res://Sprites/flowers/035.png"),
	"SLOPDRAGON": preload("res://Sprites/flowers/035.png"),
	"SNOTWEED": preload("res://Sprites/flowers/036.png"),
	"SLIMEWEED": preload("res://Sprites/flowers/036.png"),
	"EVERSTAIN": preload("res://Sprites/flowers/036.png"),
}

signal flower_count_changed(flower)

var total_weight: int

var flower_names := {}

var tier_0_list := []
var tier_1_list := []
var tier_2_list := []
var tier_3_list := []
var tier_4_list := []
var tier_5_list := []

var flower_seeds := []

var wallet := {}



func load(data: Dictionary) -> void:
	SaveManager.load_vars(self, data)
	post_load_garden_setup()



func open():
	setup_wallet()


func close():
	reset_wallet()



func _ready() -> void:
	setup_total_weight()
	setup_tier_lists()
	setup_flower_names()
	
	#DEBUG__test_tier_weight()



func setup_total_weight():
	for tier in TIER_WEIGHT:
		total_weight += TIER_WEIGHT[tier]


func setup_wallet():
	for flower in Type:
		wallet[flower] = 0


func setup_flower_names():
	for flower in Type:
		if flower == "JACOBS_LADDER":
			flower_names[flower] = "Jacob's Ladder"
		elif flower == "BABYS_BREATH":
			flower_names[flower] = "Baby's Breath"
		else:
			flower_names[flower] = flower.capitalize().replace("_", " ")


func reset_wallet():
	wallet = {}


func setup_tier_lists():
	
	for flower in Type.values():
		if flower < Type.GHOST_ORCHID:
			tier_5_list.append(flower)
		elif flower >= Type.GHOST_ORCHID and flower < Type.MOONLIGHT_ORCHID:
			tier_4_list.append(flower)
		elif flower >= Type.MOONLIGHT_ORCHID and flower < Type.ROSE:
			tier_3_list.append(flower)
		elif flower >= Type.ROSE and flower < Type.WISTERIA:
			tier_2_list.append(flower)
		elif flower >= Type.WISTERIA and flower < Type.RAGWORT:
			tier_1_list.append(flower)
		else:
			tier_0_list.append(flower)


func post_load_garden_setup():
	for flower in wallet:
		if wallet[flower] > 0:
			emit_signal("flower_count_changed", flower)



func add_random_flower(output_modifier = 1, roll_bonus := 0):
	
	var flower = get_random_flower(roll_bonus)
	
	if output_modifier is Big:
		output_modifier = output_modifier.toFloat() as float
	
	var amount: int = int(output_modifier)
	
	add_flower(flower, amount)



func get_random_flower(roll_bonus := 0) -> String:
	
	randomize()
	
	var tier := roll_for_tier(roll_bonus)
	var tier_list: Array = get("tier_" + str(tier) + "_list")
	var flower_index: int = tier_list[randi() % tier_list.size()]
	var flower: String = Type.keys()[flower_index]
	
	return flower


func roll_for_tier(roll_bonus: int) -> int:
	
	var tier_weights = []
	var total_adjusted_weight = 0
	
	for tier in TIER_WEIGHT:
		var adjusted_weight = TIER_WEIGHT[tier] + roll_bonus * (int(tier[len(tier)-1]) - 1)
		tier_weights.append(adjusted_weight)
		total_adjusted_weight += adjusted_weight
	
	var roll = randi() % total_adjusted_weight
	var threshold = 0
	for i in range(tier_weights.size()):
		threshold += tier_weights[i]
		if roll < threshold:
			return i
	
	return tier_weights.size() - 1



func add_flower(flower, amount := 1) -> void:
	
	if flower is int:
		flower = Type.keys()[flower]
	
	wallet[flower] += amount
	emit_signal("flower_count_changed", flower)


func subtract_flower(flower, amount: int) -> void:
	remove_flower(flower, amount)

func remove_flower(flower, amount: int) -> void:
	
	if flower is int:
		flower = Type.keys()[flower]
	
	wallet[flower] -= amount
	emit_signal("flower_count_changed", flower)



func get_flower_count(flower) -> int:
	
	if flower is int:
		flower = Type.keys()[flower]
	
	return wallet[flower]


func get_flower_tier(flower) -> int:
	
	if flower is String:
		flower = Type[flower]
	
	return 5 if flower in tier_5_list else (
		4 if flower in tier_4_list else (
			3 if flower in tier_3_list else (
				2 if flower in tier_2_list else (
					1 if flower in tier_1_list else 0
				)
			)
		)
	)


func get_flower_name(flower) -> String:
	if flower is int:
		flower = Type.keys()[flower]
	
	return flower_names[flower]


func get_plural_flower_name(flower) -> String:
	if flower is int:
		flower = Type.keys()[flower]
	var name = flower_names[flower]
	if name.ends_with("y"):
		name = name.rsplit("y")[0] + "ies"
	else:
		name += "s"
	return name


func get_flower_icon(flower) -> Texture:
	if flower is int:
		flower = Type.keys()[flower]
	return Icons[flower]



func get_output_text_details(producedResources: Dictionary, _critMultiplier: float) -> Array:
	
	var array := []
	
	for flower in producedResources:
		
		var f := {}
		
		f["life"] = 75
		f["text"] = "+" + fval.f(producedResources[flower])
		f["resource name"] = get_flower_name(flower)# + (" (Trash)" if tier == 0 else "(" + str(tier) + ")")
		f["icon"] = Icons[flower] if flower in Icons.keys() else Icons["flowers"]
		f["color"] = gv.COLORS["witch"]
		f["texture modulate"] = gv.COLORS["witch"]
		
		array.append(f)
	
	return array




func store_new_flower_seed(count: int, roll_bonus: int):
	var new_seed = FlowerSeed.new(count, roll_bonus)
	flower_seeds.append(new_seed)


func seed_is_available() -> bool:
	return not flower_seeds.empty()


func get_most_recent_flower_seed() -> FlowerSeed:
	var most_recent_seed_position: int = flower_seeds.size() - 1
	return flower_seeds[most_recent_seed_position]


func plant_flower_seed(_seed: FlowerSeed = get_most_recent_flower_seed()):
	gv.subtractFromResource(gv.Resource.FLOWER_SEED, _seed.count)
	_seed.sprout()
	flower_seeds.erase(_seed)





# - Debug

func DEBUG__test_tier_weight():
	
	randomize()
	
	var rolled_tiers = []
	
	for _i in range(1, 100000):
		var tier := roll_for_tier(500) # cap: 500.
		rolled_tiers.append(tier)
	
	print_debug(
		"0: ", float(rolled_tiers.count(0)) / rolled_tiers.size() * 100, "%",
		"\n1: ", float(rolled_tiers.count(1)) / rolled_tiers.size() * 100, "%",
		"\n2: ", float(rolled_tiers.count(2)) / rolled_tiers.size() * 100, "%",
		"\n3: ", float(rolled_tiers.count(3)) / rolled_tiers.size() * 100, "%",
		"\n4: ", float(rolled_tiers.count(4)) / rolled_tiers.size() * 100, "%",
		"\n5: ", float(rolled_tiers.count(5)) / rolled_tiers.size() * 100, "%"
	)
