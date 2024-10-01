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
		if mH.UH.currentMenu:
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


func findClosestTile(direction : int):
	var foundTile : Vector2i
	var rc : Vector2i = mH.TH.highlightedTile.rc
	
	var forward = mH.DH.dirDict["PosData"][direction]
	var left = mH.DH.dirDict["PosData"][mH.DH.getSides(direction)[0]]
	var right = mH.DH.dirDict["PosData"][mH.DH.getSides(direction)[1]]
	
	
	for n in range(12):
		if !foundTile:
			rc += forward
			
			if rc.x >= FloorData.floorInfo.rc.x:
				rc.x = 0
			elif rc.y >= FloorData.floorInfo.rc.y:
				rc.y = 0
			
			if FloorData.tiles[rc.x][rc.y] == null:
				
				if rc.x + forward.x >= FloorData.floorInfo.rc.x:
					rc.x = 0
				elif rc.y + forward.y >= FloorData.floorInfo.rc.y:
					rc.y = 0
				
				if FloorData.tiles[rc.x + forward.x][rc.y + forward.y] == null:
					match randi_range(0,1):
						0:
							if rc.x + left.x < FloorData.floorInfo.rc.x and rc.y + left.y < FloorData.floorInfo.rc.y:
								if FloorData.tiles[rc.x + left.x][rc.y + left.y] == null:
									if rc.x + right.x < FloorData.floorInfo.rc.x and rc.y + right.y < FloorData.floorInfo.rc.y:
										if FloorData.tiles[rc.x + right.x][rc.y + right.y] != null:
											foundTile = Vector2i(rc.x + right.x, rc.y + right.y)
								else:
									foundTile = Vector2i(rc.x + left.x, rc.y + left.y)
						1:
							if rc.x + right.x < FloorData.floorInfo.rc.x and rc.y + right.y < FloorData.floorInfo.rc.y:
								if FloorData.tiles[rc.x + right.x][rc.y + right.y] == null:
									if rc.x + left.x < FloorData.floorInfo.rc.x and rc.y + left.y < FloorData.floorInfo.rc.y:
										if FloorData.tiles[rc.x + left.x][rc.y + left.y] != null:
											foundTile = Vector2i(rc.x + left.x, rc.y + left.y)
								else:
									foundTile = Vector2i(rc.x + right.x, rc.y + right.y)
				else:
					foundTile = Vector2i(rc.x + forward.x, rc.y + forward.y)
			else:
				foundTile = Vector2i(rc.x, rc.y)
		else:
			break
	if foundTile:
		highlightTile(foundTile)

func highlightTile(tPos : Vector2i):
	var tileToSelect = FloorData.tiles[tPos.x][tPos.y]
	mH.TH.highlightedTile = tileToSelect
	mH.TH.setTilePattern()
	if FloorData.floorInfo.playerTurn:
		tileToSelect.set_color(Global.colorDict["Gray"])
	else:
		tileToSelect.set_color(Global.colorDict["Gray"])
	
	mH.UH.displayInfo()
