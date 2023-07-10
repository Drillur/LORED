class_name UpgradeContainer
extends MarginContainer

onready var rt = get_node("/root/Root")
onready var confirmReset = get_node("%confirmReset")
onready var reset = get_node("%reset")
onready var upgrades = get_node("%Upgrades")


var ready := false


#var fps := 0.0



var src := {
	upgrade_block = preload("res://Prefabs/upgrade/Upgrade Block.tscn"),
	hbox = preload("res://Prefabs/template/HBoxContainer 10 separation.tscn"),
}

var color := {
	gv.Tab.NORMAL: Color(0.733333, 0.458824, 0.031373),
	gv.Tab.MALIGNANT: Color(0.878431, 0.121569, 0.34902),
	gv.Tab.EXTRA_NORMAL: Color(0.47451, 0.870588, 0.694118),
	gv.Tab.RADIATIVE: Color(1, 0.541176, 0.541176),
	gv.Tab.RUNED_DIAL: Color(0.25098, 0.470588, 0.992157),
	gv.Tab.SPIRIT: Color(0.670588, 0.34902, 0.890196),
}

var cont := {}
var cont_flying_texts := {}

const gn := {
	category = "v/upgrades/v/%s/v",
}
const gnBack_arrow := "v/header/h/v/m/h/icon/Sprite"
const gnTitle_text := "v/header/h/v/m/h/text"
const gncount := "v/header/h/v/m/h/count"
const gnowned := "v/header/h/v/options/owned"
const gnunowned := "v/header/h/v/options/unowned"
const gnlocked := "v/header/h/v/options/locked"
const gnIcon := "v/header/h/icon/Sprite"



func _ready():
	
	ready = true
	gv.open_tab = gv.Tab.NORMAL
	
	gv.connect("upgrade_purchased", self, "upgrade_purchased")
	
	set_physics_process(false)
	set_process(false)

func procedure():
	
	# called at the bottom of the func that positions every upgrade
	
	var t = Timer.new()
	add_child(t)
	
	while shouldDisplayResetResource() and visible:
		
		setResetResourceText()
		
		t.start(1)
		yield(t, "timeout")
	
	t.start(1)
	yield(t, "timeout")
	t.queue_free()
	
	procedure()

func shouldDisplayResetResource() -> bool:
	if gv.open_tab == gv.Tab.MALIGNANT:
		if not gv.up["PROCEDURE"].active():
			return false
		if gv.resource[gv.Resource.MALIGNANCY].less(gv.up["ROUTINE"].cost[gv.Resource.MALIGNANCY].t):
			return false
		return true
	return false

func setupResetResource():
	
	var _color: Color
	var resource: int
	
	if gv.open_tab == gv.Tab.MALIGNANT:
		resource = gv.Resource.TUMORS
	
	_color = gv.COLORS[gv.shorthandByResource[resource]]
	
	get_node("%resetResource/amount").self_modulate = _color
	get_node("%resetResource/name").self_modulate = _color
	
	get_node("%resetResource/name").text = gv.resourceName[resource] + ")"
	
	get_node("%resetResource/icon/Sprite").texture = gv.sprite[gv.shorthandByResource[resource]]
	get_node("%resetResource/icon/Sprite/shadow").texture = get_node("%resetResource/icon/Sprite").texture
	
	setResetResourceText()
	
	get_node("%resetResource").show()

func setResetResourceText():
	match gv.open_tab:
		gv.Tab.MALIGNANT:
			var routine = rt.get_node(rt.gnupcon).cont["ROUTINE"].get_routine_info()[0].toString()
			get_node("%resetResource/amount").text = "(+" + routine



func init() -> void:
	
	upgrades.setup()
	
	set_gnreset()
	
	var t = Timer.new()
	add_child(t)
	t.start(2.5)
	yield(t, "timeout")
	t.queue_free()
	
	procedure()



func _on_mouse_exited() -> void:
	rt.get_node("global_tip")._call("no")


func _on_reset_mouse_entered() -> void:
	
	if gv.open_tab == -1:
		return
	
	var reset_name := get_reset_name().to_upper() 
	
	rt.get_node("global_tip")._call("buy upgrade " + reset_name)


func get_reset_name() -> String:
	
	if gv.open_tab == gv.Tab.MALIGNANT:
		return "Metastasize"
	if gv.open_tab == gv.Tab.RADIATIVE:
		return "Chemotherapy"
	
	print_debug("The reset button should not display when gv.open_tab is ", gv.Tab.keys()[gv.open_tab])
	return "oops"


var confirmed := false
func _on_reset_pressed() -> void:
	
	if confirmed:
		var stage: int
		match gv.open_tab:
			gv.Tab.NORMAL, gv.Tab.MALIGNANT:
				stage = gv.Tab.S1
			gv.Tab.EXTRA_NORMAL, gv.Tab.RADIATIVE:
				stage = gv.Tab.S2
			gv.Tab.RUNED_DIAL, gv.Tab.SPIRIT:
				stage = gv.Tab.S3
		rt.reset(stage)
		confirmed_false()
		return
	
	confirmed = true
	confirmReset.show()
	
	var t = Timer.new()
	add_child(t)
	t.start(1)
	yield(t, "timeout")
	t.queue_free()
	
	if confirmed:
		confirmed_false()


func confirmed_false():
	confirmed = false
	set_gnreset()



func r_setup_setup():
	
	if not gv.open_tab in [gv.Tab.MALIGNANT, gv.Tab.RADIATIVE, gv.Tab.SPIRIT, gv.Tab.s4m]:
		return
	
	set_gnreset()
	
	if shouldDisplayResetResource():
		setupResetResource()
	else:
		get_node("%resetResource").hide()

func set_gnreset():
	
	confirmReset.hide()
	
	var mod_color: Color
	
	if gv.open_tab == gv.Tab.MALIGNANT:
		mod_color = gv.COLORS["malig"]
	elif gv.open_tab == gv.Tab.RADIATIVE:
		mod_color = gv.COLORS["tum"]
	
	get_node("%reset/Button").modulate = mod_color
	get_node("%resetIcon").modulate = mod_color


func select_tab(tab: int):
	if upgrades.get_tab() == tab:
		hide()
	else:
		upgrades.select_tab(tab)





func get_proper_name(path: String) -> String:
	
	match int(path):
		gv.Tab.RADIATIVE:
			return "Radiative"
		gv.Tab.EXTRA_NORMAL:
			return "Extra-normal"
		gv.Tab.MALIGNANT:
			return "Malignant"
		_:
			return "Normal"


func clear_tip_n_stuff():
	
	if not is_instance_valid(rt.get_node("global_tip").tip):
		return
	
	if "upgrade" in rt.get_node("global_tip").tip.type:
		var key = rt.get_node("global_tip").tip.type.split("upgrade ")[1]
		if key in cont.keys():
			cont[key]._on_Button_mouse_exited()
	
	rt.get_node("global_tip")._call("no")



func r_update(which := []):
	
	if which == []:
		for x in gv.Tab.values():
			if x == gv.Tab.S1:
				break
			which.append(x)
	
	for x in which:
		upgrades.update_upgrades(x)


func upgrade_purchased(key: String, routine := []):
	
	# catches
	if cont[key].tab != gv.open_tab:
		return
	if not visible:
		return
	
	
	# flying texts below
	
	if not gv.option["flying_numbers"]:
		return
	
	var rollx :int= randi() % 20 - 10 + int(get_global_mouse_position().x - rect_position.x)
	var rolly :int= randi() % 20 - 10 + int(get_global_mouse_position().y - rect_position.y)
	
	var i := 0
	
	if key == "ROUTINE" and gv.up["PROCEDURE"].active():
		
		cont_flying_texts["(upgrade purchased flying text)" + str(i)] = rt.prefab["dtext"].instance()
		cont_flying_texts["(upgrade purchased flying text)" + str(i)].init(false, -50, "+ " + routine[0].toString(), gv.sprite["tum"], gv.COLORS["tum"])
		cont_flying_texts["(upgrade purchased flying text)" + str(i)].rect_position = Vector2(
			rollx, 
			rolly
		)
		$flying_texts.add_child(cont_flying_texts["(upgrade purchased flying text)" + str(i)])
		
		i += 1
	
	var t = Timer.new()
	add_child(t)
	for x in gv.up[key].cost:
		
		# dtext
		cont_flying_texts["(upgrade purchased flying text)" + str(i)] = rt.prefab["dtext"].instance()
		
		var _text = "- " + gv.up[key].cost[x].t.toString()
		if key == "ROUTINE":
			_text = "- " + routine[1].toString()
		
		var icon = gv.sprite[gv.shorthandByResource[x]]
		
		cont_flying_texts["(upgrade purchased flying text)" + str(i)].init({"text": _text, "icon": icon, "color": gv.resourceColor[x], "life": 50})
		
		if i == 0:
			cont_flying_texts["(upgrade purchased flying text)" + str(i)].rect_position = Vector2(
				rollx,
				rolly
			)
		else:
			
			for v in i:
				if not "(upgrade purchased flying text)" + str(v) in cont_flying_texts.keys():
					return
				cont_flying_texts["(upgrade purchased flying text)" + str(v)].rect_position.y -= 7
			
			cont_flying_texts["(upgrade purchased flying text)" + str(i)].rect_position = Vector2(
				cont_flying_texts["(upgrade purchased flying text)" + str(i-1)].rect_position.x,
				cont_flying_texts["(upgrade purchased flying text)" + str(i-1)].rect_position.y + cont_flying_texts["(upgrade purchased flying text)" + str(i)].rect_size.y
			)
		
		$flying_texts.add_child(cont_flying_texts["(upgrade purchased flying text)" + str(i)])
		
		i += 1
		
		t.start(0.02)
		yield(t, "timeout")
	
	t.queue_free()


func unlock_tab(tab: int):
	upgrades.unlock_tab(tab)
	
	for upgrade in gv.list.upgrade[str(tab)]:
		cont[upgrade] = upgrades.get_node("%" + upgrade)


func tab_changed(tab: int) -> void:
	if not ready:
		yield(self, "ready")
	gv.open_tab = tab
	reset.visible = tab in [gv.Tab.MALIGNANT, gv.Tab.RADIATIVE, gv.Tab.SPIRIT] #s4
	r_setup_setup()

