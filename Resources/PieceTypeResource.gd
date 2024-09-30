extends Resource
class_name PieceTypeResource

@export var typeName : String
@export var movementCount : int
@export_enum("Straight", "Diagonal", "Both", "L") var movementAngle : String

func getMoveableTiles(movementStart : Vector2i):
	var toReturn : Array[tile]
	var pos = FloorData.floor.Handlers.DH.getAll(movementAngle)
	var tileData : Vector2i
	
	for n in range(pos.size()):
		tileData = movementStart
		var movementCounter = 1
		var endSearch = false
		while !endSearch:
			tileData += FloorData.floor.Handlers.DH.dirDict["PosData"][pos[n]]
			
			if tileData.x >= FloorData.floorInfo.rc.x or tileData.y >= FloorData.floorInfo.rc.y or tileData.x < 0 or tileData.y < 0:
				endSearch = true
			else:
				if FloorData.tiles[tileData.x][tileData.y] != null:
					if !FloorData.tiles[tileData.x][tileData.y].obstructed:
						toReturn.append(FloorData.tiles[tileData.x][tileData.y])
					else:
						endSearch = true
				else:
					endSearch = true
			
			if movementCounter == movementCount:
				endSearch = true
			
			movementCounter += 1
	
	return toReturn
