extends Handler

func _process(_delta):
	var inputDirection : String
	if Input.is_action_just_pressed("Left"):
		inputDirection = "Left"
	elif Input.is_action_just_pressed("Right"):
		inputDirection = "Right"
	elif Input.is_action_just_pressed("Forward"):
		inputDirection = "Forward"
	elif Input.is_action_just_pressed("Backward"):
		inputDirection = "Backward"
	
	if inputDirection:
		if mH.UH.currentMenu != null:
			handleMenuHighlighting(inputDirection)

func handleMenuHighlighting(input : String):
	var menu = mH.UH.currentMenu
	if menu is BasicMenu or menu is ActionMenu:
		if menu is ActionMenu:
			match input:
				"Forward":
					input = "Backward"
				"Backward":
					input = "Forward"
		if input == "Forward" and !menu.hasSelectedOption:
			menu.hoverToggle()
			if menu.highlightedOption < menu.optionCount - 1:
				menu.highlightedOption += 1
			else:
				menu.highlightedOption = 0
			menu.hoverToggle()
		elif input == "Backward" and !menu.hasSelectedOption:
			menu.hoverToggle()
			if menu.highlightedOption > 0:
				menu.highlightedOption -= 1
			else:
				menu.highlightedOption = menu.optionCount - 1
			menu.hoverToggle()
	
	elif menu is ItemMenu:
		if input == "Left":
			if menu.highlightedOption == 0:
				menu.highlightedOption = menu.itemCount - 1
			else:
				menu.highlightedOption -= 1
			menu.swapItem()
		elif input == "Right":
			if menu.highlightedOption == menu.itemCount - 1:
				menu.highlightedOption = 0
			else:
				menu.highlightedOption += 1
			menu.swapItem()

func highlightTile(tPos : Vector2i):
	var tileToSelect = FloorData.tiles[tPos.x][tPos.y]
	mH.TH.highlightedTile = tileToSelect
	mH.TH.setTilePattern()
	if FloorData.floorInfo.playerTurn:
		tileToSelect.tileColor.set_color(Global.colorDict["Gray"])
	else:
		tileToSelect.tileColor.set_color(Global.colorDict["Gray"])
	
	mH.UH.displayInfo()

func unhighlightTile():
	mH.TH.highlightedTile = null
	mH.TH.setTilePattern()
	mH.UH.displayInfo()
