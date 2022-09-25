extends MarginContainer



onready var icon = get_node("m/v/top/v/mid/v2/resource/icon/Sprite")
onready var iconShadow = get_node("m/v/top/v/mid/v2/resource/icon/Sprite/shadow")
onready var gnResourceText = get_node("m/v/top/v/mid/v2/resource/v/amount")
onready var animation = get_node("m/v/top/v/mid/animation/AnimatedSprite")
onready var currentProgress = get_node("progress/current")
onready var misc = get_node("misc")
onready var fuelProgress = get_node("%Fuel Progress")
onready var check = get_node("%Check") setget , getCheck
onready var alert = get_node("%alert")
onready var production = get_node("%production")
onready var t = get_node("Timer")
onready var status = get_node("%status")
func getCheck():
	return check

onready var rt = get_node("/root/Root")

var manager: Node2D



func _ready() -> void:
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
	fuelProgress.setup(type, false)
	animation.init(type)
	if type in lv.smallerAnimationList:
		animation.scale = Vector2(2,2)

func setColors(type: int):
	var loredColor = lv.lored[type].color
	var fadedLoredColor = getFadedColor(type)
	get_node("bg_color").self_modulate = loredColor
	get_node("m/v/top/v/mid/animation").modulate = fadedLoredColor
	get_node("m/v/bot/m/h/info").modulate = fadedLoredColor
	get_node("m/v/bot/m/h/sleep").modulate = fadedLoredColor
	get_node("m/v/bot/m/h/export").modulate = fadedLoredColor
	get_node("%level up/icon/Sprite").modulate = fadedLoredColor
	get_node("%level up/Button").self_modulate = fadedLoredColor
	get_node("progress/current/edge").self_modulate = loredColor

func getFadedColor(type: int) -> Color:
	
	match type:
		lv.Type.STEEL:
			return Color(0.823529, 0.898039, 0.92549)
		lv.Type.HUMUS:
			return Color(0.6, 0.3, 0)
		lv.Type.GALENA:
			return Color(0.701961, 0.792157, 0.929412)
		lv.Type.CIGARETTES:
			return Color(0.97, 0.8, 0.6)
		lv.Type.LIQUID_IRON:
			return Color(0.7, 0.94, .985) # Color(0.27, 0.888, .97)
		lv.Type.WOOD:
			return Color(0.77, 0.68, 0.6)
		lv.Type.TOBACCO:
			return Color(0.85, 0.75, 0.63)
		lv.Type.GLASS:
			return Color(0.81, 0.93, 1.0)
		lv.Type.SEEDS:
			return Color(.8,.8,.8)
		lv.Type.TREES:
			return Color(0.864746, 0.988281, 0.679443)
		lv.Type.WATER:
			return Color(0.570313, 0.859009, 1)
		lv.Type.COAL:
			return Color(0.9, 0.3, 1)
		lv.Type.STONE:
			return Color(0.788235, 0.788235, 0.788235)
		lv.Type.IRON_ORE:
			return Color(0.5, 0.788732, 1)
		lv.Type.COPPER_ORE:
			return Color(0.695313, 0.502379, 0.334076)
		lv.Type.IRON:
			return Color(0.496094, 0.940717, 1)
		lv.Type.COPPER:
			return Color(1, 0.862001, 0.496094)
		lv.Type.GROWTH:
			return Color(0.890041, 1, 0.5)
		lv.Type.CONCRETE:
			return Color(0.6, 0.6, 0.6)
		lv.Type.JOULES:
			return Color(1, 0.9572, 0.503906)
		lv.Type.MALIGNANCY:
			return Color(0.882353, 0.121569, 0.352941)
		lv.Type.TARBALLS:
			return Color(0.560784, 0.439216, 1)
		lv.Type.OIL:
			return Color(0.647059, 0.298039, 0.658824)
		_:
			var loredColor = lv.lored[type].color
			return Color((1 - loredColor.r) / 2 + loredColor.r, (1 - loredColor.g) / 2 + loredColor.g, (1 - loredColor.b) / 2 + loredColor.b)


func assignManager(_manager: Node2D):
	manager = _manager



# - - - Signals

func _on_level_pressed() -> void:
	manager.purchase()
func _on_export_pressed() -> void:
	manager.switchExport()

func _on_mouse_exited() -> void:
	rt.get_node("global_tip")._call("no")
func _on_info_mouse_entered() -> void:
	rt.get_node("global_tip")._call("lored info", {"type": manager.type})
func _on_level_mouse_entered() -> void:
	rt.get_node("global_tip")._call("lored level up", {"color": manager.color, "lored": manager.type})
func _on_alert_mouse_entered() -> void:
	rt.get_node("global_tip")._call("lored alert", {"type": manager.type, "alert": manager.activeAlert})

func _on_visibility_changed() -> void:
	if visible:
		manager.justAppearedForTheFirstTime()



# - - - Modes

func enterStandby():
	
	production.hide()
	hideProgress()
	get_node("%info").hide()
	get_node("%sleep").hide()
	get_node("%export").hide()

func enterActive():
	get_node("%info").show()
	get_node("%sleep").show()
	get_node("%export").show()



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

func setStatusText(text: String):
	if text == "":
		status.hide()
		return
	status.bbcode_text = "[center]" + text
	status.show()

func finishedWorkingForNow():
	production.hide()

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
	fuelProgress.show()
	fuelProgress.update()
func alert_lowFuel_stop():
	fuelProgress.stop()
	fuelProgress.hide()


