extends Handler

func _process(_delta: float):
	if Input.is_action_just_pressed("Select"):
		if mH.TH.tileDict["iTiles"].has(mH.TH.tileDict["hTile"]):
			if mH.SH.moving == true:
				movePiece(mH.TH.tileDict["hTile"])
			elif mH.SH.interactable != null:
				interact(mH.TH.tileDict["hTile"])

func movePiece(destination : tile):
	var piece = mH.SH.actingPiece
	var destinationReached : bool = false
	var closestDirection
	var destinationPos = mH.TH.tileDict["TilePos"][mH.TH.tileDict["Tiles"].find(destination)]
	if piece is PlayerPiece:
		mH.TH.stopShowing()
		closestDirection = mH.DH.getClosestDirection(PlayerData.playerInfo.currentPos, destinationPos)
	elif piece is EnemyPiece:
		closestDirection = mH.DH.getClosestDirection(FloorData.floorInfo.enemies[FloorData.floor.enemies.find(piece)].currentPos, destinationPos)
	while(!destinationReached):
		var closestTile
		if piece is PlayerPiece:
			closestTile = mH.TH.lookForTile(PlayerData.playerInfo.currentPos + mH.DH.dirDict["PosData"][closestDirection])
		elif piece is EnemyPiece:
			closestTile = mH.TH.lookForTile(FloorData.floorInfo.enemies[FloorData.floor.enemies.find(piece)].currentPos + mH.DH.dirDict["PosData"][closestDirection])
		
		if closestTile.contains:
			if closestTile.contains is MoveablePiece:
				pushPiece(closestTile.contains, closestDirection)
		closestTile.setPiece(piece, closestDirection)
		
		if closestTile.hazard:
			if closestTile.hazard.effectType == "OnTouch":
				if closestTile.hazard.effect.stopMovement:
					destination = piece.currentTile
		
		if piece.currentTile == destination:
			destinationReached = true
			mH.UH.usedMovement()
			if piece is PlayerPiece:
				mH.UH.displayInfo()
				await get_tree().create_timer(0.01).timeout
				mH.UH.openMenu()
			
		else:
			await get_tree().create_timer(0.3).timeout
	mH.SH.actingPiece = null
	mH.SH.moving = false

func pushPiece(piece : MoveablePiece, direction : int):
	var currentTile
	if piece is PlayerPiece:
		currentTile = mH.TH.lookForTile(PlayerData.playerInfo.currentPos + mH.DH.dirDict["PosData"][direction])
	elif piece is EnemyPiece:
		currentTile = mH.TH.lookForTile(FloorData.floorInfo.enemies[FloorData.floor.enemies.find(piece)].currentPos + mH.DH.dirDict["PosData"][direction])
	if currentTile:
		currentTile.setPiece(piece, direction)
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
