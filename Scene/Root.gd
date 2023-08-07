extends MarginContainer



@onready var tooltip_parent = %Tooltip
@onready var lored_container = $"LORED Container" as LOREDContainer
@onready var upgrade_container = $"Upgrade Container" as UpgradeContainer
@onready var random_wishes = %"Random Wishes"
@onready var main_wishes = %"Main Wishes"
@onready var control = $Control



func _ready():
	gv.tooltip_parent = tooltip_parent
	gv.texts_parent = control
	lv.lored_container = lored_container
	up.upgrade_container = upgrade_container
	wi.main_wish_container = main_wishes
	wi.random_wish_container = random_wishes
	
	if SaveManager.can_load_game():
		load_game()
	else:
		new_game()



func _input(event):
	if upgrade_container.visible:
		if Input.is_action_just_pressed("LeftClick"):
			if gv.is_mouse_outside_node(event.position, upgrade_container):
				upgrade_container.hide()
				gv.clear_tooltip()
				return
		elif Input.is_action_just_pressed("ESC"):
			upgrade_container.hide()
			gv.clear_tooltip()
			return
	
	if Input.is_action_just_pressed("Q"):
		upgrade_container.select_tab(0)
	elif Input.is_action_just_pressed("W"):
		upgrade_container.select_tab(1)
	elif Input.is_action_just_pressed("E"):
		upgrade_container.select_tab(2)
	elif Input.is_action_just_pressed("R"):
		upgrade_container.select_tab(3)
	elif Input.is_action_just_pressed("A"):
		upgrade_container.select_tab(4)
	elif Input.is_action_just_pressed("S"):
		upgrade_container.select_tab(5)
	elif Input.is_action_just_pressed("D"):
		upgrade_container.select_tab(6)
	elif Input.is_action_just_pressed("F"):
		upgrade_container.select_tab(7)
	
	if Input.is_action_just_pressed("Mouse Wheel Down"):
		gv.clear_tooltip()
		return
	if Input.is_action_just_pressed("Mouse Wheel Up"):
		gv.clear_tooltip()
		return




func _on_dev_pressed():
	wa.add(Currency.Type.STONE, 10)
	wa.add(Currency.Type.COAL, 10)
	pass

func _on_dev_2_pressed():
	wa.add(Currency.Type.IRON, 100)
	wa.add(Currency.Type.COPPER, 100)
	wa.add(Currency.Type.IRON_ORE, 3000)
	wa.add(Currency.Type.COPPER_ORE, 1500)



# - Actions

func new_game() -> void:
	lv.new_game_start()
	wi.new_game_start()
	em.new_game_start()


func load_game() -> void:
	#loreds
	#upgrades
	#wi.load
	#em.load
	
	# after all autoload nodes have loaded, start all of them.
	lv.loaded_game_start()
	wi.loaded_game_start()
	em.loaded_game_start()



# - Get

