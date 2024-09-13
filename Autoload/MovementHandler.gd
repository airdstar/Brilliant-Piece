extends Node

func _process(_delta: float):
	if GameState.moving != null:
		if Input.is_action_just_pressed("Select"):
			if GameState.highlightedTile.moveable:
				movePiece(GameState.highlightedTile, GameState.moving)

func movePiece(destination : tile, piece : MoveablePiece):
	TileHandler.stopShowing()
	var destinationReached : bool = false
	var closestDirection = DirectionHandler.getClosestDirection(piece.currentTile.global_position, destination.global_position)
	while(!destinationReached):
		var closestTile = TileHandler.lookForTile(piece.currentTile.global_position + DirectionHandler.dirDict["PosData"][closestDirection])
		if closestTile.contains:
			if closestTile.contains is MoveablePiece:
				pushPiece(closestTile.contains, closestDirection)
		closestTile.setPiece(GameState.moving, closestDirection)
		if GameState.moving.currentTile == destination:
			destinationReached = true
			if GameState.moving is PlayerPiece:
				InterfaceHandler.usedMovement()
				InterfaceHandler.displayInfo()
				await get_tree().create_timer(0.01).timeout
				MenuHandler.openMenu()
			
		else:
			await get_tree().create_timer(0.3).timeout
	GameState.moving = null

func pushPiece(piece : MoveablePiece, direction : DirectionHandler.Direction):
	var currentTile = TileHandler.lookForTile(piece.currentTile.global_position + DirectionHandler.getPos(direction))
	if currentTile:
		currentTile.setPiece(piece)
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
				if (TileHandler.lookForTile(possibleTiles[n]) and TileHandler.lookForTile(possibleTiles[n]).moveable) or possibleTiles[n] == piece.currentTile.global_position:
					if TileHandler.lookForTile(possibleTiles[n]).contains is not MoveablePiece or TileHandler.lookForTile(possibleTiles[n]).contains == piece:
						toReturn.append(currentTile)
						if piece is PlayerPiece:
							currentTile.moveable = true
			currentTile = null
	return toReturn
