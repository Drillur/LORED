extends MarginContainer



@onready var title = %Title
@onready var duration = %Duration
@onready var produced_currencies_parent = %"Produced Currencies Parent"
@onready var required_currencies_parent = %"Required Currencies Parent"
@onready var glow = $glow

var lored_job_entry := preload("res://Hud/LORED/Tooltip/lored_job_entry.tscn")
var label := preload("res://Hud/rich_text_label.tscn")
var job: Job



func setup(_job: Job) -> void:
	job = _job
	if not is_node_ready():
		await ready
	title.text = job.name
	job.duration.connect("changed", update_duration_text)
	update_duration_text()
	prepare_produced_currencies()
	prepare_required_currencies()
	
	glow.self_modulate = lv.get_lored(job.lored).faded_color
	job.connect("stopped_working", hide_glow)
	job.connect("began_working", show_glow)
	if job.working:
		glow.show()
	else:
		glow.hide()



func prepare_produced_currencies() -> void:
	if job.type == Job.Type.REFUEL:
		var x = label.instantiate()
		x.text = "+" + lv.get_lored(job.lored).fuel.get_x_percent_text(0.5) + " fuel"
		produced_currencies_parent.add_child(x)
	elif not job.has_produced_currencies:
		produced_currencies_parent.queue_free()
		return
	for cur in job.produced_currencies:
		var x = lored_job_entry.instantiate()
		x.setup(job.produced_currencies[cur], cur, true)
		produced_currencies_parent.add_child(x)


func prepare_required_currencies() -> void:
	if job.has_required_currencies:
		for cur in job.required_currencies.cost:
			var x = lored_job_entry.instantiate()
			x.setup(job.required_currencies.cost[cur], cur, false)
			required_currencies_parent.add_child(x)
	var x = label.instantiate()
	x.text = "-" + job.fuel_cost.get_text() + " fuel"
	required_currencies_parent.add_child(x)


func update_duration_text() -> void:
	duration.text = "[i]" + job.duration.get_text() + " sec"


func show_glow() -> void:
	glow.show()


func hide_glow() -> void:
	glow.hide()
