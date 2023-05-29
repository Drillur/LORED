extends MarginContainer


onready var outputText = get_node("%output")
onready var progress = get_node("%Progress Bar")
onready var button = get_node("button")

var output: Big
var willToLive = 100




func _ready() -> void:
	progress.color = gv.COLORS["coal"]
	progress.value = 1
	update()
	gv.connect("ResourceCollected", self, "check_enable")



func update():
	
	var t = Timer.new()
	add_child(t)
	
	while not is_queued_for_deletion():
		
		updateOutput()
		updateTexts()
		
		t.start(1)
		yield(t, "timeout")
	
	t.queue_free()

func updateOutput():
	output = Big.new(lv.lored[lv.Type.COAL].output)

func updateTexts():
	outputText.text = "+" + output.toString() + " Coal fuel"

func updateProgress():
	progress.value = float(willToLive) / 100



func _on_button_pressed() -> void:
	
	if disabled:
		return
	
	lv.lored[lv.Type.COAL].lored.currentFuel.a(output)
	willToLive -= 1
	updateProgress()
	dieCheck()
	
	if lv.lored[lv.Type.COAL].getCurrentFuelPercent() >= 1:
		disable()
		return

func dieCheck():
	if willToLive <= 0:
		gv.manualLaborActive = false
		queue_free()


var disabled := false
func disable():
	disabled = true
	button.mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN


func check_enable(resource: int):
	if resource == gv.Resource.COAL:
		disabled = false
		button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
