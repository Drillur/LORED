extends MarginContainer


func setup(lored: int):
	
	if lv.lored[lored].asleep:
		get_node("%awakeIcon").hide()
		get_node("%awake").hide()
		get_node("%status").text = "Asleep"
		get_node("%asleep").text = "Click to wake " + lv.lored[lored].pronoun("him") + " up!"
		get_node("%asleep").show()
		get_node("%asleepIcon").show()
		get_node("%asleepIcon").modulate = lv.lored[lored].color
	else:
		get_node("%asleepIcon").hide()
		get_node("%asleep").hide()
		get_node("%status").text = "Awake"
		get_node("%awake").text = "Click to put " + lv.lored[lored].pronoun("him") + " to sleep."
		get_node("%awake").show()
		get_node("%awakeIcon").show()
		get_node("%awakeIcon").modulate = lv.lored[lored].color

# this has no timer because it refreshes when asleep is changed
