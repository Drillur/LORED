extends Node



enum Type {
	NEBULA_NECTAR = Currency.Type.NEBULA_NECTAR, # - - - 5
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

const TIER_WEIGHT := [
	25,
	41,
	22,
	8,
	3,
	1,
]

signal flower_count_changed(flower)

var flower_names := {}

var tier_0_list := []
var tier_1_list := []
var tier_2_list := []
var tier_3_list := []
var tier_4_list := []
var tier_5_list := []



func _ready() -> void:
	setup_tier_lists()


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



# - Internal


func roll_for_tier(roll_bonus: int) -> int: 
	# at 25 roll_bonus, tier 0 is never rolled.
	# it follows that at 66, tier 1 is never rolled. (25 + 41 = 66)
	# i think a good cap is 50. 1:32% 2:44% 3:16% 4:6% 5:2%
	# in fact it is an amazing cap. except for t1, all tier chances doubled. idk why! but it's neat!
	
	randomize()
	var rolled_tier: int = 5
	var roll = randi() % (100 - roll_bonus) + 1 + roll_bonus
	for tier in 6:
		if roll <= TIER_WEIGHT[tier]:
			rolled_tier = tier
			break
		else:
			roll -= TIER_WEIGHT[tier]
	return rolled_tier



# - Action


func add_random_flower(from_lored: bool, amount = 1, roll_bonus := 0):
	var flower: Currency.Type = get_random_flower(roll_bonus)
	if amount is Big:
		amount = amount.toInt()
	#print_debug("gained ", amount, " ", wa.get_currency_name(flower))
	if from_lored:
		wa.add_from_lored(flower, amount)
	else:
		wa.add(flower, amount)



# - Get


func get_random_flower(roll_bonus := 0) -> Currency.Type:
	var tier := roll_for_tier(roll_bonus)
	var tier_list: Array = get("tier_" + str(tier) + "_list")
	var flower_index: Currency.Type = tier_list[randi() % tier_list.size()]
	return flower_index


func get_flower_tier(type: Currency.Type) -> int:
	return 5 if type in tier_5_list else (
		4 if type in tier_4_list else (
			3 if type in tier_3_list else (
				2 if type in tier_2_list else (
					1 if type in tier_1_list else 0
				)
			)
		)
	)


func get_currency(type: Type) -> Currency:
	return wa.get_currency(int(type))





# - Debug


func DEBUG__test_tier_weight(roll_bonus: int = 0):
	
	randomize()
	
	var rolled_tiers = []
	
	for _i in range(1, 10000):
		var tier := roll_for_tier(roll_bonus) # cap: 50.
		rolled_tiers.append(tier)
	
	print_debug(
		"Roll_bonus: ", roll_bonus,
		"\n0: ", float(rolled_tiers.count(0)) / rolled_tiers.size() * 100, "%",
		"\n1: ", float(rolled_tiers.count(1)) / rolled_tiers.size() * 100, "%",
		"\n2: ", float(rolled_tiers.count(2)) / rolled_tiers.size() * 100, "%",
		"\n3: ", float(rolled_tiers.count(3)) / rolled_tiers.size() * 100, "%",
		"\n4: ", float(rolled_tiers.count(4)) / rolled_tiers.size() * 100, "%",
		"\n5: ", float(rolled_tiers.count(5)) / rolled_tiers.size() * 100, "%"
	)


func DEBUG__test_random_flower(roll_bonus: int = 0):
	
	randomize()
	
	var rolled_flowers = {
		0: {},
		1: {},
		2: {},
		3: {},
		4: {},
		5: {},
	}
	var keys = Type.keys()
	
	for _i in range(1, 10000):
		var flower := get_random_flower(roll_bonus) # cap: 50.
		var key = keys[flower - Type.NEBULA_NECTAR]
		var tier = get_flower_tier(flower)
		if not key in rolled_flowers[tier]:
			rolled_flowers[tier][key] = 1
		else:
			rolled_flowers[tier][key] += 1
	
	print_debug(
		"Roll_bonus: ", roll_bonus,
		"\nFlowers (tier 0): ", rolled_flowers[0],
		"\nFlowers (tier 1): ", rolled_flowers[1],
		"\nFlowers (tier 2): ", rolled_flowers[2],
		"\nFlowers (tier 3): ", rolled_flowers[3],
		"\nFlowers (tier 4): ", rolled_flowers[4],
		"\nFlowers (tier 5): ", rolled_flowers[5],
	)
