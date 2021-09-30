class_name Emote
extends Reference



var message: String
var reply_key: String
var reply_message: String
var required_unlock_key: String

var has_reply := false
var requires_unlock := false



func _init(_m, _r_key := "", _r_m := "", _required_unlock_key := "") -> void:
	message = _m
	if _required_unlock_key != "":
		requires_unlock = true
		required_unlock_key = _required_unlock_key
	if _r_key == "":
		return
	has_reply = true
	reply_key = _r_key
	reply_message = _r_m
