extends MarginContainer

onready var rt = get_node("/root/Root")


var fps := 0.0

var total_consumed := Big.new(0)

var type : String
var cont := {}

const src := {
	vbox = preload("res://Prefabs/tooltip/PriceContainer.tscn"),
	taq_tip = preload("res://Prefabs/tooltip/QuestTip.tscn"),
	tip_lored_fuel = preload("res://Prefabs/tooltip/tip_lored_fuel.tscn"),
}

func _process(_delta: float) -> void:
	r_tip(true)

func _physics_process(delta):
	
	fps += delta
	if fps < gv.fps: return
	fps -= gv.fps
	
	r_tip()

var temp: Dictionary




func _call(source : String, other: Dictionary) -> void:
	
	type = source
	
	if true:
		
		if "buy lored" in type:
			
			var f := type.split("lored ")[1]
			
			$bg.self_modulate = gv.g[f].color
			
			lored_buy_lored(f)
		
		elif "wish tooltip" == type:
			
			cont[type] = gv.SRC["tooltip/wish"].instance()
			cont[type].init(other["wish"])
			add_child(cont[type])
			$bg.modulate = other["wish"].color
			temp["wish vico"] = other["wish"].vico
		
		elif "offline boost" == type:
			
			cont[type] = gv.SRC["tooltip/offline boost"].instance()
			cont[type].init()
			add_child(cont[type])
			$bg.self_modulate = Color(1, 0.796078, 0)
		
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
				
				#var quest := type.split("taq quest ")[1]
				
				if " main" in type:
					cont["taq"].init(taq.main_quest)
					$bg.self_modulate = taq.main_quest.color
			
			else:
				
				cont["taq"].init(other["task"])
				$bg.self_modulate = other["task"].color
		
		elif "buy upgrade" in type:
			
			var f := type.split("upgrade ")[1]
			
			$bg.self_modulate = gv.COLORS[gv.up[f].icon]
			
			cont["tip up"] = gv.SRC["tooltip/upgrade"].instance()
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
			
			cont["whatever"] = gv.SRC["tooltip/LORED"].instance()
			cont["whatever"].init(f)
			add_child(cont["whatever"])
			
#			cont["lored stats"] = get_parent().tip_lored_prefab.instance()
#			add_child(cont["lored stats"])
#			cont["lored stats"].setup(f)
			
			$bg.self_modulate = gv.g[f].color
	
	rect_size = Vector2(0,0)
	
	r_tip()



func r_tip(move_tip := false) -> void:
	
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
		
		
		if "upgrade" in type:
			
			rect_position = Vector2(
				rt.get_node(rt.gnupcon).rect_position.x + rt.get_node(rt.gnupcon).rect_size.x + 10,
				rt.get_node(rt.gnupcon).rect_position.y
			)
			
			return
		
		elif "lored " in type:
			
			var f := type.split("lored ")[1]
			
			var pos : Vector2 = rt.get_node(rt.gnLOREDs).cont[f].rect_global_position
			var size : Vector2 = rt.get_node(rt.gnLOREDs).cont[f].rect_size * rt.scale
			
			pos.y -= 15
			
			y_buffer = 70
			
			if pos.x + size.x <= win.x / 2:
				grow_horizontal = Control.GROW_DIRECTION_END
				rect_global_position = Vector2(
					pos.x / rt.scale.x + size.x + 20,
					pos.y / rt.scale.y
				)
			else:
				grow_horizontal = Control.GROW_DIRECTION_BEGIN
				rect_global_position = Vector2(
					pos.x / rt.scale.x - rect_size.x - 10,
					pos.y / rt.scale.y
				)
			
			if rect_position.y < y_buffer:
				rect_position.y = y_buffer
			elif rect_position.y > win.y - rect_size.y - rt.get_node("m/v/bot").rect_size.y - 10:
				rect_position.y = win.y - rect_size.y - rt.get_node("m/v/bot").rect_size.y - 10
			
			return
		
		elif "wish tooltip" == type:
			
			var pos : Vector2 = temp["wish vico"].rect_global_position
			
			grow_horizontal = Control.GROW_DIRECTION_END
			
			pos.y -= rect_size.y + 8
			
			rect_position = pos
			
			return
		
		elif "offline boost" == type:
			rect_position = Vector2(
				win.x / rt.scale.x - rect_size.x - 10,
				rt.get_node("m/v/top").rect_size.y / rt.scale.x + 10
			)
		elif "unholy bodies tip" in type:
			var bla = rt.get_node(rt.gnLOREDs).cont["necro"]
			rect_position = Vector2(
				bla.rect_global_position.x + bla.rect_size.x + 10,
				bla.rect_global_position.y
			)
		elif "item:" in type:
			var bla = rt.get_node("m/v/LORED Manager/sc/v/s3/v/Inventory")
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
				win.x / rt.scale.x - rect_size.x - 10,
				gntaq.y / rt.scale.x - rect_size.y - 20
			)
			return
		
		# lines below this took me 90 minutes to figure out. am i retarded?
		if rt.get_node("map").get_global_position().y + rect_position.y + rect_size.y > win.y:
			rect_position.y -= rt.get_node("map").get_global_position().y + rect_position.y + rect_size.y - win.y
		if rt.get_node("map").get_global_position().y + rect_position.y < y_buffer:
			rect_position.y -= rt.get_node("map").get_global_position().y + rect_position.y - y_buffer

func price_flash() -> void:
	
	var cost_dict := {}
	
	var f := ""
	if "buy lored" in type:
		f = type.split("lored ")[1]
		cost_dict = gv.g[f].cost
	elif "buy upgrade" in type:
		f = type.split("upgrade ")[1]
		cost_dict = gv.up[f].cost
	
	for x in cost_dict:
		
		if gv.r[x].greater_equal(cost_dict[x].t):
			continue
		
		if "buy lored" in type:
			cont["vbox"].cont[x].flash()
		elif "buy upgrade" in type:
			cont["tip up"].price.cont[x].flash()

func autobuyer(_lored: String, _height: int) -> int:
	
	if not gv.g[_lored].autobuy:
		return 0
	
	cont["autobuyer"] = rt.prefab.tip_autobuyer.instance()
	add_child(cont["autobuyer"])
	cont["autobuyer"].rect_position.x += 5
	cont["autobuyer"].rect_position.y += _height + 10
	
	return cont["autobuyer"].init(_lored) + 20

func item_tip(key: String):
	
	cont[key] = src.item_tip.instance()
	cont[key].init(key)
	add_child(cont[key])




func _on_tip_mouse_entered():
	get_parent()._call("no")

func lored_buy_lored(key: String) -> void:
	
	add_cost(key, gv.g[key].cost)
	
	if not gv.g[key].autobuy:
		return
	
	if not gv.menu.option["tooltip_autobuyer"] and gv.menu.option["tooltip_cost_only"]:
		return
	
	cont["autobuyer"] = gv.SRC["tooltip/autobuyer"].instance()
	cont["vbox"].get_node("v").add_child(cont["autobuyer"])
	cont["autobuyer"].setup(key)

func add_cost(key: String, cost: Dictionary):
	
	cont["vbox"] = src.vbox.instance()
	add_child(cont["vbox"])
	cont["vbox"].setup(key, cost)
