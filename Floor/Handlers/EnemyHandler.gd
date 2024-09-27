extends Handler

var possibleTiles = []

func makeDecision():
	if !FloorData.floorInfo.moveUsed:
		#findBestMovement(PlayerData.playerInfo.currentPos, FloorData.floor.enemies[0])
		FloorData.floorInfo.endTurn()
		
func findBestMovement(target : Vector3, piece : EnemyPiece):
	possibleTiles = piece.type.getMoveableTiles(FloorData.floorInfo.enemies[FloorData.floor.enemies.find(piece)].currentPos)
	piece.behavior = "Approach"
	match piece.behavior:
		"Approach":
			mH.IH.movePiece(findClosestTileToTarget(target, piece))

func findClosestTileToTarget(target : Vector3, piece : EnemyPiece):
	var piecePos = FloorData.floorInfo.enemies[FloorData.floor.enemies.find(piece)].currentPos
	var targetReached : bool = false
	var counter : int = 1
	var bestPath : Array[Vector3]
	while !targetReached:
		pass
	var closestTile
	FloorData.floor.Handlers.SH.actingPiece = piece
	return closestTile
