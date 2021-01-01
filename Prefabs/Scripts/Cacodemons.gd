extends MarginContainer


onready var rt = get_node("/root/Root")



var cont := {}
var src := {
	cacodemon = preload("res://Prefabs/lored/Cacodemon.tscn"),
	ft = preload("res://Prefabs/dtext.tscn"),
}
const gnpapa := "v/sc/m/v"
const gn_top := "v/m top"
const gn_cs := "v/m top/consumed spirits"
const gn_total_cs := gn_cs + "/total"

var fps := {
	"total cs": FPS.new(0.25, false),
}


func _ready() -> void:
	
	get_node(gn_top).hide()
	
	gv.connect("cac_consumed", self, "cac_consumed")



func setup() -> void:
	
	gv.connect("cac_slain", self, "cac_slain")
	gv.connect("cac_leveled_up", self, "update_leveled_up_cacodemon")
	gv.connect("cac_fps", self, "cac_fps")
	
	instance_cacodemon(0)
	
	print(cont.keys())
	if gv.s3_time:
		cont[0].activate() #note remove later, make it activate() based on quest or in e_load()



func _physics_process(delta: float) -> void:
	
	fps()



func instance_cacodemon(key: int, activate := false):
	
	cont[key] = src.cacodemon.instance()
	get_node(gnpapa).add_child(cont[key])
	cont[key].setup(key)
	
	if activate:
		cont[key].activate()



func cac_consumed():
	if not get_node(gn_top).visible:
		return
	fps["total cs"].set = true

func fps():
	
	for x in fps:
		
		if not fps[x].process(get_physics_process_delta_time()):
			continue
		
		match x:
			"total cs":
				r_total_cs()

func r_total_cs():
	
	var total_cs = Big.new(0)
	
	for x in gv.cac:
		if not x.active:
			break
		total_cs.a(x.consumed_spirits)
	
	get_node(gn_total_cs).text = total_cs.toString()


func update_leveled_up_cacodemon(key: int):
	cont[key].level_up()

func cac_fps(fps_key: String, key: int):
	
	cont[key].fps[fps_key].set = true


func cac_slain(key: int):
	
	# flying text for spirit gained
	if cont[key].on_screen():
		
		cont["spirit gained"] = src.ft.instance()
		cont["spirit gained"].init(
			false,
			-60, # extra long life (by 1 sec)
			gv.cac[key].initial_host_cs.toString(),
			gv.sprite["spirit"],
			gv.color["spirit"]
		)
		cont["spirit gained"].rect_position = Vector2(
			cont[key].rect_global_position.x + int(rand_range(0, cont[key].rect_size.x)),
			cont[key].rect_global_position.y + int(rand_range(0, cont[key].rect_size.y))
		)
		
		rt.get_node("m/lored texts").add_child(cont["spirit gained"])
	
	var previous_pos = cont[key].get_index()
	
	cont[key].queue_free()
	cont.erase(key)
	
	gv.cacodemons -= 1
	gv.cac[key] = Cacodemon.new(key)
	
	instance_cacodemon(key, true)




func _on_summon_pressed() -> void:
	
	if gv.cacodemons == 100:
		return
	
	instance_cacodemon(gv.cacodemons, true)


func _on_mouse_exited() -> void:
	rt.get_node("global_tip")._call("no")


func _on_summon_mouse_entered() -> void:
	rt.get_node("global_tip")._call("summon cac")
