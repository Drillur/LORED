extends MarginContainer



const flower_vico = preload("res://Prefabs/Flower/FlowerVico.tscn")

onready var flower_bed: GridContainer = $"%FlowerBed"

var flowers := {}



func _ready() -> void:
	
	if get_owner().name != "WITCH":
		queue_free()
		return
	
	hide()
	$"%bg".self_modulate = gv.COLORS["witch"]
	$"%border".self_modulate = gv.COLORS["witch"]
	setup_flowers()
	Flower.connect("flower_count_changed", self, "update_flower_count")



func setup_flowers():
	for flower in Flower.Type:
		if Flower.get_flower_tier(flower) == 0:
			continue
		flowers[flower] = flower_vico.instance()
		flowers[flower].setup(flower)
		flower_bed.add_child(flowers[flower])
	sort_children(flower_bed)



func update_flower_count(flower: String):
	if flower in flowers:
		flowers[flower].update_count()



func sort_children(parent_node: Node):
	
	var sorted_nodes: Array = parent_node.get_children()
	
	sorted_nodes.sort_custom(self, "sort")
	
	for node in parent_node.get_children():
		parent_node.remove_child(node)
	
	for node in sorted_nodes:
		parent_node.add_child(node)


static func sort(a: Node, b: Node):
	return a.name.naturalnocasecmp_to(b.name) < 0






