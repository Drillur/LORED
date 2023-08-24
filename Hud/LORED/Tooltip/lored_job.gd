extends MarginContainer



@onready var title = %Title
@onready var duration = %Duration
@onready var produced_currencies_parent = %"Produced Currencies Parent"
@onready var required_currencies_parent = %"Required Currencies Parent"
@onready var glow = $glow
@onready var title_bg = %"title bg"

var lored_job_entry := preload("res://Hud/LORED/Tooltip/lored_job_entry.tscn")
var job: Job



func setup(_job: Job) -> void:
	job = _job
	if not is_node_ready():
		await ready
	
	glow.self_modulate = lv.get_lored(job.lored).faded_color
	
	title.text = "[b]" + job.name
	job.duration.connect("changed", update_duration_text)
	update_duration_text()
	prepare_produced_currencies()
	prepare_required_currencies()
	
	job.connect("stopped_working", glow.hide)
	job.connect("began_working", glow.show)
	if job.working:
		glow.show()
	else:
		glow.hide()



func prepare_produced_currencies() -> void:
	if job.has_produced_currencies:
		for cur in job.produced_currencies:
			var x = lored_job_entry.instantiate()
			x.setup(job.produced_currencies[cur], cur, true)
			produced_currencies_parent.add_child(x)
	else:
		produced_currencies_parent.queue_free()


func prepare_required_currencies() -> void:
	if job.has_required_currencies:
		for cur in job.required_currencies.cost:
			var x = lored_job_entry.instantiate()
			x.setup(job.required_currencies.cost[cur], cur, false)
			required_currencies_parent.add_child(x)
	else:
		required_currencies_parent.queue_free()


func update_duration_text() -> void:
	duration.text = "[i]" + job.duration.get_text() + " seconds"
