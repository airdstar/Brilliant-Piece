extends Handler

func _process(_delta: float):
	if mH.SH.moving == true or mH.SH.interactable != null:
		if Input.is_action_just_pressed("Select"):
			if mH.TH.iTiles.has(mH.TH.highlightedTile):
				interact(mH.TH.highlightedTile)
			elif mH.SH.moving == true and mH.TH.highlightedTile.contains is PlayerPiece:
				mH.TH.stopShowing()
	else:
		if Input.is_action_just_pressed("Select"):
			if !FloorData.floorInfo.moveUsed:
				if mH.TH.highlightedTile != null:
					if mH.TH.highlightedTile.contains is PlayerPiece:
						mH.SH.actingPiece = mH.TH.highlightedTile.contains
						mH.SH.moving = true
						mH.TH.show()
		

func movePiece(destination : tile):
	var piece = mH.SH.actingPiece
	if piece is PlayerPiece:
		mH.TH.stopShowing()
	
	var closestDirection = mH.DH.getClosestDirection(piece.rc, destination.rc)
	var posData = mH.DH.dirDict["PosData"][closestDirection]
	var currentTile : tile = FloorData.tiles[piece.rc.x][piece.rc.y]
	
	while currentTile != destination:
		
		currentTile = FloorData.tiles[currentTile.rc.x + posData.x][currentTile.rc.y + posData.y]
		
		if currentTile.hazard:
			if currentTile.hazard.effectType == "OnTouch":
				if currentTile.hazard.effect.stopMovement:
					destination = currentTile
	
	if destination.contains:
		if destination.contains is MoveablePiece:
			pushPiece(destination.contains, closestDirection)
	
	destination.setPiece(piece, 1)
	mH.UH.usedMovement()
	if piece is PlayerPiece:
		mH.UH.displayInfo()
			
	mH.SH.actingPiece = null
	mH.SH.moving = false
	FloorData.updateData()

func pushPiece(piece : MoveablePiece, direction : int):
	var currentTile = FloorData.tiles[piece.rc.x + mH.DH.dirDict["PosData"][direction].x][piece.rc.y + mH.DH.dirDict["PosData"][direction].y]
	if currentTile:
		currentTile.setPiece(piece, 1)
		piece.damage(1)
		if currentTile.hazard:
			if currentTile.hazard.effectType == "OnTouch":
				print("hi")
	else:
		piece.damage(5 + int(piece.maxHealth / 4))

func interact(destination : tile):
	if mH.SH.moving == true:
		movePiece(destination)
	else:
		destination.interact()
	mH.TH.stopShowing()
	mH.TH.setTilePattern()
