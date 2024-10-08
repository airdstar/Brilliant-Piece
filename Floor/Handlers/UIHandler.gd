extends Handler

var currentMenu = null

func _process(_delta):
	if currentMenu != null:
		if Input.is_action_just_pressed("Menu"):
			if !FloorData.floor.Handlers.SH.interactable and !FloorData.floor.Handlers.SH.moving:
				if !FloorData.floorInfo.actionUsed and currentMenu.currentTab == 0:
					currentMenu.selectOption()
				elif currentMenu.currentTab == 1:
					currentMenu.selectOption()
			else:
				unselect()


func unselect():
	if FloorData.floor.Handlers.SH.interactable:
		if FloorData.floorInfo.playerTurn:
			if currentMenu.options[currentMenu.highlightedOption] == FloorData.floor.Handlers.SH.interactable:
				mH.TH.stopShowing()
			else:
				currentMenu.selectOption()
	elif FloorData.floor.Handlers.SH.moving:
		if FloorData.floorInfo.playerTurn:
			mH.TH.stopShowing()

func displayInfo():
	if mH.TH.highlightedTile != null:
		if mH.TH.highlightedTile.contains is MoveablePiece:
			FloorData.floor.HUD.showPieceInfo()
			FloorData.floor.HUD.updateLabels()
		else:
			FloorData.floor.HUD.hidePieceInfo()
	else:
		FloorData.floor.HUD.hidePieceInfo()

func setTurnColors():
	for n in range(3):
		if FloorData.floorInfo.playerTurn:
			FloorData.floor.HUD.turnHUD[n].modulate = Color(0.63,0.72,0.86)
		else:
			FloorData.floor.HUD.turnHUD[n].modulate = Color(0.86,0.63,0.72)
	if FloorData.floorInfo.actionUsed:
		FloorData.floor.HUD.turnHUD[1].modulate = Color(0.5,0.5,0.5)
	if FloorData.floorInfo.moveUsed:
		FloorData.floor.HUD.turnHUD[0].modulate = Color(0.5,0.5,0.5)
	

func usedAction():
	FloorData.floor.HUD.turnHUD[1].modulate = Color(0.5,0.5,0.5)
	FloorData.floorInfo.actionUsed = true

func usedMovement():
	FloorData.floor.HUD.turnHUD[0].modulate = Color(0.5,0.5,0.5)
	FloorData.floorInfo.moveUsed = true
