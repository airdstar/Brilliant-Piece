extends Handler

func _process(_delta: float):
	if Input.is_action_just_pressed("Select"):
		if mH.TH.tileDict["iTiles"].has(mH.TH.tileDict["hTile"]):
			if mH.SH.moving == true:
				movePiece(mH.TH.tileDict["hTile"], mH.SH.actingPiece)
			elif mH.SH.action != null:
				useAction(mH.TH.tileDict["hTile"])
			elif mH.SH.item != null:
				useItem(mH.TH.tileDict["hTile"])

func movePiece(destination : tile, piece : MoveablePiece):
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
		@warning_ignore("integer_division")
		if int(piece.maxHealth / 10) < 1:
			piece.damage(1)
		else:
			@warning_ignore("integer_division")
			piece.damage(1 + int(piece.maxHealth / 10))
		
		if currentTile.hazard:
			if currentTile.hazard.effectType == "OnTouch":
				print("hi")
	else:
		@warning_ignore("integer_division")
		piece.damage(5 + int(piece.maxHealth / 4))

func useAction(destination : tile):
	destination.actionUsed(mH.SH.action)
	mH.TH.stopShowing()
	mH.TH.setTilePattern()
	mH.SH.action = null
	mH.UH.usedAction()
	if FloorData.floorInfo.playerTurn:
		mH.UH.openMenu()

func useItem(destination : tile):
	destination.itemUsed(mH.SH.item)
	mH.TH.stopShowing()
	mH.TH.setTilePattern()
	mH.SH.item = null
	if FloorData.floorInfo.playerTurn:
		mH.UH.openMenu()

func findMoveableTiles(piece : MoveablePiece):
	var possibleTiles = piece.type.getMoveableTiles(piece.currentTile.global_position)
	var currentTile
	var toReturn = []
	for n in range(possibleTiles.size()):
		if n%2 == 0:
			if mH.TH.lookForTile(possibleTiles[n]):
				if !mH.TH.lookForTile(possibleTiles[n]).obstructed:
					currentTile = mH.TH.lookForTile(possibleTiles[n])
		else:
			if currentTile:
				if mH.TH.lookForTile(possibleTiles[n]):
					if (mH.TH.tileDict["iTiles"].has(mH.TH.lookForTile(possibleTiles[n])) or possibleTiles[n] == piece.currentTile.global_position):
						if mH.TH.lookForTile(possibleTiles[n]).contains is not MoveablePiece or mH.TH.lookForTile(possibleTiles[n]).contains == piece:
							toReturn.append(currentTile)
							if piece is PlayerPiece:
								mH.TH.tileDict["iTiles"].append(currentTile)
			currentTile = null
	return toReturn

func findItemTiles(piecePos : Vector3):
	var possibleTiles = mH.SH.item.getItemRange(piecePos)
	var toReturn = []
	var usableOn = mH.SH.item.getUsable()
	if usableOn.has("Self"):
		toReturn.append(mH.SH.actingPiece.currentTile)
	for n in range(possibleTiles.size()):
		if mH.TH.lookForTile(possibleTiles[n]):
			if usableOn.has("Enemy") and mH.TH.lookForTile(possibleTiles[n]).contains is EnemyPiece:
				toReturn.append(mH.TH.lookForTile(possibleTiles[n]))
			elif usableOn.has("Tile") and !mH.TH.lookForTile(possibleTiles[n]).contains:
				toReturn.append(mH.TH.lookForTile(possibleTiles[n]))
		
	return toReturn
