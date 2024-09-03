extends Resource
class_name PieceTypeResource

@export var typeName : String
@export var movementCount : int
@export_enum("Straight", "Diagonal", "Both", "L") var movementAngle : String

func getMoveableTiles(movementStart : Vector3):
	var toReturn : Array[Vector3]
	var directions
	var pos
	
	if movementAngle == "Straight" or movementAngle == "L":
		directions = 4
		pos = Directions.getAllStraight()
	elif movementAngle == "Diagonal":
		directions = 4
		pos = Directions.getAllDiagonal()
	elif movementAngle == "Both":
		directions = 8
		pos = Directions.getAllDirections()
	
	for n in range(directions):
		var tileData : Vector3 = movementStart
		var prevTile : Vector3 = movementStart
		for m in range(movementCount):
			tileData += Directions.getDirection(pos[n])
			toReturn.append(tileData)
			toReturn.append(prevTile)
			prevTile = tileData
	
	return toReturn
