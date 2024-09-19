extends Node

var possibleTiles = []

func makeDecision():
	if !GameState.moveUsed:
		#findBestMovement(PlayerData.playerInfo.currentPos, GameState.pieceDict["Enemy"]["Piece"][0], GameState.pieceDict["Enemy"]["Behavior"][0])
		GameState.endTurn()
		

func findBestMovement(target : Vector3, piece : EnemyPiece, behavior : String):
	possibleTiles = MovementHandler.findMoveableTiles(piece)
	match behavior:
		"Approach":
			MovementHandler.movePiece(findClosestTileToTarget(target, piece), piece)
		"Away":
			MovementHandler.movePiece(findFurthestTileFromTarget(target, piece), piece)

func findClosestTileToTarget(target : Vector3, piece : EnemyPiece):
	var piecePos = GameState.pieceDict["Enemy"]["Position"][GameState.pieceDict["Enemy"]["Piece"].find(piece)]
	var orderedDirections = DirectionHandler.orderClosestDirections(DirectionHandler.getAll(piece.type.movementAngle), piecePos, target)
	var direction = orderedDirections[0]
	if piece.prevDirection == direction:
		direction = orderedDirections[1]
	piece.prevDirection = -1
	var prefDirection = direction
	if !GameState.tileDict["TilePos"].has(piecePos + DirectionHandler.dirDict["PosData"][direction]):
		var foundPath : bool = false
		var counter = 1
		while !foundPath:
			if GameState.tileDict["TilePos"].has(piecePos + DirectionHandler.dirDict["PosData"][direction] + (DirectionHandler.dirDict["PosData"][DirectionHandler.getSides(direction)[0]]) * (1 + counter)):
				if GameState.tileDict["TilePos"].has(piecePos + (DirectionHandler.dirDict["PosData"][DirectionHandler.getSides(direction)[0]]) * (1 + counter)):
					foundPath = true
					direction = DirectionHandler.getSides(direction)[0]
			elif GameState.tileDict["TilePos"].has(piecePos + DirectionHandler.dirDict["PosData"][direction] + (DirectionHandler.dirDict["PosData"][DirectionHandler.getSides(direction)[1]]) * (1 + counter)):
				if GameState.tileDict["TilePos"].has(piecePos + (DirectionHandler.dirDict["PosData"][DirectionHandler.getSides(direction)[1]]) * (1 + counter)):
					foundPath = true
					direction = DirectionHandler.getSides(direction)[1]
			counter += 1
	
	var closestTile : tile = TileHandler.lookForTile(piecePos + (DirectionHandler.dirDict["PosData"][direction]))
	var stopMovement : bool = false
	var smallestDistance = 200
	for n in range(piece.type.movementCount):
		if !stopMovement:
			var xVar = abs(target.x - (piecePos + (DirectionHandler.dirDict["PosData"][direction] * (1 + n))).x)
			var zVar = abs(target.z - (piecePos + (DirectionHandler.dirDict["PosData"][direction] * (1 + n))).z)
			if smallestDistance != 200:
				if prefDirection != direction:
					if GameState.tileDict["TilePos"].has(piecePos + (DirectionHandler.dirDict["PosData"][direction] * (1 + n)) + (DirectionHandler.dirDict["PosData"][prefDirection])):
						stopMovement = true
						piece.prevDirection = DirectionHandler.getOppDirection(direction)
					if GameState.tileDict["TilePos"].has(piecePos + (DirectionHandler.dirDict["PosData"][direction] * (1 + n))):
						closestTile = TileHandler.lookForTile(piecePos + (DirectionHandler.dirDict["PosData"][direction] * (1 + n)))
						
						
				else:
					if smallestDistance > xVar + zVar:
						if GameState.tileDict["TilePos"].has(piecePos + (DirectionHandler.dirDict["PosData"][direction] * (1 + n))):
							closestTile = TileHandler.lookForTile(piecePos + (DirectionHandler.dirDict["PosData"][direction] * (1 + n)))
							smallestDistance = xVar + zVar
				
			else:
				closestTile = TileHandler.lookForTile(piecePos + (DirectionHandler.dirDict["PosData"][direction] * (1 + n)))
				smallestDistance = xVar + zVar
	return closestTile

func findFurthestTileFromTarget(target : Vector3, piece : EnemyPiece):
	pass
