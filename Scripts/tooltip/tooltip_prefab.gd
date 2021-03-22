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
	item_tip = preload("res://Prefabs/tooltip/Item.tscn"),
	unholy_bodies_tip = preload("res://Prefabs/tooltip/Unholy Bodies Tip.tscn"),
}

var viewed_task : Task

func _process(delta: float) -> void:
	r_tip(true)

func _physics_process(delta):
	
	price_flash()
	
	if fps_autobuy < 1.0:
		fps_autobuy += delta
	
	fps += delta
	if fps < gv.fps: return
	fps -= gv.fps
	
	r_tip()


func _input(event: InputEvent) -> void:
	
	if Input.is_key_pressed(KEY_K):
		define_key()


func _call(source : String, other: Dictionary) -> void:
	
	type = source
	
	if true:
		
		if "buy lored" in type:
			
			var f := type.split("lored ")[1]
			
			$bg.self_modulate = gv.g[f].color
			
			lored_buy_lored(f)
		
		elif "buy smart lored" in type:
			var key := type.split("lored ")[1]
			$bg.self_modulate = gv.g[key].color
			
			var quest_key := key.capitalize()
			
			cont["taq"] = src.taq_tip.instance()
			add_child(cont["taq"])
			
			cont["taq"].init(rt.quests[quest_key])
		
		elif "unholy bodies tip" in type:
			
			cont[type] = src.unholy_bodies_tip.instance()
			add_child(cont[type])
			$bg.self_modulate = gv.COLORS["necro"]
		
		elif "item:" in type:
			
			var item_key = type.split(":")[1]
			item_tip(item_key)
			$bg.self_modulate = gv.COLORS[item_key]
		
		elif "cac " in type:
			
			grow_horizontal = Control.GROW_DIRECTION_END
			
			var f = int(type.split(" ")[1])
			cont["cac"] = src.cacodemon.instance()
			cont["cac"].setup(f)
			add_child(cont["cac"])
			
			$bg.self_modulate = gv.cac[f].color
		
		elif "summon cac" in type:
			
			grow_horizontal = Control.GROW_DIRECTION_END
			
			add_cost("cac", gv.cac_cost)
			
			$bg.self_modulate = Color(1,0,0)
		
		elif "taq " in type:
			
			cont["taq"] = src.taq_tip.instance()
			add_child(cont["taq"])
			
			if "quest" in type:
				
				var quest := type.split("taq quest ")[1]
				
				cont["taq"].init(taq.quest)
				$bg.self_modulate = taq.quest.color
			
			else:
				var index = type.split(" ")[1]
				cont["taq"].init(taq.task[index])
				$bg.self_modulate = taq.task[index].color
		
		elif "buy upgrade" in type:
			
			var f := type.split("upgrade ")[1]
			
			$bg.self_modulate = gv.COLORS[gv.up[f].icon]
			
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
			
			if "autobuyer" in cont.keys() and fps_autobuy >= 1:
				
				var f := type.split("lored ")[1]
				
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
							cont["tip up"].get_node("VBoxContainer/effects/v/idym/val").text = "+" + gv.up["I DRINK YOUR MILKSHAKE"].effects[0].effect.print()
					"IT'S GROWIN ON ME", "IT'S SPREADIN ON ME":
						if gv.up["IT'S GROWIN ON ME"].active():
							cont["tip up"].get_node("VBoxContainer/effects/v/igom_iron/val").text = gv.up["IT'S GROWIN ON ME"].effects[0].effect.print() + "x"
							cont["tip up"].get_node("VBoxContainer/effects/v/igom_cop/val").text = gv.up["IT'S GROWIN ON ME"].effects[1].effect.print() + "x"
						if gv.up["IT'S SPREADIN ON ME"].active():
							cont["tip up"].get_node("VBoxContainer/effects/v/igom_irono/val").text = gv.up["IT'S SPREADIN ON ME"].effects[0].effect.print() + "x"
							cont["tip up"].get_node("VBoxContainer/effects/v/igom_copo/val").text = gv.up["IT'S SPREADIN ON ME"].effects[1].effect.print() + "x"
	
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
			
			if pos.x + size.x <= win.x / 2:
				grow_horizontal = Control.GROW_DIRECTION_END
				rect_global_position = Vector2(
					pos.x + size.x + 20,
					pos.y
				)
			else:
				grow_horizontal = Control.GROW_DIRECTION_BEGIN
				rect_global_position = Vector2(
					pos.x - rect_size.x - 10,
					pos.y
				)
			
			if rect_position.y < y_buffer:
				rect_position.y = y_buffer
			elif rect_position.y > win.y - rect_size.y - rt.get_node("m/v/bot").rect_size.y - 10:
				rect_position.y = win.y - rect_size.y - rt.get_node("m/v/bot").rect_size.y - 10
			
			return
		
		elif "unholy bodies tip" in type:
			var bla = rt.get_node(rt.gnLOREDs).cont["necro"]
			rect_position = Vector2(
				bla.rect_global_position.x + bla.rect_size.x + 10,
				bla.rect_global_position.y
			)
		elif "item:" in type:
			var bla = rt.get_node("m/v/LORED List/sc/v/s3/v/Inventory")
			rect_position = Vector2(
				bla.rect_global_position.x - rect_size.x - 10,
				bla.rect_global_position.y + bla.rect_size.y - rect_size.y
			)
		elif "cac" in type:
			
			var pos : Vector2 = rt.get_node(rt.gnLOREDs).cont["cacodemons"].rect_global_position
			var size : Vector2 = rt.get_node(rt.gnLOREDs).cont["cacodemons"].rect_size
			
			pos.x += size.x + 10
			
			y_buffer = 70
			
			rect_position = Vector2(pos.x, pos.y)
			
			if rect_position.y < y_buffer:
				rect_position.y = y_buffer
			elif rect_position.y > win.y - rect_size.y - rt.get_node("m/v/bot").rect_size.y - 10:
				rect_position.y = win.y - rect_size.y - rt.get_node("m/v/bot").rect_size.y - 10
				
			return
		
		elif "taq " in type:
			
			var gntaq = rt.get_node(rt.gntaq).rect_global_position
			
			rect_position = Vector2(
				win.x - rect_size.x - 10,
				gntaq.y - rect_size.y - 20
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
			
			if gv.r[x].greater_equal(cost_dict[x].t):
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
	
	if not gv.g[_lored].autobuy:
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

func item_tip(key: String):
	
	cont[key] = src.item_tip.instance()
	cont[key].init(key)
	add_child(cont[key])




func _on_tip_mouse_entered():
	get_parent()._call("no")

func lored_buy_lored(key: String) -> void:
	
	add_cost(key, gv.g[key].cost)
	
	if not gv.menu.option["tooltip_autobuyer"] and gv.menu.option["tooltip_cost_only"]:
		return
	
	if not gv.g[key].autobuy:
		return
	
	cont["autobuyer"] = src.autobuyer.instance()
	cont["vbox"].get_node("vbox").add_child(cont["autobuyer"])
	cont["autobuyer"].init(key)

func add_cost(key: String, cost: Dictionary):
	
	cont["vbox"] = src.vbox.instance()
	add_child(cont["vbox"])
	
	var i := 0
	for x in cost:
		
		cont[x] = src.price.instance()
		
		var _name = ""
		var _color = ""
		if key == "cac":
			_name = x.capitalize()
			_color = Color(1,0,0)
		cont[x].setup(key, x, _name, _color)
		
		
		# alternate backgrounds
		if i % 2 == 1: cont[x].get_node("bg").show()
		
		cont["vbox"].get_node("vbox").add_child(cont[x])
		
		i += 1
