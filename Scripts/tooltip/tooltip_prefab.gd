extends MarginContainer

onready var rt = get_node("/root/Root")


var fps := 0.0
var fps_autobuy := 1.0
var price_flash := false
var price_flash_i := 0

var total_consumed := Big.new(0)

var type : String
var cont := {}

const src := {
	vbox = preload("res://Prefabs/tooltip/VBoxContainer.tscn"),
	autobuyer = preload("res://Prefabs/tooltip/autobuyer.tscn"),
	price = preload("res://Prefabs/tooltip/price.tscn"),
	taq_tip = preload("res://Prefabs/tooltip/QuestTip.tscn"),
	tip_lored_fuel = preload("res://Prefabs/tooltip/tip_lored_fuel.tscn"),
	cacodemon = preload("res://Prefabs/tooltip/Cacodemon Tooltip.tscn"),
}

var viewed_task : taq.Task

func _process(delta: float) -> void:
	r_tip(true)

func _physics_process(delta):
	
	price_flash()
	
	if fps_autobuy < 1.0:
		fps_autobuy += delta
	
	fps += delta
	if fps < rt.FPS: return
	fps -= rt.FPS
	
	r_tip()


func _input(event: InputEvent) -> void:
	
	if Input.is_key_pressed(KEY_K):
		define_key()


func _call(source : String, color := Color(1,1,1)) -> void:
	
	type = source
	
	if true:
		
		if "buy lored" in type:
			
			cont["vbox"] = src.vbox.instance()
			add_child(cont["vbox"])
			
			var f := type.split("lored ")[1]
			
			$bg.self_modulate = gv.g[f].color
			
			lored_buy_lored(f)
		
		elif "cac " in type:
			
			var f = int(type.split(" ")[1])
			cont["cac"] = src.cacodemon.instance()
			cont["cac"].setup(f)
			add_child(cont["cac"])
			
			$bg.self_modulate = gv.cac[f].color
		
		elif "taq " in type:
			
			var f := type.split("taq ")[1]
			
			cont["taq"] = src.taq_tip.instance()
			add_child(cont["taq"])
			
			if f in rt.quests.keys():
				cont["taq"].init(taq.quest)
				if taq.quest.icon.key in gv.g.keys():
					$bg.self_modulate = gv.g[taq.quest.icon.key].color
				else:
					$bg.self_modulate = Color(0.764706, 0.733333, 0.603922)
			else:
				cont["taq"].init(taq.task[stepify(float(type.split("taq ")[1]), 0.01)])
				$bg.self_modulate = gv.g[taq.task[stepify(float(type.split("taq ")[1]), 0.01)].icon.key].color
		
		elif "buy upgrade" in type:
			
			var f := type.split("upgrade ")[1]
			
			$bg.self_modulate = rt.r_lored_color(gv.up[f].main_lored_target)
			
			cont["tip up"] = get_parent().tip_upgrade.instance()
			add_child(cont["tip up"])
			
			cont["tip up"].init(f)
		
		elif "tip halt lored" in type:
			
			cont["halt"] = get_parent().tip_halt_prefab.instance()
			add_child(cont["halt"])
			
			var f := type.split("lored ")[1]
			
			cont["halt"].setup(f)
			
			$bg.self_modulate = gv.g[f].color
		
		elif "tip hold lored" in type:
			
			cont["hold"] = get_parent().tip_hold_prefab.instance()
			add_child(cont["hold"])
			
			var f := type.split("lored ")[1]
			
			cont["hold"].setup(f)
			
			$bg.self_modulate = gv.g[f].color
		
		elif "fuel lored" in type:
			
			var f := type.split("lored ")[1]
			
			cont["fuel"] = src.tip_lored_fuel.instance()
			add_child(cont["fuel"])
			cont["fuel"].setup(f)
		
		elif "mainstuff lored" in type:
			
			var f := type.split("lored ")[1]
			
			cont["lored stats"] = get_parent().tip_lored_prefab.instance()
			add_child(cont["lored stats"])
			cont["lored stats"].setup(f)
			
			$bg.self_modulate = gv.g[f].color
	
	rect_size = Vector2(0,0)
	
	r_tip()



func r_tip(move_tip := false) -> void:
	
	# text
	if true:
		
		if "buy lored" in type:
			
			#rect_size = cont["vbox"].rect_size
			
			var f := type.split("lored ")[1]
			
			for x in gv.g[f].cost:
				cont[x].get_node("HBoxContainer/VBoxContainer/val").text = gv.g[x].r.toString() + " / " + gv.g[f].cost[x].t.toString()
				if gv.g[x].r.isLargerThanOrEqualTo(gv.g[f].cost[x].t):
					cont[x].get_node("HBoxContainer/time").hide()
					cont[x].get_node("HBoxContainer/check").show()
				else:
					cont[x].get_node("HBoxContainer/check").hide()
					cont[x].get_node("HBoxContainer/time").show()
					cont[x].get_node("HBoxContainer/time").text = gv.time_remaining(x, gv.g[x].r, gv.g[f].cost[x].t, false)
			
			if "autobuyer" in cont.keys() and fps_autobuy >= 1:
				
				fps_autobuy -= 1
				
				if gv.g[f].autobuy():
					cont["autobuyer"].get_node("VBoxContainer/going_to_buy/check").pressed = true
				else:
					cont["autobuyer"].get_node("VBoxContainer/going_to_buy/check").pressed = false
				
				if cont["autobuyer"].get_node("VBoxContainer/set_key").visible:
					var set_key = cont["autobuyer"].get_node("VBoxContainer/set_key")
					set_key.get_node("HBoxContainer/check").pressed = gv.g[f].key_lored
		
		elif "tip up" in cont.keys():
			
			if cont["tip up"].rect_size != rect_size:
				rect_size = cont["tip up"].rect_size
				move_tip = true
			
			var f := type.split("upgrade ")[1]
			
			if cont["tip up"].get_node("VBoxContainer/effects").visible:
				match f:
					"I DRINK YOUR MILKSHAKE":
						if gv.up[f].active():
							cont["tip up"].get_node("VBoxContainer/effects/v/idym/val").text = gv.up[f].set_d.t.toString() + "x"
					"IT'S GROWIN ON ME", "IT'S SPREADIN ON ME":
						if gv.up["IT'S GROWIN ON ME"].active():
							cont["tip up"].get_node("VBoxContainer/effects/v/igom_iron/val").text = gv.g["iron"].modifier_from_growin_on_me.toString() + "x"
							cont["tip up"].get_node("VBoxContainer/effects/v/igom_cop/val").text = gv.g["cop"].modifier_from_growin_on_me.toString() + "x"
						if gv.up["IT'S SPREADIN ON ME"].active():
							cont["tip up"].get_node("VBoxContainer/effects/v/igom_irono/val").text = gv.g["irono"].modifier_from_growin_on_me.toString() + "x"
							cont["tip up"].get_node("VBoxContainer/effects/v/igom_copo/val").text = gv.g["copo"].modifier_from_growin_on_me.toString() + "x"
			
			# price
			if cont["tip up"].get_node("VBoxContainer/m").visible:
				
				for x in gv.up[f].cost:
					cont["tip up"].cont[x].get_node("HBoxContainer/VBoxContainer/val").text = gv.g[x].r.toString() + " / " + gv.up[f].cost[x].t.toString()
					if gv.g[x].r.isLargerThanOrEqualTo(gv.up[f].cost[x].t):
						cont["tip up"].cont[x].get_node("HBoxContainer/time").hide()
						cont["tip up"].cont[x].get_node("HBoxContainer/check").show()
					else:
						cont["tip up"].cont[x].get_node("HBoxContainer/check").hide()
						cont["tip up"].cont[x].get_node("HBoxContainer/time").show()
						cont["tip up"].cont[x].get_node("HBoxContainer/time").text = gv.time_remaining(x, gv.g[x].r, gv.up[f].cost[x].t, false)
	
	if rect_size != cont[cont.keys()[0]].rect_size:
		rect_size = cont[cont.keys()[0]].rect_size
		#move_tip = true
		set_process(true)
	
	if not move_tip: return
	set_process(false)
	
	# position
	if true:
		
		var win = get_viewport_rect().size
		
		var y_buffer := 60
		
		if "lored " in type:
			
			var f := type.split("lored ")[1]
			
			var pos : Vector2 = rt.get_node(rt.gnLOREDs).cont[f].rect_global_position
			var size : Vector2 = rt.get_node(rt.gnLOREDs).cont[f].rect_size
			
			pos.y -= 15
			
			y_buffer = 70
			
			if pos.x + size.x <= get_viewport_rect().size.x / 2:
				rect_position = Vector2(
					pos.x + size.x + 20,
					pos.y
				)
			else:
				rect_position = Vector2(
					pos.x - rect_size.x - 10,
					pos.y
				)
			
			if rect_position.y < y_buffer:
				rect_position.y = y_buffer
			elif rect_position.y > get_viewport_rect().size.y - rect_size.y - rt.get_node("m/v/bot").rect_size.y - 10:
				rect_position.y = get_viewport_rect().size.y - rect_size.y - rt.get_node("m/v/bot").rect_size.y - 10
				
			return
		
		elif "cac " in type:
			
			var pos : Vector2 = rt.get_node(rt.gnLOREDs).cont["cacodemons"].rect_global_position
			var size : Vector2 = rt.get_node(rt.gnLOREDs).cont["cacodemons"].rect_size
			
			pos.x += size.x + 10
			
			y_buffer = 70
			
			rect_position = Vector2(pos.x, pos.y)
			
			if rect_position.y < y_buffer:
				rect_position.y = y_buffer
			elif rect_position.y > get_viewport_rect().size.y - rect_size.y - rt.get_node("m/v/bot").rect_size.y - 10:
				rect_position.y = get_viewport_rect().size.y - rect_size.y - rt.get_node("m/v/bot").rect_size.y - 10
				
			return
		
		elif "taq " in type:
			
			var gntaq = rt.get_node(rt.gntaq).rect_global_position
			
			rect_position = Vector2(
				win.x - rect_size.x - 10,
				gntaq.y - rect_size.y - 10
			)
			return
		
		elif "upgrade" in type:
			
			rect_position = Vector2(
				rt.get_node(rt.gnupcon).rect_position.x + rt.get_node(rt.gnupcon).rect_size.x + 10,
				rt.get_node(rt.gnupcon).rect_position.y
			)
			
			return
		
		# lines below this took me 90 minutes to figure out. am i retarded?
		if rt.get_node("map").get_global_position().y + rect_position.y + rect_size.y > win.y:
			rect_position.y -= rt.get_node("map").get_global_position().y + rect_position.y + rect_size.y - win.y
		if rt.get_node("map").get_global_position().y + rect_position.y < y_buffer:
			rect_position.y -= rt.get_node("map").get_global_position().y + rect_position.y - y_buffer

func price_flash() -> void:
	
	if not price_flash:
		return
	
	var cost_dict := {}
	
	var f := ""
	if "buy lored" in type:
		f = type.split("lored ")[1]
		cost_dict = gv.g[f].cost
	elif "buy upgrade" in type:
		f = type.split("upgrade ")[1]
		cost_dict = gv.up[f].cost
	
	if price_flash_i == 0:
		for x in cost_dict:
			
			if gv.g[x].r.isLargerThanOrEqualTo(cost_dict[x].t):
				continue
			
			if "buy lored" in type:
				cont[x].get_node("flash0").show()
				cont[x].get_node("flash1").show()
			elif "buy upgrade" in type:
				cont["tip up"].cont[x].get_node("flash0").show()
				cont["tip up"].cont[x].get_node("flash1").show()
	
	price_flash_i += 1
	
	if price_flash_i == 4:
		for x in cost_dict:
			if "buy lored" in type:
				cont[x].get_node("flash1").hide()
			elif "buy upgrade" in type:
				cont["tip up"].cont[x].get_node("flash1").hide()
	
	if price_flash_i == 8:
		for x in cost_dict:
			if "buy lored" in type:
				cont[x].get_node("flash0").hide()
			elif "buy upgrade" in type:
				cont["tip up"].cont[x].get_node("flash0").hide()
		price_flash = false
		price_flash_i = 0

func autobuyer(_lored: String, _height: int) -> int:
	
	if not gv.up[gv.g[_lored].autobuyer_key].active():
		return 0
	
	cont["autobuyer"] = rt.prefab.tip_autobuyer.instance()
	add_child(cont["autobuyer"])
	cont["autobuyer"].rect_position.x += 5
	cont["autobuyer"].rect_position.y += _height + 10
	
	return cont["autobuyer"].init(_lored) + 20

func define_key() -> void:
	
	if not "autobuyer" in cont.keys():
		return
	if not gv.menu.option["tooltip_autobuyer"]:
		return
	
	var f := type.split("lored ")[1]
	
	if gv.g[f].key_lored:
		gv.g[f].key_lored = false
	else:
		gv.g[f].key_lored = true
	
	cont["autobuyer"].get_node("VBoxContainer/set_key/HBoxContainer/check").pressed = gv.g[f].key_lored





func _on_tip_mouse_entered():
	get_parent()._call("no")

func lored_buy_lored(key: String) -> void:
	
	var f = gv.g[key].cost
	var i := 0
	
	for x in f:
		
		var val := Big.new(f[x].t)
		
		cont[x] = src.price.instance()
		
		# texts
		cont[x].get_node("HBoxContainer/VBoxContainer/val").text = gv.g[x].r.toString() + " / " + val.toString()
		cont[x].get_node("HBoxContainer/VBoxContainer/type").text = gv.g[x].name
		
		# texture
		cont[x].get_node("HBoxContainer/icon/Sprite").texture = gv.sprite[x]
		
		# colors
		var color: Color = gv.g[x].color
		cont[x].get_node("HBoxContainer/VBoxContainer/val").add_color_override("font_color", color)
		cont[x].get_node("HBoxContainer/time").add_color_override("font_color", color)
		
		# visibility
		if gv.g[x].r.isLargerThan(val):
			cont[x].get_node("HBoxContainer/time").hide()
			cont[x].get_node("HBoxContainer/check").show()
		
		# alternate backgrounds
		if i % 2 == 1: cont[x].get_node("bg").show()
		
		cont["vbox"].get_node("vbox").add_child(cont[x])
		
		i += 1
	
	if not gv.menu.option["tooltip_autobuyer"] and gv.menu.option["tooltip_cost_only"]:
		return
	
	if not gv.up[gv.g[key].autobuyer_key].active():
		return
	
	cont["autobuyer"] = src.autobuyer.instance()
	cont["vbox"].get_node("vbox").add_child(cont["autobuyer"])
	cont["autobuyer"].init(key)
