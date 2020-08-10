extends MarginContainer



var cont := {}
var src := {
	cacodemon = preload("res://Prefabs/lored/Cacodemon.tscn"),
}
var gnpapa := "sc/m/v"



func setup() -> void:
	
	gv.connect("cac_leveled_up", self, "update_leveled_up_cacodemon")
	gv.connect("cac_xp_gained", self, "cac_xp_gained")
	
	for x in gv.cac.size():
		
		cont[x] = src.cacodemon.instance()
		cont[x].setup(x)
		get_node(gnpapa).add_child(cont[x])
		#cont[x].activate()
	
	#cont[0].activate() #note remove later, make it activate() based on quest or in e_load()


func update_leveled_up_cacodemon(key: int):
	cont[key].level_up()

func cac_xp_gained(key: int):
	cont[key].fps["xp"].set = true
