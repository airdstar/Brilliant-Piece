extends Node

var possibleTiles

func _process(_delta: float):
	if !GameState.playerTurn:
		makeDecision()

func makeDecision():
	if !GameState.moveUsed:
		var bestMovement
		for n in range(GameState.enemyPieces.size()):
			possibleTiles = MovementHandler.findMoveableTiles(GameState.enemyPieces[n])
			findBestMovement(GameState.playerPiece, GameState.enemyPieces[n], "Approach")

func findBestMovement(target : MoveablePiece, piece : EnemyPiece, behavior : String):
	match behavior:
		"Approach":
			var closestTileDirection = DirectionHandler.getClosestDirection(piece.currentTile.global_position, target.currentTile.global_position)
			print(closestTileDirection)
			var closestExists := false
			GameState.moving = piece
			for n in range(possibleTiles.size()):
				if GameState.moving != null:
					if possibleTiles[n] == findClosestTileToTarget(target.currentTile.position, DirectionHandler.getPos(closestTileDirection)):
						MovementHandler.movePiece(possibleTiles[n])
						InterfaceHandler.usedMovement()
						closestExists = true
			if !closestExists:
				for n in range(possibleTiles.size()):
					if GameState.moving != null:
						if possibleTiles[n] == findClosestTileToTarget(target.currentTile.position, DirectionHandler.getPos(DirectionHandler.getSides(closestTileDirection)[0])):
							MovementHandler.movePiece(possibleTiles[n])
							InterfaceHandler.usedMovement()
						elif possibleTiles[n] == findClosestTileToTarget(target.currentTile.position, DirectionHandler.getPos(DirectionHandler.getSides(closestTileDirection)[1])):
							MovementHandler.movePiece(possibleTiles[n])
							InterfaceHandler.usedMovement()

func findClosestTileToTarget(target : Vector3, direction : Vector3):
	var closestTile
	var smallestVariation
	for n in range(GameState.moving.type.movementCount):
		var xVar = abs(target.x - (GameState.moving.global_position + direction * (n + 1)).x)
		var zVar = abs(target.z - (GameState.moving.global_position + direction * (n + 1)).z)
		if smallestVariation:
			if smallestVariation > xVar + zVar:
				if TileHandler.lookForTile(GameState.moving.currentTile.global_position + direction * (n + 1)):
					smallestVariation = xVar + zVar
					closestTile = TileHandler.lookForTile(GameState.moving.currentTile.global_position + direction * (n + 1))
		else:
			if TileHandler.lookForTile(GameState.moving.currentTile.global_position + direction * (n + 1)):
				smallestVariation = xVar + zVar
				closestTile = TileHandler.lookForTile(GameState.moving.currentTile.global_position + direction * (n + 1))
	
	return closestTile
