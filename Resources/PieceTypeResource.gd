extends Resource
class_name PieceTypeResource

@export var typeName : String
@export var movementCount : int
@export var skip : bool = false
@export_enum("Straight", "Diagonal", "Both", "L") var movementAngle : String

func getMoveableTiles(movementStart : Vector2i):
	var toReturn : Array[tile]
	var pos
	if movementAngle != "L":
		pos = FloorData.floor.Handlers.DH.getAll(movementAngle)
	else:
		pos = [Vector2i(1,2), Vector2i(-1,2), Vector2i(2,1), Vector2i(2,-1),
				Vector2i(1,-2), Vector2i(-1,-2), Vector2i(-2,1), Vector2i(-2,-1)]
	var tileData : Vector2i
	
	for n in range(pos.size()):
		tileData = movementStart
		var movementCounter = 1
		var endSearch = false
		while !endSearch:
			if movementAngle != "L":
				tileData += FloorData.floor.Handlers.DH.dirDict["PosData"][pos[n]]
			else:
				tileData += pos[n]
			
			if tileData.x >= FloorData.floorInfo.rc.x or tileData.y >= FloorData.floorInfo.rc.y or tileData.x < 0 or tileData.y < 0:
				endSearch = true
			else:
				var currentTile = FloorData.tiles[tileData.x][tileData.y]
				if currentTile != null:
					if !currentTile.obstructed:
						if currentTile.contains:
							if FloorData.floorInfo.playerTurn:
								if currentTile.contains is EnemyPiece:
									toReturn.append(FloorData.tiles[tileData.x][tileData.y])
							else:
								if currentTile.contains is PlayerPiece:
									toReturn.append(FloorData.tiles[tileData.x][tileData.y])
							endSearch = true
						else:
							toReturn.append(FloorData.tiles[tileData.x][tileData.y])
					else:
						endSearch = true
				else:
					endSearch = true
			
			if movementCounter == movementCount:
				endSearch = true
			
			movementCounter += 1
	
	return toReturn
