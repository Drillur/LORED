extends MarginContainer

onready var rt = get_node("/root/Root")


var fps := 0.0

var total_consumed := Big.new(0)

var type : String
var cont = 0

const src := {
	vbox = preload("res://Prefabs/tooltip/PriceContainer.tscn"),
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
		
		if "lored level up" == type:
			
			cont = gv.SRC["tooltip/level up"].instance()
			cont.setup(other["lored"])
			add_child(cont)
			
			temp["lored"] = other["lored"]
			$bg.self_modulate = other["color"]
		
		elif "lored export" == type:
			
			cont = gv.SRC["tooltip/lored export"].instance()
			cont.setup(other["lored"])
			add_child(cont)
			
			temp["lored"] = other["lored"]
			$bg.self_modulate = lv.lored[other["lored"]].color
		
		elif "lored asleep" == type:
			
			cont = gv.SRC["tooltip/lored asleep"].instance()
			cont.setup(other["lored"])
			add_child(cont)
			
			temp["lored"] = other["lored"]
			$bg.self_modulate = lv.lored[other["lored"]].color
		
		elif "lored jobs" == type:
			
			cont = gv.SRC["tooltip/lored jobs"].instance()
			cont.setup(other["lored"])
			add_child(cont)
			
			temp["lored"] = other["lored"]
			$bg.self_modulate = lv.lored[other["lored"]].color
		
		elif "lored info" == type:
			
			cont = gv.SRC["tooltip/lored info"].instance()
			cont.setup(other["type"])
			add_child(cont)
			
			temp["lored"] = other["type"]
			$bg.self_modulate = lv.lored[other["type"]].color
		
		elif "lored alert" == type:
			
			cont = gv.SRC["tooltip/lored alert"].instance()
			cont.setup(other["type"], other["alert"])
			add_child(cont)
			
			temp["lored"] = other["type"]
			$bg.self_modulate = lv.lored[other["type"]].color
		
		elif "wish tooltip" == type:
			
			cont = gv.SRC["tooltip/wish"].instance()
			cont.init(other["wish"])
			add_child(cont)
			$bg.modulate = other["wish"].color
			temp["wish vico"] = other["wish"].vico[0] if other["inLog"] else other["wish"].vico[1]
			temp["inLog"] = other["inLog"]
		
#		elif "taq " in type:
#
#			cont["taq"] = src.taq_tip.instance()
#			add_child(cont["taq"])
#
#			if "quest" in type:
#
#				#var quest := type.split("taq quest ")[1]
#
#				if " main" in type:
#					cont["taq"].init(taq.main_quest)
#					$bg.self_modulate = taq.main_quest.color
#
#			else:
#
#				cont["taq"].init(other["task"])
#				$bg.self_modulate = other["task"].color
		
		elif "buy upgrade" in type:
			
			var f := type.split("upgrade ")[1]
			
			$bg.self_modulate = gv.COLORS[gv.up[f].icon]
			
			cont = gv.SRC["tooltip/upgrade"].instance()
			add_child(cont)
			
			cont.init(f)
		
		elif "tip halt lored" in type:
			
			cont = get_parent().tip_halt_prefab.instance()
			add_child(cont)
			
			var f := type.split("lored ")[1]
			
			cont.setup(f)
			
			$bg.self_modulate = gv.g[f].color
		
		elif "tip hold lored" in type:
			
			cont = get_parent().tip_hold_prefab.instance()
			add_child(cont)
			
			var f := type.split("lored ")[1]
			
			cont.setup(f)
			
			$bg.self_modulate = gv.g[f].color
		
		elif "fuel lored" in type:
			
			var f := type.split("lored ")[1]
			
			cont = src.tip_lored_fuel.instance()
			add_child(cont)
			cont.setup(f)
			
			$bg.self_modulate = gv.g[f].color
		
		elif "mainstuff lored" in type:
			
			var f := type.split("lored ")[1]
			
			cont = gv.SRC["tooltip/LORED"].instance()
			cont.init(f)
			add_child(cont)
			
			$bg.self_modulate = gv.g[f].color
	
	rect_size = Vector2(0,0)
	
	r_tip()



func r_tip(move_tip := false) -> void:
	
	if rect_size != cont.rect_size:
		rect_size = cont.rect_size
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
		
		elif type in ["lored export", "lored level up", "lored info", "lored alert", "lored jobs", "lored asleep"]:
			
			var f = temp["lored"]
			
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
			
			if temp["inLog"]:
				
				rect_position = Vector2(
					rt.get_node("%WishLog").rect_position.x + rt.get_node("%WishLog").rect_size.x + 10,
					rt.get_node("%WishLog").rect_position.y
				)
			
			else:
				
				var pos : Vector2 = temp["wish vico"].rect_global_position
				
				grow_horizontal = Control.GROW_DIRECTION_END
				
				pos.x += temp["wish vico"].rect_size.x + 8
				pos.y += temp["wish vico"].rect_size.y - rect_size.y
				
				rect_position = pos
			
			return
		
		elif "taq " in type:
			
			var gntaq = rt.get_node(rt.gntaq).rect_global_position
			
			rect_position = Vector2(
				win.x / rt.scale.x - rect_size.x - 10,
				gntaq.y / rt.scale.x - rect_size.y - 20
			)
			return
		
		if rect_position.y + rect_size.y > win.y:
			rect_position.y -= rect_position.y + rect_size.y - win.y
		if rect_position.y < y_buffer:
			rect_position.y -= rect_position.y - y_buffer
#
#		if rt.get_node("map").get_global_position().y + rect_position.y + rect_size.y > win.y:
#			rect_position.y -= rt.get_node("map").get_global_position().y + rect_position.y + rect_size.y - win.y
#		if rt.get_node("map").get_global_position().y + rect_position.y < y_buffer:
#			rect_position.y -= rt.get_node("map").get_global_position().y + rect_position.y - y_buffer

func price_flash() -> void:
	
	var cost_dict := {}
	
	if "lored level up" == type:
		cont.flash()

func item_tip(key: String):
	
	cont = src.item_tip.instance()
	cont.init(key)
	add_child(cont)




func _on_tip_mouse_entered():
	get_parent()._call("no")


func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				if cont.has_method("scrollUp"):
					cont.scrollUp()
			elif event.button_index == BUTTON_WHEEL_DOWN:
				if cont.has_method("scrollDown"):
					cont.scrollDown()
	pass
