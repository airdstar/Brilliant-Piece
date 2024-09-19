extends Resource
class_name AOEResource

@export var name : String
@export_enum("Straight", "Diagonal", "Both", "Square", "Sides") var AOEdirection: String
@export_enum("None", "Forward", "Backward", "Both") var trailType : String
@export var AOErange : int = 1
@export var trailRange : int = 10


func getAOE(AOEstart : Vector3, relativeDir : int):
	var toReturn : Array[Vector3]
	var pos
	if AOEdirection != "Sides":
		pos = DirectionHandler.getAll(AOEdirection)
	else:
		pos = DirectionHandler.getSides(relativeDir)
	var tileData : Vector3
	for n in range(pos.size()):
		tileData = AOEstart
		for m in range(AOErange):
			tileData += DirectionHandler.dirDict["PosData"][pos[n]]
			toReturn.append(tileData)
			if AOEdirection == "Square":
				if n % 2 == 0:
					var counter = m
					while counter > 0:
						toReturn.append(tileData + DirectionHandler.dirDict["PosData"][DirectionHandler.getSides(pos[n])[0]] * counter)
						toReturn.append(tileData + DirectionHandler.dirDict["PosData"][DirectionHandler.getSides(pos[n])[1]] * counter)
						counter -= 1
	for n in range(trailRange):
		pass
	return toReturn
