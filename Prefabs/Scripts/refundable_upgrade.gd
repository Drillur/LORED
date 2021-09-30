extends Label

onready var rt = get_owner().rt

func init(type : String, price : String) -> void:
	
	var label_text : String = "You may temporarily refund this upgrade, returning " + price + " %s."
	
	match type:
		gv.Tab.S1:
			label_text = label_text % "Malignancy"
		gv.Tab.S2:
			label_text = label_text % "Tumors"
	
	text = label_text
