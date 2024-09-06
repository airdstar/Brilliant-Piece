extends Node

func _process(_delta: float) -> void:
	if !GameState.playerTurn:
		pass

func makeDecision():
	if !GameState.moveUsed:
		var bestMovement
		for n in range(GameState.enemyPieces.size()):
			var possibleTiles = TileHandler.findMoveableTiles(GameState.enemyPieces[n], true)
			findBestMovement(GameState.playerPiece, possibleTiles, GameState.enemyPieces[n], GameState.enemyBehavior[n])

func findBestMovement(target : MoveablePiece, possibleMovement, piece : EnemyPiece, behavior : String):
	match behavior:
		"Approach":
			var closestTileDirection = DirectionHandler.getClosestDirection(piece.currentTile.global_position, target.currentTile.global_position)
			var closestExists := false
			for n in range(possibleMovement.size()):
				if possibleMovement[n] == TileHandler.lookForTile(piece.currentTile.global_position + DirectionHandler.getPos(closestTileDirection)):
					GameState.moving = piece
					var closestTile = TileHandler.findClosestTileToTarget(target.currentTile.position, DirectionHandler.getPos(closestTileDirection))
					MovementHandler.movePiece(closestTile)
					GameState.usedMove()
					closestExists = true
			if !closestExists:
				for n in range(possibleMovement.size()):
					if possibleMovement[n] == TileHandler.lookForTile(piece.currentTile.global_position + DirectionHandler.getPos(DirectionHandler.getSides(closestTileDirection)[0])):
						GameState.moving = piece
						var closestTile = TileHandler.findClosestTileToTarget(target.currentTile.position, DirectionHandler.getPos(DirectionHandler.getSides(closestTileDirection)[0]))
						MovementHandler.movePiece(closestTile)
						GameState.usedMove()
					elif possibleMovement[n] == TileHandler.lookForTile(piece.currentTile.global_position + DirectionHandler.getPos(DirectionHandler.getSides(closestTileDirection)[1])):
						GameState.moving = piece
						var closestTile = TileHandler.findClosestTileToTarget(target.currentTile.position, DirectionHandler.getPos(DirectionHandler.getSides(closestTileDirection)[1]))
						MovementHandler.movePiece(closestTile)
						GameState.usedMove()
