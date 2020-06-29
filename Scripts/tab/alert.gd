extends Sprite

var flash = false
var tim = 0
var wave = 0
var hidden = true

onready var up = preload("res://Sprites/tab/alert.png")
onready var down = preload("res://Sprites/tab/alert2.png")

func _ready():
	self.visible = false

func _physics_process(_delta):
	
	if hidden: return
	
	tim += 1
	if tim > 35:
		match wave:
			0:
				self.set_texture(down)
				wave = 1
			1:
				self.set_texture(up)
				wave = 0
		tim = 0

func b_flash(flashy: bool) -> void:
	
	if flashy:
		flash = true
		show()
		hidden = false
		return
	
	tim = 0
	wave = 0
	texture = up
	hide()
	hidden = true
	
