extends Handler

var currentMenu = null

func _process(_delta):
	if currentMenu != null:
		if Input.is_action_just_pressed("Select"):
			currentMenu.selectOption()
		elif Input.is_action_just_pressed("Cancel"):
			if currentMenu is BasicMenu:
				if currentMenu.hasSelectedOption:
					currentMenu.options[currentMenu.highlightedOption - 1].selectToggle()
					currentMenu.hasSelectedOption = false
				else:
					closeMenu()
			else:
				closeMenu()
	elif Input.is_action_just_pressed("Cancel"):
		if mH.SH.playerTurn:
			mH.TH.stopShowing()
			openMenu()

func openMenu():
	if currentMenu == null:
		await get_tree().create_timer(0.01).timeout
		currentMenu = preload("res://UI/Menu/BasicMenu.tscn").instantiate()
		FloorData.floor.menuHolder.add_child(currentMenu)
		FloorData.floor.Pointer.visible = false
		mH.HH.highlightTile(PlayerData.playerPiece.currentTile)

func closeMenu():
	currentMenu.animation.play("CloseMenu")
	await get_tree().create_timer(0.2).timeout
	var holder = currentMenu
	if holder != null:
		if currentMenu.get_parent() is Menu:
			currentMenu = currentMenu.get_parent()
			currentMenu.hasSelectedOption = false
			currentMenu.options[currentMenu.highlightedOption].selectToggle()
		else:
			FloorData.floor.Pointer.visible = true
		holder.queue_free()

func fullyCloseMenu():
	while currentMenu != null:
		if !currentMenu.get_parent() is Menu:
			currentMenu.animation.play("SelectCloseMenu")
			await get_tree().create_timer(0.1).timeout
			if currentMenu != null:
				currentMenu.queue_free()
				currentMenu = null
		else:
			currentMenu = currentMenu.get_parent()
	FloorData.floor.Pointer.visible = true

func unselect():
	var currentMenu = currentMenu
	if currentMenu is BasicMenu:
		if currentMenu.hasSelectedOption:
			currentMenu.hasSelectedOption = false
			currentMenu.options[currentMenu.highlightedOption].selectToggle()
		currentMenu.selectedOption()

func displayInfo():
	if mH.TH.tileDict["hTile"].contains is MoveablePiece:
		FloorData.floor.HUD.showPieceInfo()
		FloorData.floor.HUD.updatePortrait()
		FloorData.floor.HUD.updateLabels()
	else:
		FloorData.floor.HUD.hidePieceInfo()

func endedTurn():
	for n in range(3):
		if mH.SH.playerTurn:
			FloorData.floor.HUD.turnHUD[n].modulate = Color(0.63,0.72,0.86)
		else:
			FloorData.floor.HUD.turnHUD[n].modulate = Color(0.86,0.63,0.72)

func usedAction():
	FloorData.floor.HUD.turnHUD[1].modulate = Color(0.5,0.5,0.5)
	mH.SH.actionUsed = true

func usedMovement():
	FloorData.floor.HUD.turnHUD[0].modulate = Color(0.5,0.5,0.5)
	mH.SH.moveUsed = true
