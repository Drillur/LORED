extends HBoxContainer

var job: Job

var rqs: Array
var output_cont: HBoxContainer

var base_text := "[center]"



func init(_job: Job):
	
	job = _job
	
	yield(self, "ready")
	
	get_node("dot").self_modulate = gv.COLORS[job.lored_key]
	
	if job.requires_resource:
		
		base_text += "Given"
		
		var i = 0
		for _rq in job.required_keys:
			base_text += " [img=<16>]" + gv.sprite[_rq].get_path() + "[/img]"
			base_text += "[b][color=#" + gv.COLORS[_rq].to_html() + "]" + Big.new(job.required_resource_amount[i].t).m(job.output.t).toString() + "[/color][/b]"
			i += 1
			if i == 1 and job.required_keys.size() == 3:
				base_text += ", "
			if i == job.required_keys.size() - 1 and job.required_keys.size() > 1:
				base_text += " and"
			if i == job.required_keys.size():
				base_text += ","
			
	
	base_text += job.can_text
	
	base_text += "[img=<16>]" + gv.sprite[job.produced_resource_key].get_path() + "[/img]"
	base_text += "[b][color=#" + gv.COLORS[job.produced_resource_key].to_html() + "]" + job.output.t.toString() + "[/color][/b]"
	
	base_text += " (" + fval.f(job.duration) + "s)"
	
	#update()
	$label.bbcode_text = base_text

func update():
	
	while true:
		
		var i = 0
		for _rq in job.required_keys:
			rqs[i].get_node("val").text = Big.new(job.required_resource_amount[i].t).m(job.output.t).toString()
			if i == 0 and job.required_keys.size() == 3:
				rqs[i].get_node("val").text += ","
			if i + 1 == job.required_keys.size():
				rqs[i].get_node("val").text += ","
			i += 1
		output_cont.get_node("val").text = job.output.t.toString() + "!"
		
		$Timer.start(1)
		yield($Timer, "timeout")
