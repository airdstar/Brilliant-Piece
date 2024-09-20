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
		if !mH.UH.currentMenu:
			handle3DHighlighting(inputDirection)
		else:
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

func handle3DHighlighting(input : String):
	var rotation = rad_to_deg(FloorData.floor.cameraBase.rotation.y)
	var direction = null
	
	if input == "Left" or input == "Right":
		if rotation > -172.5 and rotation < -97.5:
			direction = mH.DH.dirDict["Direction"][4]
		elif rotation >= -97.5 and rotation <= -82.5:
			direction = mH.DH.dirDict["Direction"][5]
		elif rotation > -82.5 and rotation < -7.5:
			direction = mH.DH.dirDict["Direction"][6]
		elif rotation >= -7.5 and rotation <= 7.5:
			direction = mH.DH.dirDict["Direction"][7]
		elif rotation > 7.5 and rotation < 82.5:
			direction = mH.DH.dirDict["Direction"][0]
		elif rotation >= 82.5 and rotation <= 97.5:
			direction = mH.DH.dirDict["Direction"][1]
		elif rotation > 97.5 and rotation < 172.5:
			direction = mH.DH.dirDict["Direction"][2]
		elif (rotation >= 172.5 and rotation <= 180) or (rotation >= -180 and rotation <= -172.5):
			direction = mH.DH.dirDict["Direction"][3]
		
		if input == "Right":
			direction = mH.DH.getOppDirection(direction)
			
	elif input == "Backward" or input == "Forward":
		if rotation > -172.5 and rotation < -97.5:
			direction = mH.DH.dirDict["Direction"][6]
		elif rotation >= -97.5 and rotation <= -82.5:
			direction = mH.DH.dirDict["Direction"][7]
		elif rotation > -82.5 and rotation < -7.5:
			direction = mH.DH.dirDict["Direction"][0]
		elif rotation >= -7.5 and rotation <= 7.5:
			direction = mH.DH.dirDict["Direction"][1]
		elif rotation > 7.5 and rotation < 82.5:
			direction = mH.DH.dirDict["Direction"][2]
		elif rotation >= 82.5 and rotation <= 97.5:
			direction = mH.DH.dirDict["Direction"][3]
		elif rotation > 97.5 and rotation < 172.5:
			direction = mH.DH.dirDict["Direction"][4]
		elif (rotation >= 172.5 and rotation <= 180) or (rotation >= -180 and rotation <= -172.5):
			direction = mH.DH.dirDict["Direction"][5]
		
		if input == "Forward":
			direction = mH.DH.getOppDirection(direction)
			
	findClosestTile(direction)

func findClosestTile(direction : int):
	var foundTile : tile
	var searcher : Vector3 = mH.TH.tileDict["hTile"].global_position
	var forward = mH.DH.dirDict["PosData"][direction]
	var left = mH.DH.dirDict["PosData"][mH.DH.getSides(direction)[0]]
	var right = mH.DH.dirDict["PosData"][mH.DH.getSides(direction)[1]]
	for n in range(4):
		if !foundTile:
			searcher += forward
			if !mH.TH.lookForTile(searcher):
				if !mH.TH.lookForTile(searcher + forward):
					if !mH.TH.lookForTile(searcher + left):
						if !mH.TH.lookForTile(searcher + right):
							foundTile = mH.TH.lookForTile(searcher + right)
					else:
						foundTile = mH.TH.lookForTile(searcher + left)
				else:
					foundTile = mH.TH.lookForTile(searcher + forward)
			else:
				foundTile = mH.TH.lookForTile(searcher)

	if foundTile:
		highlightTile(foundTile)

func highlightTile(tileToSelect : tile):
	var pointer = FloorData.floor.Pointer
	var cameraBase = FloorData.floor.cameraBase
	mH.TH.tileDict["hTile"] = tileToSelect
	mH.TH.setTilePattern()
	tileToSelect.highlight.visible = true
	pointer.position = Vector3(tileToSelect.position.x, tileToSelect.getPointerPos(), tileToSelect.position.z)
	cameraBase.position = Vector3(tileToSelect.position.x, cameraBase.position.y, tileToSelect.position.z)
	if FloorData.floorInfo.playerTurn:
		if mH.TH.tileDict["iTiles"].has(tileToSelect):
			if mH.SH.moving:
				tileToSelect.setColor(Global.colorDict["Blue"])
				pointer.setColor(Global.colorDict["Blue"])
				if tileToSelect.contains is EnemyPiece:
					tileToSelect.setColor(Global.colorDict["Red"])
					pointer.setColor(Global.colorDict["Red"])
			elif mH.SH.action:
				tileToSelect.setColor(Global.colorDict["Red"])
				pointer.setColor(Global.colorDict["Red"])
				if mH.SH.action.AOE:
					var possibleTiles = mH.SH.action.AOE.getAOE(tileToSelect.global_position, mH.DH.getClosestDirection(tileToSelect.global_position, PlayerData.playerInfo.currentPos))
					for n in range(possibleTiles.size()):
						if mH.TH.lookForTile(possibleTiles[n]):
							mH.TH.lookForTile(possibleTiles[n]).setColor(Global.colorDict["Red"])
		else:
			tileToSelect.setColor(Global.colorDict["Gray"])
			pointer.setColor(Global.colorDict["Gray"])
	else:
		tileToSelect.setColor(Global.colorDict["Gray"])
		pointer.setColor(Global.colorDict["Gray"])
	
	mH.UH.displayInfo()
