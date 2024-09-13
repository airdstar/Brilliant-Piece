extends Node

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
		if !GameState.currentMenu:
			handle3DHighlighting(inputDirection)
		else:
			handleMenuHighlighting(inputDirection)

func handleMenuHighlighting(input : String):
	var menu = GameState.currentMenu
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
	var rotation = rad_to_deg(GameState.currentFloor.cameraBase.rotation.y)
	var direction = null
	
	if input == "Left" or input == "Right":
		if rotation > -172.5 and rotation < -97.5:
			direction = DirectionHandler.dirArray[4]
		elif rotation >= -97.5 and rotation <= -82.5:
			direction = DirectionHandler.dirArray[5]
		elif rotation > -82.5 and rotation < -7.5:
			direction = DirectionHandler.dirArray[6]
		elif rotation >= -7.5 and rotation <= 7.5:
			direction = DirectionHandler.dirArray[7]
		elif rotation > 7.5 and rotation < 82.5:
			direction = DirectionHandler.dirArray[0]
		elif rotation >= 82.5 and rotation <= 97.5:
			direction = DirectionHandler.dirArray[1]
		elif rotation > 97.5 and rotation < 172.5:
			direction = DirectionHandler.dirArray[2]
		elif (rotation >= 172.5 and rotation <= 180) or (rotation >= -180 and rotation <= -172.5):
			direction = DirectionHandler.dirArray[3]
		
		if input == "Right":
			direction = DirectionHandler.getOppDirection(direction)
			
	elif input == "Backward" or input == "Forward":
		if rotation > -172.5 and rotation < -97.5:
			direction = DirectionHandler.dirArray[6]
		elif rotation >= -97.5 and rotation <= -82.5:
			direction = DirectionHandler.dirArray[7]
		elif rotation > -82.5 and rotation < -7.5:
			direction = DirectionHandler.dirArray[0]
		elif rotation >= -7.5 and rotation <= 7.5:
			direction = DirectionHandler.dirArray[1]
		elif rotation > 7.5 and rotation < 82.5:
			direction = DirectionHandler.dirArray[2]
		elif rotation >= 82.5 and rotation <= 97.5:
			direction = DirectionHandler.dirArray[3]
		elif rotation > 97.5 and rotation < 172.5:
			direction = DirectionHandler.dirArray[4]
		elif (rotation >= 172.5 and rotation <= 180) or (rotation >= -180 and rotation <= -172.5):
			direction = DirectionHandler.dirArray[5]
		
		if input == "Forward":
			direction = DirectionHandler.getOppDirection(direction)
			
	findClosestTile(direction)

func findClosestTile(direction : DirectionHandler.Direction):
	var foundTile : tile
	var searcher : Vector3 = GameState.tileDict["hTile"].global_position
	var forward = DirectionHandler.dirDict["PosData"][direction]
	var left = DirectionHandler.dirDict["PosData"][DirectionHandler.getSides(direction)[0]]
	var right = DirectionHandler.dirDict["PosData"][DirectionHandler.getSides(direction)[1]]
	for n in range(4):
		if !foundTile:
			searcher += forward
			if !TileHandler.lookForTile(searcher):
				if !TileHandler.lookForTile(searcher + forward):
					if !TileHandler.lookForTile(searcher + left):
						if !TileHandler.lookForTile(searcher + right):
							foundTile = TileHandler.lookForTile(searcher + right)
					else:
						foundTile = TileHandler.lookForTile(searcher + left)
				else:
					foundTile = TileHandler.lookForTile(searcher + forward)
			else:
				foundTile = TileHandler.lookForTile(searcher)

	if foundTile:
		highlightTile(foundTile)

func highlightTile(tileToSelect : tile):
	var pointer = GameState.currentFloor.Pointer
	var cameraBase = GameState.currentFloor.cameraBase
	GameState.tileDict["hTile"] = tileToSelect
	TileHandler.setTilePattern()
	tileToSelect.highlight.visible = true
	pointer.position = Vector3(tileToSelect.position.x, tileToSelect.getPointerPos(), tileToSelect.position.z)
	cameraBase.position = Vector3(tileToSelect.position.x, cameraBase.position.y, tileToSelect.position.z)
	if GameState.playerTurn:
		if GameState.tileDict["iTiles"].has(tileToSelect):
			if tileToSelect.contains is EnemyPiece:
				tileToSelect.setColor(Global.colorDict["Red"])
				pointer.setColor(Global.colorDict["Red"])
			elif GameState.moving:
				tileToSelect.setColor(Global.colorDict["Blue"])
				pointer.setColor(Global.colorDict["Blue"])
			elif GameState.action:
				tileToSelect.setColor(Global.colorDict["Red"])
				pointer.setColor(Global.colorDict["Red"])
		else:
			tileToSelect.setColor(Global.colorDict["Gray"])
			pointer.setColor(Global.colorDict["Gray"])
	else:
		tileToSelect.setColor(Global.colorDict["Gray"])
		pointer.setColor(Global.colorDict["Gray"])
	
	InterfaceHandler.displayInfo()
