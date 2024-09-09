extends Node

func _process(_delta: float):
	if !GameState.playerTurn:
		makeDecision()

func makeDecision():
	if !GameState.moveUsed:
		var bestMovement
		for n in range(GameState.enemyPieces.size()):
			var possibleTiles = MovementHandler.findMoveableTiles(GameState.enemyPieces[n])
			findBestMovement(GameState.playerPiece, possibleTiles, GameState.enemyPieces[n], "Approach")

func findBestMovement(target : MoveablePiece, possibleMovement, piece : EnemyPiece, behavior : String):
	behavior = "Approach"
	match behavior:
		"Approach":
			var closestTileDirection = DirectionHandler.getClosestDirection(piece.currentTile.global_position, target.currentTile.global_position)
			var closestExists := false
			for n in range(possibleMovement.size()):
				if possibleMovement[n] == TileHandler.lookForTile(piece.currentTile.global_position + DirectionHandler.getPos(closestTileDirection)):
					GameState.moving = piece
					var closestTile = findClosestTileToTarget(piece, target.currentTile.position, DirectionHandler.getPos(closestTileDirection))
					MovementHandler.movePiece(closestTile)
					InterfaceHandler.usedMovement()
					closestExists = true
			if !closestExists:
				for n in range(possibleMovement.size()):
					if possibleMovement[n] == TileHandler.lookForTile(piece.currentTile.global_position + DirectionHandler.getPos(DirectionHandler.getSides(closestTileDirection)[0])):
						GameState.moving = piece
						var closestTile = findClosestTileToTarget(piece, target.currentTile.position, DirectionHandler.getPos(DirectionHandler.getSides(closestTileDirection)[0]))
						MovementHandler.movePiece(closestTile)
						InterfaceHandler.usedMovement()
					elif possibleMovement[n] == TileHandler.lookForTile(piece.currentTile.global_position + DirectionHandler.getPos(DirectionHandler.getSides(closestTileDirection)[1])):
						GameState.moving = piece
						var closestTile = findClosestTileToTarget(piece, target.currentTile.position, DirectionHandler.getPos(DirectionHandler.getSides(closestTileDirection)[1]))
						MovementHandler.movePiece(closestTile)
						InterfaceHandler.usedMovement()

func findClosestTileToTarget(moving : MoveablePiece, target : Vector3, direction : Vector3):
	var closestTile
	var smallestVariation
	for n in range(moving.type.movementCount):
		var xVar = abs(target.x - (moving.global_position + direction * (n + 1)).x)
		var zVar = abs(target.z - (moving.global_position + direction * (n + 1)).z)
		if smallestVariation:
			if smallestVariation > xVar + zVar:
				if TileHandler.lookForTile(moving.currentTile.global_position + direction * (n + 1)):
					smallestVariation = xVar + zVar
					closestTile = TileHandler.lookForTile(moving.currentTile.global_position + direction * (n + 1))
		else:
			if TileHandler.lookForTile(moving.currentTile.global_position + direction * (n + 1)):
				smallestVariation = xVar + zVar
				closestTile = TileHandler.lookForTile(moving.currentTile.global_position + direction * (n + 1))
	
	return closestTile
