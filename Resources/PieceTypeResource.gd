extends Resource
class_name PieceTypeResource

@export var typeName : String
@export var movementCount : int
@export_enum("Straight", "Diagonal", "Both", "L") var movementAngle : String

func getMoveableTiles(movementStart : Vector3):
	var toReturn : Array[Vector3]
	var pos = FloorData.floor.Handlers.DH.getAll(movementAngle)
	
	for n in range(pos.size()):
		var tileData : Vector3 = movementStart
		var prevTile : Vector3 = movementStart
		for m in range(movementCount):
			tileData += FloorData.floor.Handlers.DH.dirDict["PosData"][pos[n]]
			toReturn.append(tileData)
			toReturn.append(prevTile)
			prevTile = tileData
	
	return toReturn
