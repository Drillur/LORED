extends MarginContainer



onready var gain = get_node("%gain")
onready var drain = get_node("%drain")

var lored: int
var resource: int

var gain_amount := Big.new(0)
var drain_amount := Big.new(0)
var combined_amount: Big setget , get_combined_amount



func setup(_resource: int, _lored: int):
	
	resource = _resource
	lored = _lored
	
	set_icon()
	set_colors()
	set_lored_name()
	
	yield(self, "ready")
	
	connect_gain_bit_updated()
	connect_drain_bit_updated()


func set_icon():
	get_node("%icon").texture = lv.lored[lored].icon
	get_node("%icon/shadow").texture = get_node("%icon").texture


func set_colors():
	var color = lv.lored[lored].color
	get_node("%lored name").self_modulate = color


func set_lored_name():
	name = lv.lored[lored].name
	get_node("%lored name").text = name



func connect_gain_bit_updated():
	lv.connect("gain_bit_updated", self, "update_gain")
	update_gain(resource, lored, lv.gainBits[resource].get_bits()[lv.Num.ADD])


func update_gain(_resource: int, _lored: int, bits: Dictionary):
	
	if _resource != resource:
		return
	if _lored != lored:
		return
	if not lored in bits.keys():
		return
	
	set_gain_text(bits[lored].toString())
	
	gain_amount = Big.new(bits[lored])


func set_gain_text(text: String):
	if text == "0":
		gain.text = ""
	else:
		gain.text = text



func connect_drain_bit_updated():
	lv.connect("drain_bit_updated", self, "update_drain")
	update_drain(resource, lored, lv.drainBits[resource].get_bits())


func update_drain(_resource: int, _lored: int, bits: Dictionary):
	
	if _resource != resource:
		return
	if _lored != lored:
		return
	
	var total_drain := Big.new(0)
	for num in bits.keys():
		
		if not lored in bits[num].keys():
			continue
		
		total_drain.a(bits[num][lored])
	
	set_drain_text(total_drain.toString())
	
	drain_amount = total_drain


func set_drain_text(text: String):
	if text == "0":
		drain.text = ""
	else:
		drain.text = text


func get_combined_amount() -> Big:
	return gain_amount.a(drain_amount)
