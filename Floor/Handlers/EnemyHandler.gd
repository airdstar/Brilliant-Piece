extends Handler

var possibleTiles = []

func makeDecision():
	if !FloorData.floorInfo.moveUsed:
		#findBestMovement(PlayerData.playerInfo.currentPos, GameState.pieceDict["Enemy"]["Piece"][0], GameState.pieceDict["Enemy"]["Behavior"][0])
		mH.SH.endTurn()
		
func findBestMovement(target : Vector3, piece : EnemyPiece, behavior : String):
	possibleTiles = mH.IH.findMoveableTiles(piece)
	match behavior:
		"Approach":
			mH.IH.movePiece(findClosestTileToTarget(target, piece), piece)

func findClosestTileToTarget(target : Vector3, piece : EnemyPiece):
	var piecePos = FloorData.floorInfo.enemies[FloorData.floor.enemies.find(piece)].currentPos
	var orderedDirections = mH.DH.orderClosestDirections(mH.DH.getAll(piece.type.movementAngle), piecePos, target)
	var direction = orderedDirections[0]
	if piece.prevDirection == direction:
		direction = orderedDirections[1]
	piece.prevDirection = -1
	var prefDirection = direction
	if !mH.TH.tileDict["TilePos"].has(piecePos + mH.DH.dirDict["PosData"][direction]):
		var foundPath : bool = false
		var counter = 1
		while !foundPath:
			if mH.TH.tileDict["TilePos"].has(piecePos + mH.DH.dirDict["PosData"][direction] + (mH.DH.dirDict["PosData"][mH.DH.getSides(direction)[0]]) * (1 + counter)):
				if mH.TH.tileDict["TilePos"].has(piecePos + (mH.DH.dirDict["PosData"][mH.DH.getSides(direction)[0]]) * (1 + counter)):
					foundPath = true
					direction = mH.DH.getSides(direction)[0]
			elif mH.TH.tileDict["TilePos"].has(piecePos + mH.DH.dirDict["PosData"][direction] + (mH.DH.dirDict["PosData"][mH.DH.getSides(direction)[1]]) * (1 + counter)):
				if mH.TH.tileDict["TilePos"].has(piecePos + (mH.DH.dirDict["PosData"][mH.DH.getSides(direction)[1]]) * (1 + counter)):
					foundPath = true
					direction = mH.DH.getSides(direction)[1]
			counter += 1
	
	var closestTile : tile = mH.TH.lookForTile(piecePos + (mH.DH.dirDict["PosData"][direction]))
	var stopMovement : bool = false
	var smallestDistance = 200
	for n in range(piece.type.movementCount):
		if !stopMovement:
			var xVar = abs(target.x - (piecePos + (mH.DH.dirDict["PosData"][direction] * (1 + n))).x)
			var zVar = abs(target.z - (piecePos + (mH.DH.dirDict["PosData"][direction] * (1 + n))).z)
			if smallestDistance != 200:
				if prefDirection != direction:
					if mH.TH.tileDict["TilePos"].has(piecePos + (mH.DH.dirDict["PosData"][direction] * (1 + n)) + (mH.DH.dirDict["PosData"][prefDirection])):
						stopMovement = true
						piece.prevDirection = mH.DH.getOppDirection(direction)
					if mH.TH.tileDict["TilePos"].has(piecePos + (mH.DH.dirDict["PosData"][direction] * (1 + n))):
						closestTile = mH.TH.lookForTile(piecePos + (mH.DH.dirDict["PosData"][direction] * (1 + n)))
						
						
				else:
					if smallestDistance > xVar + zVar:
						if mH.TH.tileDict["TilePos"].has(piecePos + (mH.DH.dirDict["PosData"][direction] * (1 + n))):
							closestTile = mH.TH.lookForTile(piecePos + (mH.DH.dirDict["PosData"][direction] * (1 + n)))
							smallestDistance = xVar + zVar
				
			else:
				closestTile = mH.TH.lookForTile(piecePos + (mH.DH.dirDict["PosData"][direction] * (1 + n)))
				smallestDistance = xVar + zVar
	return closestTile
