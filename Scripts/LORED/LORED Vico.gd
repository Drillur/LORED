extends MarginContainer



onready var t = get_node("Timer")
onready var misc = get_node("misc")
onready var jobs = get_node("%jobs")
onready var alert = get_node("%alert")
onready var status = get_node("%status")
onready var production = get_node("%production")
onready var asleepAlert = get_node("%asleepAlert")
onready var check = get_node("%Check") setget , getCheck
onready var currentProgress = get_node("progress/current")
onready var fuelProgress_alarm = get_node("%Fuel Progress")
onready var icon = get_node("m/v/top/v/mid/v2/resource/icon/Sprite")
onready var animation = get_node("m/v/top/v/mid/animation/AnimatedSprite")
onready var gnResourceText = get_node("m/v/top/v/mid/v2/resource/v/amount")
onready var iconShadow = get_node("m/v/top/v/mid/v2/resource/icon/Sprite/shadow")

onready var rt = get_node("/root/Root")

var manager: Node2D



func _ready() -> void:
	
	alert.hide()
	asleepAlert.hide()
	
	setup(lv.Type[name])
	updateResourceTextTimer = Timer.new()
	updateResourceTextTimer.one_shot = true
	add_child(updateResourceTextTimer)
	
	outputTextTimer = Timer.new()
	outputTextTimer.one_shot = true
	add_child(outputTextTimer)
	
	gv.connect("resourceChanged", self, "queueResourceTextUpdate")
	queueResourceTextUpdate(primaryResource)

func setup(type: int):
	setColors(type)
	#setIcon(type)
	fuelProgress_alarm.setup(type, false)
	
	animation.init(type)
	if type in lv.smallerAnimationList:
		animation.scale = Vector2(2,2)

func setColors(type: int):
	var loredColor = lv.lored[type].color
	var fadedLoredColor = lv.getFadedColor(type)
	get_node("bg_color").self_modulate = loredColor
	get_node("m/v/top/v/mid/animation").modulate = fadedLoredColor
	get_node("%info").modulate = fadedLoredColor
	get_node("m/v/bot/m/h/sleep").modulate = fadedLoredColor
	get_node("%level up/icon/Sprite").modulate = fadedLoredColor
	get_node("%level up/Button").self_modulate = fadedLoredColor
	get_node("progress/current/edge").self_modulate = loredColor
	asleepAlert.modulate = loredColor
	jobs.modulate = fadedLoredColor
	#get_node("%fuel/Button").self_modulate = fadedLoredColor



func assignManager(_manager: Node2D):
	manager = _manager

func getCheck():
	return check


# - - - Signals

func _on_level_pressed() -> void:
	manager.purchase()
func _on_asleep_pressed() -> void:
	manager.asleepClicked(true)
	updateSleepButton()

func _on_mouse_exited() -> void:
	rt.get_node("global_tip")._call("no")
func _on_info_mouse_entered() -> void:
	rt.get_node("global_tip")._call("lored info", {"type": manager.type})
func _on_level_mouse_entered() -> void:
	rt.get_node("global_tip")._call("lored level up", {"color": manager.color, "lored": manager.type})
func _on_alert_mouse_entered() -> void:
	rt.get_node("global_tip")._call("lored alert", {"type": manager.type, "alert": manager.activeAlert})
func _on_jobs_mouse_entered() -> void:
	rt.get_node("global_tip")._call("lored jobs", {"lored": manager.type})
func _on_asleep_mouse_entered() -> void:
	rt.get_node("global_tip")._call("lored asleep", {"lored": manager.type})

func _on_visibility_changed() -> void:
	if visible:
		manager.justAppearedForTheFirstTime()



# - - - Modes

func enterStandby():
	
	hideProduction()
	hideProgress()
	get_node("%info").hide()
	get_node("%sleep").hide()
	jobs.hide()

func enterActive():
	get_node("%info").show()
	if "upgrade_stone" in taq.completed_wishes:
		get_node("%sleep").show()
	if "jobs" in taq.completed_wishes:
		jobs.show()



# - - - Progress and Animation

var progress: float setget setProgress
func setProgress(val: float):
	currentProgress.rect_size.x = min(val * rect_size.x, rect_size.x)

func jobStarted(duration: float, startTime: int):
	
	currentProgress.show()
	
	animation.start(duration, startTime)
	
	duration *= 1000
	var i = get_i(startTime)
	
	while not is_queued_for_deletion():
		
		t.start(gv.fps)
		yield(t, "timeout")
		
		i = get_i(startTime)
		if i >= duration:
			setProgress(0)
			break
		
		setProgress(i / duration)

func updateProduction(resource: int = primaryResource):
	production.show()
	production.text = lv.netText(resource) + "/s"

func hideProduction():
	production.hide()

func setStatusText(text: String):
	if text == "":
		status.hide()
		return
	status.bbcode_text = "[center]" + text
	status.show()

func finishedWorkingForNow():
	hideProduction()

func stop():
	t.stop()

func get_i(start_time: int) -> int:
	return OS.get_ticks_msec() - start_time






func hideProgress():
	currentProgress.hide()
	setProgress(0)
	goToSleep()

func goToSleep():
	animation.animation = "ww"



# - - - Actions

func hideCheck():
	check.hide()
func showCheck():
	check.show()

func sleepUnlocked():
	if manager.mode == lv.Mode.ACTIVE:
		get_node("%sleep").show()
func jobsUnlocked():
	if manager.mode == lv.Mode.ACTIVE:
		get_node("%jobs").show()

func updateSleepButton():
	get_node("%sleep/icon/asleep").visible = manager.asleep
	get_node("%sleep/icon/awake").visible = not manager.asleep

func flashSleep():
	
	var flash = gv.SRC["flash"].instance()
	get_node("%sleep").add_child(flash)
	flash.flash(Color(1,1,1))



# - - - Visual Flair shit?

func levelUpFlash():
	var flash = gv.SRC["flash"].instance()
	add_child(flash)
	#flash.flash(getFadedColor(manager.type))
	flash.flash(manager.color)

func levelUpText():
	var text = gv.SRC["lored level up"].instance()
	misc.add_child(text)
	text.rect_position = Vector2(rect_size.x / 2 - text.rect_size.x / 2, -text.rect_size.y - 10)
	text.go(manager.level)

var outputTextTimer: Timer
func throwOutputTexts(allTexts: Array):
	for textDetails in allTexts:
		newOutputText(textDetails)
		
		outputTextTimer.start(0.1)
		yield(outputTextTimer, "timeout")
func newOutputText(details: Dictionary):
	var outputText = gv.SRC["flying text"].instance()
	outputText.init(details)
	#outputText.rect_position = Vector2(rect_size.x * 0.825 - (outputText.rect_size.x / 2), 0) 
	outputText.rect_position = Vector2(-rect_global_position.x + animation.global_position.x - (outputText.rect_size.x / 2), 0) 
	get_node("Node2D").add_child(outputText)




# - - - Resource shit?

var resourceTextColor: Color setget setResourceTextColor
func setResourceTextColor(color: Color):
	gnResourceText.self_modulate = color
func setIcon(_icon: Texture):
	icon.texture = _icon
	iconShadow.texture = icon.texture


var primaryResource: int setget setPrimaryResource
func setPrimaryResource(val: int):
	primaryResource = val
	queueResourceTextUpdate(val)
var resourceTextQueued := false
func queueResourceTextUpdate(key: int):
	if key != primaryResource:
		return
	if resourceTextQueued == false:
		resourceTextQueued = true
		updateResourceText()

var updateResourceTextTimer: Timer
func updateResourceText():
	
	while resourceTextQueued:
		
		gnResourceText.text = gv.resource[primaryResource].toString()
		resourceTextQueued = false
		
		updateResourceTextTimer.start(gv.fps)
		yield(updateResourceTextTimer, "timeout")




# - - - Alerts

func showAlert():
	alert.show()
func hideAlert():
	alert.hide()
	if rt.get_node("global_tip").tip_filled:
		if rt.get_node("global_tip").type == "lored alert":
			_on_mouse_exited()
func alert_lowFuel():
	fuelProgress_alarm.show()
	fuelProgress_alarm.update()
func alert_lowFuel_stop():
	fuelProgress_alarm.stop()
	fuelProgress_alarm.hide()

func alert_asleep():
	asleepAlert.show()
func alert_asleep_stop():
	asleepAlert.hide()










