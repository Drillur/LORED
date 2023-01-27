extends Node


onready var logContainer = get_node("/root/Root/m/LogContainer")

enum Type {
	OFFLINE_EARNINGS,
	UPGRADE_PURCHASED,
	LEVEL_UP,
}

var logs := []

var saved_vars := ["options"]

var options := {
	"LEVEL_UP": true,
	"UPGRADE_PURCHASED": true,
	"OFFLINE_EARNINGS": true,
}

func enableAllOptions():
	# called in case of failed load in Root
	for option in options:
		options[option] = true




# - Handy

func typeAllowed(type: int) -> bool:
	if gv.inFirstTwoSecondsOfRun():
		if type != Type.OFFLINE_EARNINGS:
			return false
	return options[Type.keys()[type]]



# - Actions

func log(type: int, info: String):
	if typeAllowed(type):
		get_node("/root/Root/m/LogContainer").log(type, info)
		#logs.append([type, info])
		print(Type.keys()[type], " entry logged. Info: ", info)

