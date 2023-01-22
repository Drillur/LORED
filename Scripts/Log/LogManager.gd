extends Node



enum Type {
	OFFLINE_EARNINGS,
	UPGRADE_PURCHASED,
	LEVEL_UP,
}

var logs := []

var saved_vars := ["options"]

var options := {
	"LEVEL_UP": false,
	"UPGRADE_PURCHASED": false,
	"OFFLINE_EARNINGS": true,
}

func enableAllOptions():
	# called in case of failed load in Root
	for option in options:
		options[option] = true




func typeAllowed(type: int) -> bool:
	return options[Type.keys()[type]]



func log(type: int, info: String):
	if typeAllowed(type):
		logs.append([type, info])
		print(Type.keys()[type], " entry logged. Info: ", info)

