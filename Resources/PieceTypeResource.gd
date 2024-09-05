extends Resource
class_name PieceTypeResource

@export var typeName : String
@export var movementCount : int
@export_enum("Straight", "Diagonal", "Both", "L") var movementAngle : String

func getMoveableTiles(movementStart : Vector3):
	var toReturn : Array[Vector3]
	var pos = DirectionHandler.getAll(movementAngle)
	var directions = pos.size()
	
	for n in range(directions):
		var tileData : Vector3 = movementStart
		var prevTile : Vector3 = movementStart
		for m in range(movementCount):
			tileData += DirectionHandler.getPos(pos[n])
			toReturn.append(tileData)
			toReturn.append(prevTile)
			prevTile = tileData
	
	return toReturn
