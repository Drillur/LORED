extends Node




# - Actions

func log(wish: Wish):
	get_node("/root/Root/%WishLog").log(wish)
	if gv.option["wishVicosOnMainScreen"]:
		taq.instanceWishVico(wish)
	if not gv.inFirstTwoSecondsOfRun():
		get_node("/root/Root").wishNotice()

