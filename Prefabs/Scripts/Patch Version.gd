extends MarginContainer


const gn_version = "h/version"
const gn_more = "h/changes/more"


func setup(version: String):
	
	get_node(gn_version).text = version
	
	var i = 0
	for x in gv.PATCH_NOTES[version]:
		
		if typeof(x) == TYPE_BOOL:
			continue
		
		get_node("h/changes/t" + str(i)).text = "- " + x
		get_node("h/changes/t" + str(i)).show()
		
		i += 1
	
	if gv.PATCH_NOTES[version][0]:
		get_node(gn_more).show()
