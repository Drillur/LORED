extends MarginContainer


func setup(lored: int):
	if lv.lored[lored].exporting:
		get_node("%top text").text = "Exporting"
		get_node("%iconExporting").show()
		get_node("%textExporting").show()
	else:
		get_node("%top text").text = "Not Exporting"
		get_node("%iconExportingFalse").show()
		get_node("%textExportingFalse").show()
