extends MarginContainer


onready var outputText = get_node("%output")
onready var progress = get_node("%Progress Bar")

var output: Big
var willToLive = 100




func _ready() -> void:
	progress.color = gv.COLORS["coal"]
	progress.value = 1
	update()



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
	output = Big.new(lv.lored[lv.Type.COAL].output).d(10)

func updateTexts():
	outputText.text = "+" + output.toString() + " Coal fuel"

func updateProgress():
	progress.value = float(willToLive) / 100



func _on_button_pressed() -> void:
	lv.lored[lv.Type.COAL].lored.currentFuel.a(output)
	#gv.addToResource(gv.Resource.COAL, output)
	#taq.increaseProgress(gv.Objective.RESOURCES_PRODUCED, "coal", output)
	willToLive -= 1
	updateProgress()
	dieCheck()

func dieCheck():
	if willToLive <= 0:
		gv.manualLaborActive = false
		queue_free()
