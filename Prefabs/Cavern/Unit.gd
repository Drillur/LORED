extends MarginContainer


# text should be Barrier color if ANY barrier is present. Otherwise, Health color.
# resize if too big. i want many on-screen targets


onready var health = get_node("m/v/m/resources/v/health")
onready var barrier = get_node("m/v/m/resources/v/barrier")
#onready var stamina = get_node("m/v/m/resources/stamina")
#onready var mana = get_node("m/v/m/resources/mana")

onready var health_text = get_node("m/v/m/texts/health")
onready var barrier_text = get_node("m/v/m/texts/barrier")


var unit: Unit
var unit_set := false






func setUnit(_unit: Unit):
	unit = _unit
	unit_set = true
	setVisualComponents()
	
	unit.updateVisualComponents()

func setVisualComponents():
	setUnitNode()
	setHealthVC()
	setBarrierVC()
	#setStaminaVC()
	#setManaVC()
func setUnitNode():
	unit.setNode(self)
func setHealthVC():
	unit.health.setBar(health)
func setBarrierVC():
	unit.barrier.setBar(barrier)
#func setStaminaVC():
#	unit.stamina.setBar(stamina)
#func setManaVC():
#	unit.mana.setBar(mana)
func setHealthText():
	unit.health.setText(health_text)
func setBarrierText():
	unit.barrier.setText(barrier_text)


func die():
	queue_free()


func _on_select_pressed() -> void:
	Cav.emit_signal("spell_target_confirmed", self, 0)
