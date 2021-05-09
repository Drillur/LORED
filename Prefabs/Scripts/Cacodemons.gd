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
onready var gn_total_cs := get_node("v/m top/consumed spirits/total")

var can_attach_to := false


func _ready() -> void:
	
	get_node(gn_top).hide()
	set_physics_process(false)
	
	gv.connect("cac_slain", self, "cac_slain")
	gv.connect("cac_leveled_up", self, "update_leveled_up_cacodemon")
	gv.connect("cac_fps", self, "cac_fps")
	
	if gv.cacodemons == 10:
		get_node("v/m bot").hide()





func instance_cacodemon(key: int, activate := false):
	
	cont[key] = src.cacodemon.instance()
	get_node(gnpapa).add_child(cont[key])
	cont[key].setup(key)
	
	if activate:
		cont[key].activate()
	
	if not can_attach_to and key == 0:
		cont[0].get_node("v/Attach").hide()
	
	if gv.cacodemons == 5:
		get_node(gn_top).show()
		calculate_total_cs()


func calculate_total_cs():
	
	while true:
		
		var total_cs = Big.new(0)
		
		for x in gv.cac:
			if not x.active:
				break
			total_cs.a(x.consumed_spirits)
		
		gn_total_cs.text = total_cs.toString()
		
		var t = Timer.new()
		add_child(t)
		t.start(1)
		yield(t, "timeout")
		t.queue_free()

func update_leveled_up_cacodemon(key: int):
	cont[key].r_level_up()

func cac_fps(fps_key: String, key: int):
	
	cont[key].fps[fps_key].set = true


func cac_slain(key: int):
	
	# flying text for spirit gained
	if cont[key].on_screen():
		
		cont["spirit gained"] = src.ft.instance()
		cont["spirit gained"].init(
			false,
			-60, # extra long life (by 1 sec)
			gv.cac[key].cs_peak.toString(),
			gv.sprite["spirit"],
			gv.COLORS["spirit"]
		)
		cont["spirit gained"].rect_position = Vector2(
			cont[key].rect_global_position.x + int(rand_range(0, cont[key].rect_size.x)),
			cont[key].rect_global_position.y + int(rand_range(0, cont[key].rect_size.y))
		)
		
		rt.get_node("m/lored texts").add_child(cont["spirit gained"])
	
	#var previous_pos = cont[key].get_index()
	
	cont[key].queue_free()
	cont.erase(key)
	
	gv.cacodemons -= 1
	gv.cac[key] = Cacodemon.new(key)
	
	instance_cacodemon(key, true)



func _on_summon_pressed() -> void:
	
	if gv.cacodemons == 10:
		get_node("v/m bot").hide()
		return
	
	for c in gv.cac_cost:
		if gv.r[c].less(gv.cac_cost[c]):
			return
	
	for c in gv.cac_cost:
		gv.r[c].s(gv.cac_cost[c])
	
	gv.increase_cac_cost()
	
	instance_cacodemon(gv.cacodemons, true)


func _on_mouse_exited() -> void:
	rt.get_node("global_tip")._call("no")


func _on_summon_mouse_entered() -> void:
	rt.get_node("global_tip")._call("summon cac")


