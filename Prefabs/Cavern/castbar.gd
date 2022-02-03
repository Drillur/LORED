extends VBoxContainer



onready var cast = get_node("cast")
onready var current_text = get_node("m/text/h/current")
onready var total_text = get_node("m/text/h/total")
onready var current_bar = get_node("m/total/current")
onready var total_bar = get_node("m/total")

var cast_time: float

var running := false

var timer: Timer
var fps_timer: Timer

func _ready():
	timer = Timer.new()
	timer.one_shot = true
	fps_timer = Timer.new()
	add_child(timer)
	add_child(fps_timer)

func cast(_spell: int):
	
	var spell: Spell = Cav.spell[_spell]
	
	var cast_text = "Channeling " if spell.is_channeled else "Casting "
	cast.text = cast_text + spell.name
	
	cast_time = spell.getChannelDuration(gv.warlock) if spell.is_channeled else spell.getCastTime(gv.warlock)
	
	total_text.text = fval.f(cast_time)
	
	show()
	
	if not running:
		startRunning()

func startRunning():
	
	running = true
	timer.stop()
	timer.start(cast_time)

func _physics_process(delta: float) -> void:
	
	if not running:
		return
	
	if not gv.warlock.isCasting() or timer.time_left <= 0:
		stopRunning()
		return
	
	current_text.text = fval.f(cast_time - timer.time_left)
	current_bar.rect_size.x = min((cast_time - timer.time_left) / cast_time * total_bar.rect_size.x, total_bar.rect_size.x)
	

func stopRunning():
	running = false
	hide()

func cancelCast():
	stopRunning()
	timer.stop()
	if gv.warlock.casting:
		gv.warlock.gcd.stop()
	gv.warlock.stopCast(true)


