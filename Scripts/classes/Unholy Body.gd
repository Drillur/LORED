class_name Unholy_Body
extends Node

var key: int
var amount: Big
var flesh_consumption: Big
var terror_generation := Big.new(0.01)
var life := 60.0

func _init(_key: int, _amount: Big) -> void:
	
	key = _key
	amount = Big.new(_amount)
	
	flesh_consumption = Big.new(amount)
	terror_generation.m(amount)
	
	gv.latest_unholy_body = key
	gv.r["unholy body"].a(amount)

func eat():
	
	life -= gv.fps
	
	# generate terror if flesh is available
	
	var eat_amount = Big.new(flesh_consumption).d(rand_range(12,20)).m(gv.fps)
	
	if gv.r["flesh"].greater_equal(eat_amount):
		
		life  += gv.fps
		gv.r["flesh"].s(eat_amount)
		gv.emit_signal("item_produced", "flesh")
		
		var increase = 1 + (1 * gv.fps / 100)
		terror_generation.m(increase)
		
		increase = 1 + (increase / 10000)
		flesh_consumption.m(increase)
	
	else:
		
		if terror_generation.greater(Big.new(amount).m(0.01)):
			var increase = 1 + (1 * gv.fps / 100)
			terror_generation.d(increase)
			
			increase = 1 + (increase / 10000)
			flesh_consumption.d(increase)
	
	gv.r["terror"].a(Big.new(terror_generation).m(gv.fps))
	gv.emit_signal("amount_updated", "terror")

func is_dead() -> bool:
	
	if life <= 0:
		return die() # dead
	
	return false

func die() -> bool:
	gv.r["unholy body"].s(amount)
	gv.r["defiled dead"].a(amount)
	gv.emit_signal("item_produced", "defiled dead")
	return true
