extends Resource
class_name PieceTypeResource

@export var typeName : String
@export var movementCount : int
@export_enum("Straight", "Diagonal", "Both", "L") var movementAngle : String

func getMoveableTiles(movementStart : Vector3):
	var toReturn : Array[tile]
	var pos = FloorData.floor.Handlers.DH.getAll(movementAngle)
	var tileData : Vector3
	
	for n in range(pos.size()):
		tileData = movementStart
		var movementCounter = 1
		var endSearch = false
		while !endSearch:
			tileData += FloorData.floor.Handlers.DH.dirDict["PosData"][pos[n]]
			if FloorData.floor.Handlers.TH.lookForTile(tileData):
				if !FloorData.floor.Handlers.TH.lookForTile(tileData).obstructed:
					toReturn.append(FloorData.floor.Handlers.TH.lookForTile(tileData))
				else:
					endSearch = true
			else:
				endSearch = true
			
			if movementCounter == movementCount:
				endSearch = true
			
			movementCounter += 1
	
	return toReturn
