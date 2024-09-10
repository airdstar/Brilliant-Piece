extends Node

func _process(_delta: float):
	if GameState.moving != null:
		if Input.is_action_just_pressed("Select"):
			if GameState.highlightedTile.moveable:
				movePiece(GameState.highlightedTile)

func movePiece(destination : tile):
	TileHandler.stopShowing()
	var destinationReached : bool = false
	var startingPos = GameState.moving.currentTile
	var counter : int = 0
	var closestDirection = DirectionHandler.getClosestDirection(GameState.moving.currentTile.global_position, destination.global_position)
	while(!destinationReached):
		var closestTile = TileHandler.lookForTile(GameState.moving.currentTile.global_position + DirectionHandler.getPos(closestDirection))
		#print(closestDirection)
		if closestTile.contains:
			if closestTile.contains is MoveablePiece:
				pushPiece(closestTile.contains, closestDirection)
		GameState.moving.previousTile = GameState.moving.currentTile
		GameState.moving.previousTile.contains = null
		closestTile.setPiece(GameState.moving)
		GameState.moving.setPieceOrientation(closestDirection)
		if GameState.moving is PlayerPiece:
			HighlightHandler.highlightTile(GameState.moving.currentTile)
		if GameState.moving.currentTile == destination:
			if GameState.moving is PlayerPiece:
				GameState.playerFloorTile = destination
				InterfaceHandler.usedMovement()
				InterfaceHandler.displayInfo()
				GameState.currentFloor.Pointer.height = GameState.highlightedTile.getPointerPos()
				await get_tree().create_timer(0.01).timeout
				MenuHandler.openMenu()
				
			destinationReached = true
		else:
			await get_tree().create_timer(0.3).timeout
		
		counter += 1
		if counter == 10:
			destinationReached = true
			startingPos.setPiece(GameState.moving)
			print("ERROR")
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
