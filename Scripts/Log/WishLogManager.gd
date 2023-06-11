extends Node




# - Actions

func log(wish: Wish):
	get_node("/root/Root/%WishLog").log(wish)
	if gv.option["wishVicosOnMainScreen"]:
		taq.instanceWishVico(wish)
	if not gv.inFirstTwoSecondsOfRun():
		get_node("/root/Root").wishNotice()
	
#	emoteEvent(wish.key)
#
#func emoteEvent(key: String):
#	pass
#	if key == "upgrade_stone":
#		EmoteManager.emote(EmoteManager.Type.IRON_WISH_LOG)
#		# in case the game is closed before the meta is clicked:
#		get_node("/root/Root").WishLogButtonVisible = true


