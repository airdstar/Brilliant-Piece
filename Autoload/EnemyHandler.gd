extends Node

func makeDecision():
	if !area.moveUsed:
		var bestMovement
		for n in range(controllable.size()):
			var possibleTiles = area.findMoveableTiles(controllable[n], true)
			findBestMovement(targets[0], possibleTiles, controllable[n], controllableBehavior[n])

func findBestMovement(target : MoveablePiece, possibleMovement, piece : EnemyPiece, behavior : String):
	match behavior:
		"Approach":
			var closestTileDirection = DirectionHandler.getClosestDirection(piece.currentTile.global_position, target.currentTile.global_position)
			var closestExists := false
			for n in range(possibleMovement.size()):
				if possibleMovement[n] == area.lookForTile(piece.currentTile.global_position + DirectionHandler.getPos(closestTileDirection)):
					area.moving = piece
					var closestTile = area.findClosestTileToTarget(target.currentTile.position, DirectionHandler.getPos(closestTileDirection))
					area.movePiece(closestTile)
					area.usedMove()
					closestExists = true
			if !closestExists:
				for n in range(possibleMovement.size()):
					if possibleMovement[n] == area.lookForTile(piece.currentTile.global_position + DirectionHandler.getPos(DirectionHandler.getSides(closestTileDirection)[0])):
						area.moving = piece
						var closestTile = area.findClosestTileToTarget(target.currentTile.position, DirectionHandler.getPos(DirectionHandler.getSides(closestTileDirection)[0]))
						area.movePiece(closestTile)
						area.usedMove()
					elif possibleMovement[n] == area.lookForTile(piece.currentTile.global_position + DirectionHandler.getPos(DirectionHandler.getSides(closestTileDirection)[1])):
						area.moving = piece
						var closestTile = area.findClosestTileToTarget(target.currentTile.position, DirectionHandler.getPos(DirectionHandler.getSides(closestTileDirection)[1]))
						area.movePiece(closestTile)
						area.usedMove()
