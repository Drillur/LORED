extends MarginContainer



var resource: int
var totalCost: Big

onready var icon = get_node("m/h/icon/Sprite")
onready var gnResource = get_node("m/h/resource")
onready var resourceName = get_node("m/h/name")
onready var check_box: Panel = $"%CheckBox"


func setup(_totalCost: Big, _resource: int):
	
	resource = _resource
	totalCost = _totalCost
	var shorthand = gv.shorthandByResource[resource]
	
	yield(self, "ready")
	
	icon.texture = gv.sprite[shorthand]
	resourceName.text = gv.resourceName[resource]
	gnResource.self_modulate = gv.COLORS[shorthand]
	
	updateLoop()

func updateLoop():
	
	var totalCostText = totalCost.toString()
	var t = Timer.new()
	add_child(t)
	
	while not is_queued_for_deletion():
		
		gnResource.text = gv.resource[resource].toString() + "/" + totalCostText
		check_box.checked = gv.resource[resource].greater_equal(totalCost)
		
		t.start(gv.fps)
		yield(t, "timeout")
	
	t.queue_free()

func flash():
	
	if gv.resource[resource].less(totalCost):
		
		var flash = gv.SRC["flash"].instance()
		add_child(flash)
		flash.flash(Color(1,0,0))
