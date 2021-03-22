extends MarginContainer


const src := {
	slot = preload("res://Prefabs/Inventory Item.tscn")
}
var cont := {}
var cont_keys: Array

var open := false

onready var gn_sc = get_node("v/sc")
onready var gn_open_label = get_node("v/h/open/Label")
onready var gn_list = get_node("v/sc/m/v")



func _ready() -> void:
	
	gv.connect("item_produced", self, "update_count")
	
	gn_sc.hide()
	
	setup()

func _on_open_pressed() -> void:
	
	if open:
		gn_sc.hide()
		gn_open_label.text = "Show"
		open = false
		return
	
	gn_sc.show()
	gn_open_label.text = "Hide"
	open = true


func setup():
	
	var i = 0
	for x in ["nearly dead", "corpse", "flayed corpse", "defiled dead", "flesh", "fur", "meat", "beast body", "exsanguinated beast"]:
		instance_item(x)
		if i % 2 == 0:
			cont[x].get_node("bg").hide()
		i += 1
	
	cont["nearly dead"].show()
	cont["corpse"].show()
	cont["flesh"].show()
	
	cont_keys = cont.keys()

func instance_item(key: String):
	
	cont[key] = src.slot.instance()
	gn_list.add_child(cont[key])
	cont[key].init(key)


func update_count(key):
	
	if not key in cont_keys:
		return
	
	cont[key].gn_count.text = gv.r[key].toString()
	
	if not cont[key].visible:
		cont[key].show()
