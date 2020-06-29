extends MarginContainer

onready var rt = get_node("/root/Root")
var prefab := {}

class Slot:
	var halt: bool
	var hold: bool
	func update(shit:Array):
		halt = shit[0]
		hold = shit[1]
	func _init(shit:Array):
		update(shit)
var test: Slot
var list := {}
var content := {}

func _ready():
	
	hide()
	
	# work
	if true:
		
		prefab["held_slot"] = preload("res://Prefabs/held/held_slot.tscn")
	
	r_display()

func w_update(x:String) -> void:
	
	var shit := [gv.g[x].halt, gv.g[x].hold]
	
	if not shit[0] and not shit[1]:
		if x in list.keys():
			content[x].queue_free()
			content.erase(x)
			list.erase(x)
		r_display()
		return
	
	if not x in list.keys():
		list[x] = Slot.new(shit)
	else:
		list[x].update(shit)
	
	# add slot
	if x in content.keys():
		content[x].w_update(shit)
	else:
		content[x] = prefab["held_slot"].instance()
		get_node("VBoxContainer/CenterContainer/VBoxContainer/individual/CenterContainer/VBoxContainer").add_child(content[x])
		content[x].init(shit, x)
	
	r_display()

func r_display() -> void:
	
	# desc flair and main meat
	if content.size() == 0:
		$VBoxContainer/desc.show()
		$VBoxContainer/CenterContainer.hide()
	elif content.size() > 0:
		$VBoxContainer/desc.hide()
		$VBoxContainer/CenterContainer.show()
	
	# apply to all
	if content.size() == 1:
		$VBoxContainer/CenterContainer/VBoxContainer/all.hide()
	if content.size() > 1:
		all_check()
		$VBoxContainer/CenterContainer/VBoxContainer/all.show()
	
	self.rect_size = Vector2(10,10)

func all_check() -> void:
	
	var halt: bool
	var hold: bool
	
	for x in list:
		if list[x].halt: halt = true
		if list[x].hold: hold = true
	
	if halt: $VBoxContainer/CenterContainer/VBoxContainer/all/HBoxContainer/halt.show()
	else: $VBoxContainer/CenterContainer/VBoxContainer/all/HBoxContainer/halt.hide()
	
	if hold: $VBoxContainer/CenterContainer/VBoxContainer/all/HBoxContainer/hold.show()
	else: $VBoxContainer/CenterContainer/VBoxContainer/all/HBoxContainer/hold.hide()


func _on_halt_pressed():
	var dupe = list.duplicate()
	for x in dupe:
		if not dupe[x].halt: continue
		gv.g[x].halt = false
		rt.get_node("map/loreds").lored[x].r_update_halt(gv.g[x].halt)
		w_update(x)
func _on_hold_pressed():
	var dupe = list.duplicate()
	for x in dupe:
		if not dupe[x].hold: continue
		gv.g[x].hold = false
		rt.get_node("map/loreds").lored[x].r_update_hold(gv.g[x].hold)
		w_update(x)

func _on_button_down():
	rt.get_node("map").status = "no"


func _on_mouse_entered():
	if content.size() <= 3: return
	rt.get_node("map").mouse_in = "held_window"
func _on_mouse_exited():
	# do not uncomment: if content.size() <= 3: return
	rt.get_node("map").mouse_in = "no"
