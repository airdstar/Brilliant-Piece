extends Node

var possibleTiles = []
var Handlers

func _ready():
	Handlers = FloorData.floor.Handlers

func makeDecision():
	if !FloorData.floor.Handlers.SH.moveUsed:
		#findBestMovement(PlayerData.playerInfo.currentPos, GameState.pieceDict["Enemy"]["Piece"][0], GameState.pieceDict["Enemy"]["Behavior"][0])
		FloorData.floor.Handlers.SH.endTurn()
		
func findBestMovement(target : Vector3, piece : EnemyPiece, behavior : String):
	possibleTiles = Handlers.IH.findMoveableTiles(piece)
	match behavior:
		"Approach":
			Handlers.IH.movePiece(findClosestTileToTarget(target, piece), piece)

func findClosestTileToTarget(target : Vector3, piece : EnemyPiece):
	var piecePos = FloorData.floorInfo.enemies[FloorData.floor.enemies.find(piece)].currentPos
	var orderedDirections = Handlers.DH.orderClosestDirections(Handlers.DH.getAll(piece.type.movementAngle), piecePos, target)
	var direction = orderedDirections[0]
	if piece.prevDirection == direction:
		direction = orderedDirections[1]
	piece.prevDirection = -1
	var prefDirection = direction
	if !Handlers.TH.tileDict["TilePos"].has(piecePos + Handlers.DH.dirDict["PosData"][direction]):
		var foundPath : bool = false
		var counter = 1
		while !foundPath:
			if Handlers.TH.tileDict["TilePos"].has(piecePos + Handlers.DH.dirDict["PosData"][direction] + (Handlers.DH.dirDict["PosData"][Handlers.DH.getSides(direction)[0]]) * (1 + counter)):
				if Handlers.TH.tileDict["TilePos"].has(piecePos + (Handlers.DH.dirDict["PosData"][Handlers.DH.getSides(direction)[0]]) * (1 + counter)):
					foundPath = true
					direction = Handlers.DH.getSides(direction)[0]
			elif Handlers.TH.tileDict["TilePos"].has(piecePos + Handlers.DH.dirDict["PosData"][direction] + (Handlers.DH.dirDict["PosData"][Handlers.DH.getSides(direction)[1]]) * (1 + counter)):
				if Handlers.TH.tileDict["TilePos"].has(piecePos + (Handlers.DH.dirDict["PosData"][Handlers.DH.getSides(direction)[1]]) * (1 + counter)):
					foundPath = true
					direction = Handlers.DH.getSides(direction)[1]
			counter += 1
	
	var closestTile : tile = Handlers.TH.lookForTile(piecePos + (Handlers.DH.dirDict["PosData"][direction]))
	var stopMovement : bool = false
	var smallestDistance = 200
	for n in range(piece.type.movementCount):
		if !stopMovement:
			var xVar = abs(target.x - (piecePos + (Handlers.DH.dirDict["PosData"][direction] * (1 + n))).x)
			var zVar = abs(target.z - (piecePos + (Handlers.DH.dirDict["PosData"][direction] * (1 + n))).z)
			if smallestDistance != 200:
				if prefDirection != direction:
					if Handlers.TH.tileDict["TilePos"].has(piecePos + (Handlers.DH.dirDict["PosData"][direction] * (1 + n)) + (Handlers.DH.dirDict["PosData"][prefDirection])):
						stopMovement = true
						piece.prevDirection = Handlers.DH.getOppDirection(direction)
					if Handlers.TH.tileDict["TilePos"].has(piecePos + (Handlers.DH.dirDict["PosData"][direction] * (1 + n))):
						closestTile = Handlers.TH.lookForTile(piecePos + (Handlers.DH.dirDict["PosData"][direction] * (1 + n)))
						
						
				else:
					if smallestDistance > xVar + zVar:
						if Handlers.TH.tileDict["TilePos"].has(piecePos + (Handlers.DH.dirDict["PosData"][direction] * (1 + n))):
							closestTile = Handlers.TH.lookForTile(piecePos + (Handlers.DH.dirDict["PosData"][direction] * (1 + n)))
							smallestDistance = xVar + zVar
				
			else:
				closestTile = Handlers.TH.lookForTile(piecePos + (Handlers.DH.dirDict["PosData"][direction] * (1 + n)))
				smallestDistance = xVar + zVar
	return closestTile

func findFurthestTileFromTarget(target : Vector3, piece : EnemyPiece):
	pass
