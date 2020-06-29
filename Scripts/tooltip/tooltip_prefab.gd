extends Panel

onready var rt = get_node("/root/Root")


var fps := 0.0
var price_flash := false
var price_flash_i := 0

var total_consumed : float

var type : String
var content := {}

var src := {
	vbox = preload("res://Prefabs/tooltip/VBoxContainer.tscn"),
	autobuyer = preload("res://Prefabs/tooltip/autobuyer.tscn"),
	price = preload("res://Prefabs/tooltip/price.tscn"),
	taq_tip = preload("res://Prefabs/tooltip/QuestTip.tscn"),
}

var viewed_task : taq.Task


func _physics_process(delta):
	
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
			
			self_modulate = rt.r_lored_color(f)
			
			lored_buy_lored(f)
			
			rect_size = content["vbox"].rect_size
		
		elif "task " in type:
			
			rect_size.x = 300
			
			var f := stepify(float(type.split("task ")[1]), 0.01)
			
			viewed_task = taq.task[f]
			
			content["task"] = get_parent().task_tip.instance()
			add_child(content["task"])
			
			rect_size.y = content["task"].init(viewed_task)
			
			for x in content["task"].step:
				content["task"].step[x].rect_size.x = 290
				if " produced" in x:
					content["task"].step[x].get_node("bar").self_modulate = rt.r_lored_color(rt.w_name_to_short(x.split(" produced")[0]))
			for x in viewed_task.resource_reward:
				content["task"].rr[x].rect_size.x = 290
			
			var x = rt.w_name_to_short(viewed_task.step.keys()[0].split(" produced")[0])
			var col = rt.r_lored_color(x)
			
			self_modulate = col
			content["task"].get_node("reward_flair/bg").self_modulate = col
		
		elif "quest " in type:
			
			rect_size.x = 300
			
			var f := type.split("quest ")[1]
			viewed_task = taq.quest
			
			content["task"] = get_parent().task_tip.instance()
			add_child(content["task"])
			
			rect_size.y = content["task"].init(viewed_task)
			
			for x in content["task"].step:
				content["task"].step[x].rect_size.x = 290
				if " produced" in x:
					content["task"].step[x].get_node("bar").self_modulate = rt.r_lored_color(rt.w_name_to_short(x.split(" produced")[0]))
				else:
					content["task"].step[x].get_node("bar").self_modulate = viewed_task.color
			for x in viewed_task.resource_reward:
				content["task"].rr[x].rect_size.x = 290
			
			var col = viewed_task.color
			self_modulate = col
			content["task"].get_node("reward_flair/bg").self_modulate = col
		
		elif "taq " in type:
			
			var f := type.split("taq ")[1]
			
			content["taq"] = src.taq_tip.instance()
			add_child(content["taq"])
			
			if f in rt.tasks.keys():
				content["taq"].init(taq.quest)
				self_modulate = rt.r_lored_color(taq.quest.icon.key)
			else:
				content["taq"].init(taq.task[stepify(float(type.split("taq ")[1]), 0.01)])
				self_modulate = rt.r_lored_color(taq.task[stepify(float(type.split("taq ")[1]), 0.01)].icon.key)
			
			rect_size = content["taq"].rect_size
		
		elif "buy upgrade" in type:
			
			var f := type.split("upgrade ")[1]
			
			self_modulate = rt.r_lored_color(gv.up[f].main_lored_target)
			
			content["tip up"] = get_parent().tip_upgrade.instance()
			add_child(content["tip up"])
			
			content["tip up"].init(f)
			
			rect_size = content["tip up"].rect_size
		
		elif "tip halt lored" in type:
			
			content["halt"] = get_parent().tip_halt_prefab.instance()
			add_child(content["halt"])
			
			self_modulate = rt.r_lored_color(type.split("lored ")[1])
			
			rect_size = content["halt"].rect_size
		
		elif "tip hold lored" in type:
			
			var f := type.split("lored ")[1]
			
			self_modulate = rt.r_lored_color(f)
			
			content["hold"] = get_parent().tip_hold_prefab.instance()
			add_child(content["hold"])
			var blah = content["hold"].init(gv.g[f].used_by, rt.r_lored_color(f))
			
			rect_size = content["hold"].rect_size
			rect_size.y += blah
		
		elif "fuel lored" in type:
			
			var f := type.split("lored ")[1]
			
			content["fuel"] = get_parent().fuel_prefab.instance()
			add_child(content["fuel"])
			
			var fuel_source = "coal" if "bur" in gv.g[f].type else "jo"
			
			content["fuel"].init(fuel_source, f)
			self_modulate = rt.r_lored_color(fuel_source)
			
			rect_size = Vector2(content["fuel"].rect_size.x + 10, content["fuel"].rect_size.y + 7)
		
		elif "mainstuff lored" in type:
			
			var f := type.split("lored ")[1]
			
			self_modulate = rt.r_lored_color(f)
			
			if gv.g[f].active:
				
				total_consumed = 0.0
				
				# consumption
				for x in gv.g:
					
					if not gv.g[x].active or gv.g[x].halt:
						continue
					
					for v in gv.g[x].b:
						if f == v:
							total_consumed += gv.g[x].d.t * 60 / gv.g[x].speed.t
					
					if ("coal" in type and "bur " in gv.g[x].type) or ("jo" in type and "ele " in gv.g[x].type):
						total_consumed += gv.g[x].fc.t * 60
						if gv.g[x].f.f < gv.g[x].f.t - gv.g[x].fc.t * 3:
							total_consumed += gv.g[x].fc.t * 60
				
				content["lored stats"] = get_parent().tip_lored_prefab.instance()
				add_child(content["lored stats"])
				
				# burn info
				var b_array := []
				for x in gv.g[f].b:
					if not "lored stats b" in content.keys(): content["lored stats b"] = []
					content["lored stats b"].append(x)
					b_array.append(x)
				
				content["lored stats"].init(f, false)
				
				if content["lored stats"].get_node("input").visible:
					content["lored stats"].rect_size.y += content["lored stats"].input_height_in_tooltip
				
				rect_size = Vector2(content["lored stats"].rect_size.x, content["lored stats"].rect_size.y -1)
			
			else:
				
				content["inactive stats"] = get_parent().tip_lored_prefab.instance()
				add_child(content["inactive stats"])
				content["inactive stats"].init(f, true)
				
				rect_size = Vector2(content["inactive stats"].rect_size.x, 85)
	
	r_tip(true)



func r_tip(move_tip := false) -> void:
	
	# unique
	if true:
		
		price_flash()
	
	# text
	if true:
		
		if "buy lored" in type:
			
			rect_size = content["vbox"].rect_size
			
			var f := type.split("lored ")[1]
			
			for x in gv.g[f].cost:
				content[x].get_node("HBoxContainer/VBoxContainer/val").text = fval.f(gv.g[x].r) + " / " + fval.f(gv.g[f].cost[x].t)
				if gv.g[x].r >= gv.g[f].cost[x].t:
					content[x].get_node("HBoxContainer/time").hide()
					content[x].get_node("HBoxContainer/check").show()
				else:
					content[x].get_node("HBoxContainer/check").hide()
					content[x].get_node("HBoxContainer/time").show()
					content[x].get_node("HBoxContainer/time").text = w_get_time_remaining(x, gv.g[x].r, gv.g[f].cost[x].t)
			
			if "autobuyer" in content.keys():
				
				if rt.get_node("map/loreds").lored[f].autobuy():
					content["autobuyer"].get_node("VBoxContainer/going_to_buy/check").pressed = true
				else:
					content["autobuyer"].get_node("VBoxContainer/going_to_buy/check").pressed = false
				
				if content["autobuyer"].get_node("VBoxContainer/set_key").visible:
					var set_key = content["autobuyer"].get_node("VBoxContainer/set_key")
					set_key.get_node("HBoxContainer/check").pressed = gv.g[f].key_lored
		
		elif "task" in content.keys():
			
			for x in viewed_task.step:
				content["task"].step[x].text = x + " (" + fval.f(viewed_task.step[x].f) + " / " + fval.f(viewed_task.step[x].b) + ")"
				content["task"].step[x].get_node("bar").value = viewed_task.step[x].f / viewed_task.step[x].b * 100
			#content["task"].get_node("desc").text = content["task"].my_task.desc
		
		elif "taq " in type:
			
			if content["taq"].rect_size != rect_size:
				rect_size = content["taq"].rect_size
				move_tip = true
		
		elif "tip up" in content.keys():
			
			if content["tip up"].rect_size != rect_size:
				rect_size = content["tip up"].rect_size
				move_tip = true
			
			var f := type.split("upgrade ")[1]
			
			if content["tip up"].get_node("VBoxContainer/effects").visible:
				match f:
					"I DRINK YOUR MILKSHAKE":
						if gv.up[f].active():
							content["tip up"].get_node("VBoxContainer/effects/idym/text").text = "Boost: " + fval.f(gv.up[f].set_d.t)
					"IT'S GROWIN ON ME", "IT'S SPREADIN ON ME":
						if gv.up["IT'S GROWIN ON ME"].active():
							content["tip up"].get_node("VBoxContainer/effects/igom_iron/text").text = "Iron LORED boost: " + fval.f(gv.g["iron"].modifier_from_growin_on_me)
							content["tip up"].get_node("VBoxContainer/effects/igom_cop/text").text = "Copper LORED boost: " + fval.f(gv.g["cop"].modifier_from_growin_on_me)
						if gv.up["IT'S SPREADIN ON ME"].active():
							content["tip up"].get_node("VBoxContainer/effects/igom_irono/text").text = "Iron Ore LORED boost: " + fval.f(gv.g["irono"].modifier_from_growin_on_me)
							content["tip up"].get_node("VBoxContainer/effects/igom_copo/text").text = "Copper Ore LORED boost: " + fval.f(gv.g["copo"].modifier_from_growin_on_me)
			
			# price
			if content["tip up"].get_node("VBoxContainer/m").visible:
				
				for x in gv.up[f].cost:
					content["tip up"].cont[x].get_node("HBoxContainer/VBoxContainer/val").text = fval.f(gv.g[x].r) + " / " + fval.f(gv.up[f].cost[x].t)
					if gv.g[x].r >= gv.up[f].cost[x].t:
						content["tip up"].cont[x].get_node("HBoxContainer/time").hide()
						content["tip up"].cont[x].get_node("HBoxContainer/check").show()
					else:
						content["tip up"].cont[x].get_node("HBoxContainer/check").hide()
						content["tip up"].cont[x].get_node("HBoxContainer/time").show()
						content["tip up"].cont[x].get_node("HBoxContainer/time").text = w_get_time_remaining(x, gv.g[x].r, gv.up[f].cost[x].t)
		
		elif "halt" in content.keys():
			
			var f := type.split("lored ")[1]
			
			if not gv.g[f].halt:
				content["halt"].get_node("desc").text = "Halts this LORED's activity.\n\nCurrently working."
			else:
				content["halt"].get_node("desc").text = "Halts this LORED's activity.\n\nCurrently halted."
		
		elif "hold" in content.keys():
			
			var f := type.split("lored ")[1]
			var hold_desc = "Allows the use of this resource."
			
			if gv.g[f].hold:
				content["hold"].get_node("desc").text = hold_desc + "\n\nCurrently holding resources."
			else:
				content["hold"].get_node("desc").text = hold_desc + "\n\nCurrently, resources may be used."
			
			var i := 0
			for x in content["hold"].input_text:
				var g = gv.g[f].used_by[i]
				var per_sec : String = " (" + fval.f(gv.g[g].d.t / gv.g[g].speed.t * 60 * gv.g[g].b[f].t) + "/s)"
				content["hold"].input_text[x].text = fval.f(gv.g[g].b[f].t * gv.g[g].d.t) + per_sec
				i += 1
		
		elif "lored stats" in content.keys():
			
			var f : String = type.split("lored ")[1]
			
			var lv_out :float= pow(2, gv.g[f].level - 1)
			var out_mod :float= gv.g[f].output_modifier.t / lv_out
			
			content["lored stats"].get_node("crit").text = fval.f(gv.g[f].crit.t) + "% crit"
			content["lored stats"].get_node("haste").text = fval.f(gv.g[f].speed.b / gv.g[f].speed.t) + "x haste"
			content["lored stats"].get_node("out").text = "(" + fval.f(lv_out) + " * " + fval.f(out_mod) + ")x output"
			
			if content["lored stats"].get_node("input").visible:
				var i := 0
				for x in content["lored stats"].input_text:
					var per_sec : String = " (" + fval.f(gv.g[f].d.t / gv.g[f].speed.t * 60 * gv.g[f].b.values()[i].t) + "/s)"
					content["lored stats"].input_text[x].text = fval.f(gv.g[f].b.values()[i].t * gv.g[f].d.t) + per_sec
					i += 1
	
	if not move_tip: return
	
	# position
	if true:
		
		var win = get_viewport_rect().size
		
		var y_buffer := 60
		
		if "ss_slot" in type:
			
			if rt.get_node("ifs/subject_selector").caller_lored == "no":
				rect_position = rt.get_node("ifs").ifs["coal"].position + rt.get_node("ifs").position
			else:
				rect_position = rt.get_node("ifs/subject_selector").rect_position + rt.get_node("ifs").position
			
			rect_position.x -= rect_size.x + 12
			rect_position.y -= 4
			
			return
		
		elif "lored " in type:
			
			var f := type.split("lored ")[1]
			
			var pos : Vector2 = rt.get_node("map/loreds").lored[f].rect_position
			var size : Vector2 = rt.get_node("map/loreds").lored[f].rect_size
			
			if rt.menu.option["resource_bar"]:
				y_buffer = 90
			else:
				y_buffer = 10
			
			var posy = pos.y - 4
			if pos.y > 300 - rt.get_node("map").get_global_position().y:
				posy = pos.y + size.y - rect_size.y + 13
			
			if abs(pos.x + size.x) <= 400 - rt.get_node("map").get_global_position().x:
				rect_position = Vector2(pos.x + size.x  + 64 + 15 + ((win.x / 2) - 400), posy + ((win.y / 2) - 300))
			else:
				rect_position = Vector2(pos.x - rect_size.x - 15 + ((win.x / 2) - 400), posy + ((win.y / 2) - 300))
		
		elif "task " in type or "quest " in type or "taq " in type:
			
			var _taq = rt.get_node("misc/taq")
			rect_position = Vector2(_taq.rect_position.x + _taq.rect_size.x - rect_size.x, _taq.rect_position.y - rect_size.y - 10)
			return
		
		elif "upgrade" in type:
			
			if "reset" in gv.up[type.split("upgrade ")[1]].type:
				rect_position = Vector2(rt.get_node("map").get_global_position().x + (289 - (289 / 2) + (106 / 2)), 62 - rt.get_node("map").get_global_position().y)
				return
			
			var f := type.split("upgrade ")[1]
			
			var pos : Vector2 = rt.upc[gv.up[f].path][f].rect_position
			var size : Vector2 = rt.upc[gv.up[f].path][f].rect_size
			
			if pos.x + size.x > 400:
				#y_buffer = 60
				rect_position = Vector2(pos.x - rect_size.x - 15 + ((win.x / 2) - 400), pos.y + size.y / 2 - (rect_size.y / 2) - 6 + ((win.y / 2) - 300))
			else:
				rect_position = Vector2(pos.x + size.x + 15 + ((win.x / 2) - 400), pos.y + size.y / 2 - (rect_size.y / 2) - 6 + ((win.y / 2) - 300))
		
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
			
			if gv.g[x].r >= cost_dict[x].t:
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
	
	if not gv.up[rt.get_node("map/loreds").lored[_lored].my_autobuyer].active():
		return 0
	
	content["autobuyer"] = rt.prefab.tip_autobuyer.instance()
	add_child(content["autobuyer"])
	content["autobuyer"].rect_position.x += 5
	content["autobuyer"].rect_position.y += _height + 10
	
	return content["autobuyer"].init(_lored) + 20

func define_key() -> void:
	
	if not "autobuyer" in content.keys():
		return
	if not rt.menu.option["tooltip_autobuyer"]:
		return
	
	var f := type.split("lored ")[1]
	
	if gv.g[f].key_lored:
		gv.g[f].key_lored = false
	else:
		gv.g[f].key_lored = true
	
	content["autobuyer"].get_node("VBoxContainer/set_key/HBoxContainer/check").pressed = gv.g[f].key_lored


func w_get_time_remaining(gg: String, _f, _t) -> String:
	
	var per_sec = gv.g[gg].net(true)
	
	if not gv.g[gg].hold:
		for x in gv.g[gg].used_by:
			if gv.g[x].halt or not gv.g[x].active:
				continue
			var less = gv.g[x].d.t * 60 / gv.g[x].speed.t * gv.g[x].b[gg].t
			per_sec -= less
	
	
	if per_sec == 0.0:
		return "!?"
	elif per_sec < 0.0:
		return "-"
	
	var remaining_amount : float = _t - _f
	var intermittent := 1.0
	if not gv.g[gg].progress.t == 0.0:
		intermittent = gv.g[gg].d.t * (gv.g[gg].progress.f / gv.g[gg].progress.t)
	var final :float= (remaining_amount - intermittent) / per_sec / 1
	if final > 3600 * 24 * 365:
		var years:= int(final /60 / 60 / 24 / 365)
		if years > 1:
			return ">1y"
		return fval.f(years) + "y"
	if final > 3600 * 24:
		var days:= int(final /60 / 60 / 24)
		return str(days) + "d"
	if final > 3600:
		var hours := int(final / 60 / 60)
		return str(hours) + "h"
	if final > 60:
		var minutes := int(final / 60)
		#var sec := int(final - (minutes * 60))
		return str(minutes) + "m"# " + str(sec) + "s"
	if final >= 1:
		return String(int(final)) + "s"
	if not _f >= _t:
		return "!"
	
	return ""


func _on_tip_mouse_entered():
	get_parent()._call("no")

func lored_buy_lored(key: String) -> void:
	
	var f = gv.g[key].cost
	var i := 0
	
	for x in f:
		
		var val: float = f[x].t
		
		content[x] = src.price.instance()
		
		# texts
		content[x].get_node("HBoxContainer/VBoxContainer/val").text = fval.f(gv.g[x].r) + " / " + fval.f(val)
		content[x].get_node("HBoxContainer/VBoxContainer/type").text = gv.g[x].name
		
		# texture
		content[x].get_node("HBoxContainer/icon/Sprite").texture = gv.sprite[x]
		
		# colors
		var color: Color = rt.r_lored_color(x)
		content[x].get_node("HBoxContainer/VBoxContainer/val").add_color_override("font_color", color)
		content[x].get_node("HBoxContainer/time").add_color_override("font_color", color)
		
		# visibility
		if gv.g[x].r > val:
			content[x].get_node("HBoxContainer/time").hide()
			content[x].get_node("HBoxContainer/check").show()
		
		# alternate backgrounds
		if i % 2 == 1: content[x].get_node("bg").show()
		
		content["vbox"].get_node("vbox").add_child(content[x])
		
		i += 1
	
	
	var autobuyer = rt.get_node("map/loreds").lored[key].my_autobuyer
	
	if not gv.up[autobuyer].active():
		return
	
	content["autobuyer"] = src.autobuyer.instance()
	content["vbox"].get_node("vbox").add_child(content["autobuyer"])
	content["autobuyer"].init(key)
