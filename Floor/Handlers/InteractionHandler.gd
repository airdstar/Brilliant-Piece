extends Handler

func _process(_delta: float):
	if mH.SH.moving == true or mH.SH.interactable != null:
		if Input.is_action_just_pressed("Select"):
			if mH.TH.iTiles.has(mH.TH.highlightedTile):
				if mH.SH.moving == true:
					movePiece(mH.TH.highlightedTile)
				elif mH.SH.interactable != null:
					interact(mH.TH.highlightedTile)

func movePiece(destination : tile):
	var piece = mH.SH.actingPiece
	if piece is PlayerPiece:
		mH.TH.stopShowing()
	
	var closestDirection = mH.DH.getClosestDirection(piece.rc, destination.rc)
	var posData = mH.DH.dirDict["PosData"][closestDirection]
	
	if destination.contains:
		if destination.contains is MoveablePiece:
			pushPiece(destination.contains, closestDirection)
	
	# Determine tiles that would be touched
	if destination.hazard:
		if destination.hazard.effectType == "OnTouch":
			if destination.hazard.effect.stopMovement:
				destination.rc = piece.rc
	
	destination.setPiece(piece, 1)
	mH.UH.usedMovement()
	if piece is PlayerPiece:
		mH.UH.displayInfo()
		await get_tree().create_timer(0.01).timeout
		mH.UH.openMenu()
			
	
	mH.SH.actingPiece = null
	mH.SH.moving = false

func pushPiece(piece : MoveablePiece, direction : int):
	var currentTile = FloorData.tiles[piece.rc.x + mH.DH.dirDict["PosData"][direction].x][piece.rc.y + mH.DH.dirDict["PosData"][direction].y]
	if currentTile:
		currentTile.setPiece(piece, 1)
		if int(piece.maxHealth / 10) < 1:
			piece.damage(1)
		else:
			piece.damage(1 + int(piece.maxHealth / 10))
		if currentTile.hazard:
			if currentTile.hazard.effectType == "OnTouch":
				print("hi")
	else:
		piece.damage(5 + int(piece.maxHealth / 4))

func interact(destination : tile):
	destination.interact()
	mH.TH.stopShowing()
	mH.TH.setTilePattern()
	
	if FloorData.floorInfo.playerTurn:
		mH.UH.openMenu()
