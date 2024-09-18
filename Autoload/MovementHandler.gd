extends Node

func _process(_delta: float):
	if GameState.moving != null:
		if Input.is_action_just_pressed("Select"):
			if GameState.tileDict["iTiles"].has(GameState.tileDict["hTile"]):
				movePiece(GameState.tileDict["hTile"], GameState.moving)

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
				MenuHandler.openMenu()
			
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
