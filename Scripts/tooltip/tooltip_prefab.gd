extends MarginContainer

onready var rt = get_node("/root/Root")


var fps := 0.0
var fps_autobuy := 1.0
var price_flash := false
var price_flash_i := 0

var total_consumed := Big.new(0)

var type : String
var content := {}

var src := {
	vbox = preload("res://Prefabs/tooltip/VBoxContainer.tscn"),
	autobuyer = preload("res://Prefabs/tooltip/autobuyer.tscn"),
	price = preload("res://Prefabs/tooltip/price.tscn"),
	taq_tip = preload("res://Prefabs/tooltip/QuestTip.tscn"),
	tip_lored_fuel = preload("res://Prefabs/tooltip/tip_lored_fuel.tscn"),
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
			
			content["vbox"] = src.vbox.instance()
			add_child(content["vbox"])
			
			var f := type.split("lored ")[1]
			
			$bg.self_modulate = gv.g[f].color
			
			lored_buy_lored(f)
		
		elif "taq " in type:
			
			var f := type.split("taq ")[1]
			
			content["taq"] = src.taq_tip.instance()
			add_child(content["taq"])
			
			if f in rt.tasks.keys():
				content["taq"].init(taq.quest)
				if taq.quest.icon.key in gv.g.keys():
					$bg.self_modulate = gv.g[taq.quest.icon.key].color
				else:
					$bg.self_modulate = Color(0.764706, 0.733333, 0.603922)
			else:
				content["taq"].init(taq.task[stepify(float(type.split("taq ")[1]), 0.01)])
				$bg.self_modulate = gv.g[taq.task[stepify(float(type.split("taq ")[1]), 0.01)].icon.key].color
		
		elif "buy upgrade" in type:
			
			var f := type.split("upgrade ")[1]
			
			$bg.self_modulate = rt.r_lored_color(gv.up[f].main_lored_target)
			
			content["tip up"] = get_parent().tip_upgrade.instance()
			add_child(content["tip up"])
			
			content["tip up"].init(f)
		
		elif "tip halt lored" in type:
			
			content["halt"] = get_parent().tip_halt_prefab.instance()
			add_child(content["halt"])
			
			var f := type.split("lored ")[1]
			
			content["halt"].setup(f)
			
			$bg.self_modulate = gv.g[f].color
		
		elif "tip hold lored" in type:
			
			content["hold"] = get_parent().tip_hold_prefab.instance()
			add_child(content["hold"])
			
			var f := type.split("lored ")[1]
			
			content["hold"].setup(f)
			
			$bg.self_modulate = gv.g[f].color
		
		elif "fuel lored" in type:
			
			var f := type.split("lored ")[1]
			
			content["fuel"] = src.tip_lored_fuel.instance()
			add_child(content["fuel"])
			content["fuel"].setup(f)
		
		elif "mainstuff lored" in type:
			
			var f := type.split("lored ")[1]
			
			content["lored stats"] = get_parent().tip_lored_prefab.instance()
			add_child(content["lored stats"])
			content["lored stats"].setup(f)
			
			$bg.self_modulate = gv.g[f].color
	
	rect_size = Vector2(0,0)
	
	r_tip()



func r_tip(move_tip := false) -> void:
	
	# text
	if true:
		
		if "buy lored" in type:
			
			#rect_size = content["vbox"].rect_size
			
			var f := type.split("lored ")[1]
			
			for x in gv.g[f].cost:
				content[x].get_node("HBoxContainer/VBoxContainer/val").text = gv.g[x].r.toString() + " / " + gv.g[f].cost[x].t.toString()
				if gv.g[x].r.isLargerThanOrEqualTo(gv.g[f].cost[x].t):
					content[x].get_node("HBoxContainer/time").hide()
					content[x].get_node("HBoxContainer/check").show()
				else:
					content[x].get_node("HBoxContainer/check").hide()
					content[x].get_node("HBoxContainer/time").show()
					content[x].get_node("HBoxContainer/time").text = gv.time_remaining(x, gv.g[x].r, gv.g[f].cost[x].t, false)
			
			if "autobuyer" in content.keys() and fps_autobuy >= 1:
				
				fps_autobuy -= 1
				
				if gv.g[f].autobuy():
					content["autobuyer"].get_node("VBoxContainer/going_to_buy/check").pressed = true
				else:
					content["autobuyer"].get_node("VBoxContainer/going_to_buy/check").pressed = false
				
				if content["autobuyer"].get_node("VBoxContainer/set_key").visible:
					var set_key = content["autobuyer"].get_node("VBoxContainer/set_key")
					set_key.get_node("HBoxContainer/check").pressed = gv.g[f].key_lored
		
		elif "tip up" in content.keys():
			
			if content["tip up"].rect_size != rect_size:
				rect_size = content["tip up"].rect_size
				move_tip = true
			
			var f := type.split("upgrade ")[1]
			
			if content["tip up"].get_node("VBoxContainer/effects").visible:
				match f:
					"I DRINK YOUR MILKSHAKE":
						if gv.up[f].active():
							content["tip up"].get_node("VBoxContainer/effects/v/idym/val").text = gv.up[f].set_d.t.toString() + "x"
					"IT'S GROWIN ON ME", "IT'S SPREADIN ON ME":
						if gv.up["IT'S GROWIN ON ME"].active():
							content["tip up"].get_node("VBoxContainer/effects/v/igom_iron/val").text = gv.g["iron"].modifier_from_growin_on_me.toString() + "x"
							content["tip up"].get_node("VBoxContainer/effects/v/igom_cop/val").text = gv.g["cop"].modifier_from_growin_on_me.toString() + "x"
						if gv.up["IT'S SPREADIN ON ME"].active():
							content["tip up"].get_node("VBoxContainer/effects/v/igom_irono/val").text = gv.g["irono"].modifier_from_growin_on_me.toString() + "x"
							content["tip up"].get_node("VBoxContainer/effects/v/igom_copo/val").text = gv.g["copo"].modifier_from_growin_on_me.toString() + "x"
			
			# price
			if content["tip up"].get_node("VBoxContainer/m").visible:
				
				for x in gv.up[f].cost:
					content["tip up"].cont[x].get_node("HBoxContainer/VBoxContainer/val").text = gv.g[x].r.toString() + " / " + gv.up[f].cost[x].t.toString()
					if gv.g[x].r.isLargerThanOrEqualTo(gv.up[f].cost[x].t):
						content["tip up"].cont[x].get_node("HBoxContainer/time").hide()
						content["tip up"].cont[x].get_node("HBoxContainer/check").show()
					else:
						content["tip up"].cont[x].get_node("HBoxContainer/check").hide()
						content["tip up"].cont[x].get_node("HBoxContainer/time").show()
						content["tip up"].cont[x].get_node("HBoxContainer/time").text = gv.time_remaining(x, gv.g[x].r, gv.up[f].cost[x].t, false)
	
	if rect_size != content[content.keys()[0]].rect_size:
		rect_size = content[content.keys()[0]].rect_size
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
#			var posy = pos.y
#			if pos.y > get_viewport_rect().size.y / 2 - rt.get_node("map").get_global_position().y:
#				posy = pos.y + size.y - rect_size.y + 13
#
#			if rect_position.y < y_buffer:
#				rect_position.y -= rect_position.y - y_buffer
#			if rect_position.y + rect_size.y > gtaq.y + 10:
#				rect_position.y -= rect_position.y + rect_size.y - gtaq.y + 10
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
				content[x].get_node("flash0").show()
				content[x].get_node("flash1").show()
			elif "buy upgrade" in type:
				content["tip up"].cont[x].get_node("flash0").show()
				content["tip up"].cont[x].get_node("flash1").show()
	
	price_flash_i += 1
	
	if price_flash_i == 4:
		for x in cost_dict:
			if "buy lored" in type:
				content[x].get_node("flash1").hide()
			elif "buy upgrade" in type:
				content["tip up"].cont[x].get_node("flash1").hide()
	
	if price_flash_i == 8:
		for x in cost_dict:
			if "buy lored" in type:
				content[x].get_node("flash0").hide()
			elif "buy upgrade" in type:
				content["tip up"].cont[x].get_node("flash0").hide()
		price_flash = false
		price_flash_i = 0

func autobuyer(_lored: String, _height: int) -> int:
	
	if not gv.up[gv.g[_lored].autobuyer_key].active():
		return 0
	
	content["autobuyer"] = rt.prefab.tip_autobuyer.instance()
	add_child(content["autobuyer"])
	content["autobuyer"].rect_position.x += 5
	content["autobuyer"].rect_position.y += _height + 10
	
	return content["autobuyer"].init(_lored) + 20

func define_key() -> void:
	
	if not "autobuyer" in content.keys():
		return
	if not gv.menu.option["tooltip_autobuyer"]:
		return
	
	var f := type.split("lored ")[1]
	
	if gv.g[f].key_lored:
		gv.g[f].key_lored = false
	else:
		gv.g[f].key_lored = true
	
	content["autobuyer"].get_node("VBoxContainer/set_key/HBoxContainer/check").pressed = gv.g[f].key_lored





func _on_tip_mouse_entered():
	get_parent()._call("no")

func lored_buy_lored(key: String) -> void:
	
	var f = gv.g[key].cost
	var i := 0
	
	for x in f:
		
		var val := Big.new(f[x].t)
		
		content[x] = src.price.instance()
		
		# texts
		content[x].get_node("HBoxContainer/VBoxContainer/val").text = gv.g[x].r.toString() + " / " + val.toString()
		content[x].get_node("HBoxContainer/VBoxContainer/type").text = gv.g[x].name
		
		# texture
		content[x].get_node("HBoxContainer/icon/Sprite").texture = gv.sprite[x]
		
		# colors
		var color: Color = gv.g[x].color
		content[x].get_node("HBoxContainer/VBoxContainer/val").add_color_override("font_color", color)
		content[x].get_node("HBoxContainer/time").add_color_override("font_color", color)
		
		# visibility
		if gv.g[x].r.isLargerThan(val):
			content[x].get_node("HBoxContainer/time").hide()
			content[x].get_node("HBoxContainer/check").show()
		
		# alternate backgrounds
		if i % 2 == 1: content[x].get_node("bg").show()
		
		content["vbox"].get_node("vbox").add_child(content[x])
		
		i += 1
	
	if not gv.menu.option["tooltip_autobuyer"] and gv.menu.option["tooltip_cost_only"]:
		return
	
	if not gv.up[gv.g[key].autobuyer_key].active():
		return
	
	content["autobuyer"] = src.autobuyer.instance()
	content["vbox"].get_node("vbox").add_child(content["autobuyer"])
	content["autobuyer"].init(key)
