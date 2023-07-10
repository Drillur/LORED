class_name Unit
extends Reference



enum Type {
	SKINNY_CIVILIAN,
	AVERAGE_CIVILIAN,
	HEAVY_CIVILIAN,
	PET,
}

const civilian_name_pool = [
	"Jaina",
	"Arthas",
	"Thrall",
	"Khadgar",
	"May",
	"Joyce",
	"Brian",
	"Rondelle",
	"Parker",
	"Peter",
	"Puck",
	"Farnese",
	"Casca",
	"Griffith",
	"Kakashi",
	"Arnheid",
	"Askeladd",
	"Einar",
	"Thorfinn",
	"Yagami",
	"Goku",
	"Saitama",
	"Edward",
	"Vegeta",
	"Guts",
	"Dio",
	"Vash",
	"Rock",
	"Helga",
	"Elara",
	"Asher",
	"Isolde",
	"Elowen",
	"Lilia",
	"Estraven",
	"Therem",
	"Cedric",
	"Cedric",
	"Amara",
	"Elysia",
	"Lucas",
	"Isabella",
	"Felix",
	"Seraphina",
	"Evander",
	"Lavinia",
	"Jasper",
	"Aria",
	"Magnus",
	"Selene",
	"Cyrus",
	"Aurora",
	"Dante",
	"Calista",
	"Orion",
	"Cassia",
	"Thaddeus",
	"Lyra",
	"Sebastian",
	"Valentina",
	"Atticus",
	"Cecilia",
	"Maximus",
	"Helena",
	"Leander",
	"Seraphia",
	"Evander",
	"Marcella",
	"Ohtil",
	"Anthony",
	"Michael",
	"Ryan",
	"Chris",
	"Matt",
	"Kam",
	"Hannah",
	"Tayton",
	"Ben",
	"Leigh Ann",
	"Lizette",
	"Dillon",
	"McKenzey",
	"Bianca",
	"Elizabeth",
	"Shelby",
	"Emily",
	"Kasey",
	"Rani",
	"Lincoln",
	"Santos",
	"Monze",
	"Leo",
	"Baron",
	"Bastian",
	"Sam",
	"Froughdough",
	"Gandilf ;)",
	"Johnson",
	"John",
	"Ripley",
	"Snot",
	"Stringer",
	"Clive",
	"Cid",
	"Sarah",
	"Snow",
	"Alyx",
	"Freeman",
	"Gordon",
	"Barney",
	"Eli",
	"Kleiner",
	"Isaac",
	"Vance",
	"Calhoun",
	"Judith",
	"Mossman",
	"Wallace",
	"Breen",
	"Arne",
	"Magnusson",
	"Odessa",
	"Cubbage",
	"Grigori",
	"Cortana",
	"Halsey",
	"Joel",
	"Ellie",
	"Jon",
	"Robb",
	"Bran",
	"Sansa",
	"Ned",
	"Catelyn",
	"Glados",
	"Joan",
	"Carl",
	"CJ",
	"Tommy",
	"Vercetti",
	"Tony",
	"Paulie",
	"Silvio",
	"Vito",
	"Jackie",
	"Shepard",
	"Garrus",
	"Tali",
	"Liara",
	"Mordin",
	"Kaidan",
	"Jacob",
	"Wrex",
	"Ashley",
	"Samus",
	"Peach",
	"Sheev",
	"Luke",
	"Obi-Quiet",
	"Hermione",
	"Arya",
	"Dexter",
	"Sherlock",
	"Daeny",
	"Harry",
	"Neo",
	"Trinity",
	"Bella",
	"Lara",
	"Walter",
	"Saul",
	"Jimmy",
	"Indiana",
	"Kim",
	"Gus",
	"Nacho",
	"Mike",
	"Ehrmantraut",
	"Chuck",
	"McGill",
	"Howard",
	"Hamlin",
	"Tuco",
	"Hank",
	"Hector",
	"Huell",
	"Babineaux",
	"Gomez",
]

const pet_name_pool = [
	"Owly",
	"Luna",
	"Whiskers",
	"Shadow",
	"Max",
	"Gizmo",
	"Peanut",
	"Daisy",
	"Oliver",
	"Owly",
	"Ruby",
	"Midnight",
	"Charlie",
	"Smoky",
	"Bella",
	"Rocky",
	"Willow",
	"Merlin",
	"Milo",
	"Nala",
	"Lily",
	"Hazel",
	"Ziggy",
	"Lucy",
	"Misty",
	"Daisy",
	"Smudge",
	"Leo",
	"Poppy",
	"Pepper",
	"Dagger",
	"Salt",
	"Coco",
	"Jasper",
	"Bear",
	"Buddy",
	"Bailey",
	"Angel",
	"Duke",
	"Ace",
	"Beau",
	"Honey",
	"Cooper",
	"Chloe",
	"Stella",
	"Abby",
	"Archie",
	"Puppy",
	"Bark Twain",
	"Snoop",
	"Cartman",
]

const civilian_description_pool = [
	"Likes to watch football.",
	"Drinks too much sugar.",
	"Has a funny nose.",
	"Is weirdly tall.",
	"Has a unibrow.",
	"Has a veiny chest.",
	"Has weirdly long hair.",
	"Oh. My. God. Look at. Her. Butt.",
	"\"Everything is awesome!\"",
	"Likes chili.",
	"Is vegan.",
	"Decided to be allergic to gluten yesterday.",
	"Has a runny nose.",
	"Coughs funny.",
	"Wears glasses.",
	"Speaks too loudly.",
	"Has a funny laugh.",
	"Makes videogames for a living.",
	"Has twenty-two cats.",
	"Can speak one language!",
	"Listens to ASMR.",
	"Has bronchitis.",
	"Has a cancerous lump.",
	"Loves to drink water!",
]

const pet_description_pool = [
	"Runs in circles!",
	"Chases his tail!",
	"Chases her tail!",
	"Barks a lot!",
	"Quacks like a duck!",
	"Hoots like an owl!",
	"Can glide!",
	"Gets the stick!",
	"Assaults the mailman!",
	"Rubs on your leg!",
	"Loves to eat chili!",
	"Eats his own poopy!",
	"Farts sometimes!",
	"Is afraid of fireworks!",
	"Jumps into the freezer!",
	"Can be worn like a scarf!",
	"Pounces!",
	"Brings you mice!",
	"Attacks birds!",
	"Runs away from shoes!",
	"Loves treats!",
	"Rolls over!",
	"Speaks!",
	"Eats homework!",
	"Rips up lil stuffed animals!",
	"Scratches the couch!",
	"Plays dead!",
	"Completely ignores bugs!",
	"Slop Slop Slops from the water bowl!",
]

const pet_types = [
	"Dog",
	"Guinea Pig",
	"Cat",
	"Rabbit",
	"Parakeet",
	"Hamster",
	"Ferret",
	"Fish",
	"Turtle",
	"Horse",
	"Hedgehog",
	"Mouse",
	"Parrot",
	"Chicken",
	"Pig",
]

var type: int
var key: String
var name: String
var description: String
var pet_type: String

var health: Attribute
var blood: Attribute

var sprite: Texture

var has_vico := false
var vico: MarginContainer

var status_effects := {}





func _init(_type: int) -> void:
	
	type = _type
	key = Type.keys()[type]
	
	var initialization_method = "init_" + key
	call(initialization_method)
	
	if type == Type.PET:
		description = pet_description_pool[randi() % len(pet_description_pool)]
		pet_type = pet_types[randi() % len(pet_types)]
	else:
		description = civilian_description_pool[randi() % len(civilian_description_pool)]



func init_SKINNY_CIVILIAN():
	name = get_random_civilian_name()
	init_health(100)
	init_blood(200)
	sprite = preload("res://Sprites/reactions/TREES2_TREES0.png")


func init_AVERAGE_CIVILIAN():
	name = get_random_civilian_name()
	init_health(150)
	init_blood(250)
	sprite = preload("res://Sprites/reactions/COAL_REPLY_STONE_COAL_STONE_HAPPY.png")


func init_HEAVY_CIVILIAN():
	name = get_random_civilian_name()
	init_health(225)
	init_blood(300)
	sprite = preload("res://Sprites/reactions/HUMUS3.png")


func init_PET():
	name = get_random_pet_name()
	init_health(40)
	init_blood(80)
	# assign random pet sprite
	sprite = preload("res://Sprites/reactions/HUMUS3.png")



func get_random_civilian_name() -> String:
	return civilian_name_pool[randi() % len(civilian_name_pool)]


func get_random_pet_name() -> String:
	return pet_name_pool[randi() % len(pet_name_pool)]


func init_health(base_value: float) -> void:
	base_value = rand_range(base_value * 0.8, base_value * 1.2)
	health = Attribute.new(base_value)


func init_blood(base_value: float) -> void:
	base_value = rand_range(base_value * 0.8, base_value * 1.2)
	blood = Attribute.new(base_value)





func assign_vico(_vico: MarginContainer) -> void:
	vico = _vico
	has_vico = true



# - Get

func is_dead() -> bool:
	return health.get_current().equal(0)


func get_key_text() -> String:
	if type == Type.PET:
		return pet_type
	return key.replace("_", " ").capitalize()


func has_status_effect(_type: int) -> bool:
	return _type in status_effects.keys()



# - Actions


func take_healing(amount) -> void:
	throw_healing_text(amount)
	add_health(amount)


func take_damage(amount) -> void:
	var roll = randi() % 20
	if roll == 0:
		if amount is Big:
			amount.m(2)
		else:
			amount *= 2
	subtract_health(amount)
	throw_damage_text(amount)


func take_blood_loss(amount) -> void:
	subtract_blood(amount)


func add_health(amount) -> void:
	health.add(amount)


func subtract_health(amount) -> void:
	health.subtract(amount)


func set_current_health(value) -> void:
	health.set_to(value)


func subtract_blood(amount) -> void:
	blood.subtract(amount)



func take_status_effect(_type: int) -> void:
	if has_status_effect(_type):
		renew_status_effect(status_effects[_type])
	else:
		apply_new_status_effect(_type)



func renew_status_effect(buff: UnitStatusEffect) -> void:
	buff.renew()
	buff.add_stack()


func apply_new_status_effect(_type: int) -> void:
	var buff = UnitStatusEffect.new(_type)
	status_effects[_type] = buff
	buff.target = self
	vico.process_status_effect(buff)
	gv.emit_signal("unit_status_effect_applied", self, buff)


func remove_buff(buff: UnitStatusEffect) -> void:
	status_effects.erase(buff.type)



func throw_healing_text(amount) -> void:
	if not amount is Big:
		amount = Big.new(amount)
	
	var text: String
	var health_plus_amount = Big.new(health.get_current()).a(amount)
	
	# this text is thrown before the heal is applied
	if health.is_full():
		var overhealing = Big.new(health_plus_amount).s(health.get_total()) #overhealing
		text = "(" + overhealing.toString() + ")"
	elif health_plus_amount.greater(health.get_total()):
		var until_full = Big.new(health.get_total()).s(health.get_current())
		var overhealing = Big.new(health_plus_amount).s(health.get_total()) #overhealing
		text = "+" + until_full.toString() + " (" + overhealing.toString() + ")"
	else:
		text = "+" + amount.toString()
	
	throw_finalized_text({
		"text": text,
		"color": Color(0, 1, 0),
	})


func throw_damage_text(amount) -> void:
	if not amount is Big:
		amount = Big.new(amount)
	
	var text: String = "-" + amount.toString()
	
	throw_finalized_text({
		"text": text,
		"color": Color(1, 0, 0),
	})


func throw_finalized_text(data: Dictionary) -> void:
	var parent_node = vico.get_node("%texts")
	gv.newOutputText(data, parent_node)
