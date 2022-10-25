extends MarginContainer



var wish: Wish

onready var dialogue   = get_node("m/v/dialogue/h/m/Label")
onready var speaker_name = get_node("%giver")
onready var rewards    = get_node("m/v/rewards")
#onready var count      = get_node("m/v/obj/v/m/h/count")
onready var expression = get_node("m/v/dialogue/h/expression/v/Panel/Sprite")




func init(_wish: Wish):
	
	yield(self, "ready")
	
	wish = _wish
	
	wish.setTooltip(self)
	
	initiateVisualShit()

func initiateVisualShit():
	
	get_node("m/v/rewards/bg").self_modulate = wish.color
	get_node("m/v/random/v/line").self_modulate = wish.color
	expression.modulate = wish.giverColor
	speaker_name.self_modulate = wish.giverColor
	speaker_name.text = wish.giverName
	#get_node("m/v/dialogue/h/expression/v/name/bg").self_modulate = gv.g[wish.giver].color
	#current.modulate = wish.color
	get_node("m/v/random").visible = wish.random and not wish.ready
	
	updateDialogueAndExpression()
	
	# rewards
	if true:
		
		var s1_used := false
		var s2_used := false
		var s3_used := false
		var r1_used := false
		var r2_used := false
		var r3_used := false
		
		if wish.rewards == 0:
			rewards.hide()
		
		for r in wish.rew:
			
			match r.type:
				
				gv.WishReward.LORED_FUNCTIONALITY:
					get_node("%" + r.key).show()
#					match r.key:
#						"sleep":
#							get_node("%sleep").show()
#						"jobs":
#							get_node("%jobs").show()
				
				gv.WishReward.EASIER:
					
					get_node("m/v/rewards/h/v/easier").show()
				
				gv.WishReward.AUTOMATED:
					
					if r.key == str(gv.WishReward.HALT_AND_HOLD):
						get_node("m/v/rewards/h/v/automated halt&hold").show()
					elif r.key == str(gv.WishReward.WISH_TURNIN):
						get_node("m/v/rewards/h/v/automated turnin").show()
				
				gv.WishReward.MAX_RANDOM_WISHES:
					
					get_node("m/v/rewards/h/v/max_random_wishes").show()
					get_node("m/v/rewards/h/v/max_random_wishes/h/amount").text = "+" + r.amount.toString()
					get_node("m/v/rewards/h/v/max_random_wishes/h/current").text = "(" + str(taq.max_random_wishes) + ")"
				
				gv.WishReward.TAB:
					if int(r.key) < gv.Tab.S1:
						get_node("m/v/rewards/h/v/upgrade tab").show()
						get_node("m/v/rewards/h/v/upgrade tab/h/icon/Sprite").texture = gv.sprite[r.key]
						
						var bla = {gv.Tab.NORMAL: "Normal", gv.Tab.MALIGNANT: "Malignant",
							gv.Tab.EXTRA_NORMAL: "Extra-normal", gv.Tab.RADIATIVE: "Radiative",
							gv.Tab.RUNED_DIAL: "Runed Dial", "s3m": "Spirit" #s4
						}
						var bla2 = {gv.Tab.NORMAL: "Q", gv.Tab.MALIGNANT: "W",
							gv.Tab.EXTRA_NORMAL: "E", gv.Tab.RADIATIVE: "R",
							gv.Tab.RUNED_DIAL: "A", "s3m": "S" #s4
						}
						
						var menu_name = bla[int(r.key)]
						var hotkey = bla2[int(r.key)]
						
						get_node("m/v/rewards/h/v/upgrade tab/h/flair").text = menu_name + " Upgrade menu - Hotkey: " + hotkey
					else:
						get_node("m/v/rewards/h/v/stage tab").show()
						get_node("m/v/rewards/h/v/stage tab/h/icon/Sprite").texture = gv.sprite[r.key]
						# r.key example: 7. 7 == gv.Tab.S2.
						# gv.Tab.S1 == 6. (at least as far as stage 2
						get_node("m/v/rewards/h/v/stage tab/h/stage").text = "Stage " + str(int(r.key) - gv.Tab.s4m)
				
				gv.WishReward.NEW_LORED:
					get_node("m/v/rewards/h/v/newcomer").show()
					if not s1_used:
						s1_used = true
						get_node("m/v/rewards/h/v/newcomer/h/h/s1/Sprite").texture = lv.lored[int(r.key)].icon
					elif not s2_used:
						s2_used = true
						get_node("m/v/rewards/h/v/newcomer/h/h/s2/Sprite").texture = lv.lored[int(r.key)].icon
						get_node("m/v/rewards/h/v/newcomer/h/h/s2").show()
					elif not s3_used:
						s3_used = true
						get_node("m/v/rewards/h/v/newcomer/h/h/s3/Sprite").texture = lv.lored[int(r.key)].icon
						get_node("m/v/rewards/h/v/newcomer/h/h/s3").show()
					else:
						get_node("m/v/rewards/h/v/newcomer/h/h/s4/Sprite").texture = lv.lored[int(r.key)].icon
						get_node("m/v/rewards/h/v/newcomer/h/h/s4").show()
				
				gv.WishReward.RESOURCE:
					
					var color = gv.COLORS[gv.shorthandByResource[int(r.key)]]
					if not r1_used:
						r1_used = true
						get_node("m/v/rewards/h/v/r1").show()
						get_node("m/v/rewards/h/v/r1/h/amount").text = "+" + r.amount.toString()
						get_node("m/v/rewards/h/v/r1/h/icon/Sprite").texture = gv.sprite[gv.shorthandByResource[int(r.key)]]
						get_node("m/v/rewards/h/v/r1/h/resource").text = gv.resourceName[int(r.key)]
						get_node("m/v/rewards/h/v/r1/h/amount").self_modulate = color
					else:
						if not r2_used:
							r2_used = true
							get_node("m/v/rewards/h/v/r2").show()
							get_node("m/v/rewards/h/v/r2/h/amount").text = "+" + r.amount.toString()
							get_node("m/v/rewards/h/v/r2/h/icon/Sprite").texture = gv.sprite[gv.shorthandByResource[int(r.key)]]
							get_node("m/v/rewards/h/v/r2/h/resource").text = gv.resourceName[int(r.key)]
							get_node("m/v/rewards/h/v/r2/h/amount").self_modulate = color
						else:
							if not r3_used:
								r3_used = true
								get_node("m/v/rewards/h/v/r3").show()
								get_node("m/v/rewards/h/v/r3/h/amount").text = "+" + r.amount.toString()
								get_node("m/v/rewards/h/v/r3/h/icon/Sprite").texture = gv.sprite[gv.shorthandByResource[int(r.key)]]
								get_node("m/v/rewards/h/v/r3/h/resource").text = gv.resourceName[int(r.key)]
								get_node("m/v/rewards/h/v/r3/h/amount").self_modulate = color
							else:
								get_node("m/v/rewards/h/v/r4").show()
								get_node("m/v/rewards/h/v/r4/h/amount").text = "+" + r.amount.toString()
								get_node("m/v/rewards/h/v/r4/h/icon/Sprite").texture = gv.sprite[gv.shorthandByResource[int(r.key)]]
								get_node("m/v/rewards/h/v/r4/h/resource").text = gv.resourceName[int(r.key)]
								get_node("m/v/rewards/h/v/r4/h/amount").self_modulate = color
		
		if get_node("m/v/rewards/h/v/newcomer").visible:
			if not get_node("m/v/rewards/h/v/newcomer/h/h/s2").visible:
				get_node("m/v/rewards/h/v/newcomer/h/flair").text = "Newcomer!"
			else:
				get_node("m/v/rewards/h/v/newcomer/h/flair").text = "Newcomers!"



func updateDialogueAndExpression():
	
	if wish.ready:
		dialogue.bbcode_text = wish.thank_text
		expression.texture = gv.sprite[wish.thank_expression]
	else:
		dialogue.bbcode_text = wish.help_text
		expression.texture = gv.sprite[wish.help_expression]
	#leftoff: Test the reset Wish in the current save file. (ignore the position of this message, this code is fine. don't touch it)
	dialogue.rect_min_size.x = max(dialogue.bbcode_text.length() * 0.75, 95)


func updateRandomVisibility():
	if get_node("m/v/random").visible:
		get_node("m/v/random").hide()

