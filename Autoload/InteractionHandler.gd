extends Node

func _process(_delta: float):
	if Input.is_action_just_pressed("Select"):
		if GameState.tileDict["iTiles"].has(GameState.tileDict["hTile"]):
			if GameState.moving != null:
				movePiece(GameState.tileDict["hTile"], GameState.moving)
			elif GameState.action != null:
				useAction(GameState.tileDict["hTile"])
			elif GameState.item != null:
				useItem(GameState.tileDict["hTile"])

func movePiece(destination : tile, piece : MoveablePiece):
	var destinationReached : bool = false
	var closestDirection
	var destinationPos = GameState.tileDict["TilePos"][GameState.tileDict["Tiles"].find(destination)]
	if piece is PlayerPiece:
		TileHandler.stopShowing()
		closestDirection = DirectionHandler.getClosestDirection(PlayerData.playerInfo.currentPos, destinationPos)
	elif piece is EnemyPiece:
		closestDirection = DirectionHandler.getClosestDirection(GameState.pieceDict["Enemy"]["Position"][GameState.pieceDict["Enemy"]["Piece"].find(piece)], destinationPos)
	while(!destinationReached):
		var closestTile
		if piece is PlayerPiece:
			closestTile = TileHandler.lookForTile(PlayerData.playerInfo.currentPos + DirectionHandler.dirDict["PosData"][closestDirection])
		elif piece is EnemyPiece:
			closestTile = TileHandler.lookForTile(GameState.pieceDict["Enemy"]["Position"][GameState.pieceDict["Enemy"]["Piece"].find(piece)] + DirectionHandler.dirDict["PosData"][closestDirection])
		
		if closestTile.contains:
			if closestTile.contains is MoveablePiece:
				pushPiece(closestTile.contains, closestDirection)
		closestTile.setPiece(piece, closestDirection)
		if piece.currentTile == destination:
			destinationReached = true
			InterfaceHandler.usedMovement()
			if piece is PlayerPiece:
				InterfaceHandler.displayInfo()
				await get_tree().create_timer(0.01).timeout
				InterfaceHandler.openMenu()
			
		else:
			await get_tree().create_timer(0.3).timeout
	GameState.moving = null

func pushPiece(piece : MoveablePiece, direction : DirectionHandler.Direction):
	var currentTile
	if piece is PlayerPiece:
		currentTile = TileHandler.lookForTile(PlayerData.playerInfo.currentPos + DirectionHandler.dirDict["PosData"][direction])
	elif piece is EnemyPiece:
		currentTile = TileHandler.lookForTile(GameState.pieceDict["Enemy"]["Position"][GameState.pieceDict["Enemy"]["Piece"].find(piece)] + DirectionHandler.dirDict["PosData"][direction])
	if currentTile:
		currentTile.setPiece(piece, direction)
		@warning_ignore("integer_division")
		if int(piece.maxHealth / 10) < 1:
			piece.damage(1)
		else:
			@warning_ignore("integer_division")
			piece.damage(1 + int(piece.maxHealth / 10))
	else:
		@warning_ignore("integer_division")
		piece.damage(5 + int(piece.maxHealth / 4))

func useAction(destination : tile):
	destination.actionUsed(GameState.action)
	TileHandler.stopShowing()

	TileHandler.setTilePattern()
	GameState.action = null
	InterfaceHandler.usedAction()
	if GameState.playerTurn:
		InterfaceHandler.openMenu()

func useItem(destination : tile):
	GameState.item = null

func findMoveableTiles(piece : MoveablePiece):
	var possibleTiles = piece.type.getMoveableTiles(piece.currentTile.global_position)
	var currentTile
	var toReturn = []
	for n in range(possibleTiles.size()):
		if n%2 == 0:
			if TileHandler.lookForTile(possibleTiles[n]):
				currentTile = TileHandler.lookForTile(possibleTiles[n])
		else:
			if currentTile:
				if TileHandler.lookForTile(possibleTiles[n]):
					if (GameState.tileDict["iTiles"].has(TileHandler.lookForTile(possibleTiles[n])) or possibleTiles[n] == piece.currentTile.global_position):
						if TileHandler.lookForTile(possibleTiles[n]).contains is not MoveablePiece or TileHandler.lookForTile(possibleTiles[n]).contains == piece:
							toReturn.append(currentTile)
							if piece is PlayerPiece:
								GameState.tileDict["iTiles"].append(currentTile)
			currentTile = null
	return toReturn

func findActionTiles(piecePos : Vector3):
	var possibleTiles = GameState.action.getActionRange(piecePos)
	var toReturn = []
	for n in range(possibleTiles.size()):
		if TileHandler.lookForTile(possibleTiles[n]):
			toReturn.append(TileHandler.lookForTile(possibleTiles[n]))
	return toReturn

func findItemTiles(piecePos : Vector3):
	var possibleTiles = GameState.item.getItemRange(piecePos)
	var toReturn = []
	var usableOn = GameState.item.getUsable()
	for n in range(possibleTiles.size()):
		if TileHandler.lookForTile(possibleTiles[n]):
			if usableOn.has("Self") and TileHandler.lookForTile(possibleTiles[n]).contains is PlayerPiece:
				toReturn.append(TileHandler.lookForTile(possibleTiles[n]))
			elif usableOn.has("Enemy") and TileHandler.lookForTile(possibleTiles[n]).contains is EnemyPiece:
				toReturn.append(TileHandler.lookForTile(possibleTiles[n]))
			elif usableOn.has("Tile") and !TileHandler.lookForTile(possibleTiles[n]).contains:
				toReturn.append(TileHandler.lookForTile(possibleTiles[n]))
		
	return toReturn
