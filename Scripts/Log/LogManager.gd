extends Node



enum Type {
	OFFLINE_EARNINGS,
}

var logs := []


func log(type: int, info: String):
	logs.append(Log.new(type, info))


