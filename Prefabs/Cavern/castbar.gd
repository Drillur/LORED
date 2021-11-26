extends VBoxContainer



onready var cast = get_node("cast")
onready var current_text = get_node("m/text/h/current")
onready var total_text = get_node("m/text/h/total")
onready var current_bar = get_node("m/total/current")
onready var total_bar = get_node("m/total")

var cast_time: float
var i: float

var running := false

var timer: Timer

func _ready():
	timer = Timer.new()
	add_child(timer)

func cast(_spell: int):
	
	var spell: Spell = Cav.spell[_spell]
	
	var cast_text = "Channeling " if spell.is_channeled else "Casting "
	cast.text = cast_text + spell.name
	
	cast_time = spell.getChannelDuration(gv.warlock) if spell.is_channeled else spell.getCastTime(gv.warlock)
	
	total_text.text = fval.f(cast_time)
	
	i = 0.0
	
	if not running:
		update()
	
	show()

func update():
	
	running = true
	
	while gv.warlock.casting or gv.warlock.channeling and i < cast_time:
		
		current_text.text = fval.f(i)
		current_bar.rect_size.x = min(i / cast_time * total_bar.rect_size.x, total_bar.rect_size.x)
		timer.start(gv.fps)
		yield(timer, "timeout")
		
		i += gv.fps
	
	running = false
	
	hide()

func cancelCast():
	gv.warlock.stopCast()
	hide()

