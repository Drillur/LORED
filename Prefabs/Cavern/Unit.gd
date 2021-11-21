extends MarginContainer


# text should be Barrier color if ANY barrier is present. Otherwise, Health color.
# resize if too big. i want many on-screen targets


onready var health = get_node("m/v/resources/m/v/health")
onready var barrier = get_node("m/v/resources/m/v/barrier")
onready var stamina = get_node("m/v/resources/stamina")
onready var mana = get_node("m/v/resources/mana")

onready var text = get_node("m/v/resources/m/text")

onready var barrier_timer = get_node("barrier")
onready var mana_timer = get_node("mana")
onready var stamina_timer = get_node("stamina")
onready var health_timer = get_node("health")

var unit: Unit
var unit_set := false






func setUnit(_unit: Unit):
	unit = _unit
	unit_set = true
	setVisualComponents()
	
	unit.health.updateVC()
	unit.barrier.updateVC()
	unit.stamina.updateVC()
	unit.mana.updateVC()
	updateText()

func regen(resource: Cav.UnitResource):
	
	#poopy stinky butthole
	var t = Timer.new()
	add_child(t)
	
	resource.stop_regen = false
	
	while not resource.stop_regen and resource.current.less(resource.total):
		resource.current = Big.new(resource.current).a(resource.regen)
		if resource == unit.health or resource == unit.barrier:
			updateText()
		t.start(resource.regen_rate) # 0.1 by default
		yield(t, "timeout")
	
	t.queue_free()

func setVisualComponents():
	setUnitVC()
	setHealthVC()
	setBarrierVC()
	setStaminaVC()
	setManaVC()
func setUnitVC():
	unit.setVC(self)
func setHealthVC():
	unit.health.setVC(health)
func setBarrierVC():
	unit.barrier.setVC(barrier)
func setStaminaVC():
	unit.stamina.setVC(stamina)
func setManaVC():
	unit.mana.setVC(mana)

func lostHealth():
	updateText()
	unit.health.stopRegen()
	health_timer.start(unit.health.regen_rest)
	yield(health_timer, "timeout")
	regen(unit.health)
func spentStamina():
	unit.stamina.stopRegen()
	stamina_timer.start(unit.stamina.regen_rest)
	yield(stamina_timer, "timeout")
	regen(unit.stamina)
func spentMana():
	unit.mana.stopRegen()
	mana_timer.start(unit.mana.regen_rest)
	yield(mana_timer, "timeout")
	regen(unit.mana)
func barrierDamaged():
	updateText()
	unit.barrier.stopRegen()
	barrier_timer.start(unit.barrier.regen_rest)
	yield(barrier_timer, "timeout")
	regen(unit.barrier)

func updateText():
	var healthAndBarrier = Big.new(unit.health.current).a(unit.barrier.current)
	text.text = healthAndBarrier.toString()
	if unit.barrierPresent():
		text.self_modulate = gv.COLORS["barrier"]
	else:
		text.self_modulate = gv.COLORS["health"]

func die():
	queue_free()


func _on_select_pressed() -> void:
	Cav.emit_signal("spell_target_confirmed", self, 0)
