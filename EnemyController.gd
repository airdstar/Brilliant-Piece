extends Node

var possibleTiles
var tileValueHolder : Array[int]
var tileSearched : Array[bool]

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
			GameState.moving = piece
			MovementHandler.movePiece(findClosestTileToTarget(target.currentTile.global_position))
			GameState.endTurn()

func findClosestTileToTarget(target : Vector3):
	for n in range(GameState.allFloorTiles.size()):
		tileValueHolder.append(100)
		tileSearched.append(false)
		if TileHandler.lookForTile(target) == GameState.allFloorTiles[n]:
			tileValueHolder[n] = 0
			tileSearched[n] = true
	checkNearbyTiles(target, 1)
	var lowestDistance : int = 100
	var lowestDistanceAmount : int = 100
	for n in range(possibleTiles.size()):
		for m in range(GameState.allFloorTiles.size()):
			if GameState.allFloorTiles[m] == possibleTiles[n]:
				if lowestDistance != 100:
					if lowestDistanceAmount > tileValueHolder[m]:
						lowestDistance = m
						lowestDistanceAmount = tileValueHolder[m]
				else:
					lowestDistance = m
					lowestDistanceAmount = tileValueHolder[m]
	return GameState.allFloorTiles[lowestDistance]

func checkNearbyTiles(currentTile : Vector3, currentDistance : int):
	var foundATile : bool = false
	for n in range(4):
		for m in range(GameState.allFloorTiles.size()):
			if TileHandler.lookForTile(currentTile + DirectionHandler.getPos(DirectionHandler.getAll("Straight")[n])) == GameState.allFloorTiles[m]:
				if !tileSearched[m]:
					tileValueHolder[m] = currentDistance
					tileSearched[m] = true
					foundATile = true
					checkNearbyTiles(currentTile + DirectionHandler.getPos(DirectionHandler.getAll("Straight")[n]), currentDistance + 1)
	if !foundATile:
		return
