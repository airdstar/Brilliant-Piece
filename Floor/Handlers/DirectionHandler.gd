extends Handler

enum Direction {
	NORTH,
	NORTHWEST,
	WEST,
	SOUTHWEST,
	SOUTH,
	SOUTHEAST,
	EAST,
	NORTHEAST
}

var dirDict : Dictionary

func _ready():
	var dirPosArray : Array[Vector2i] = [Vector2i(0,1), Vector2i(1,1), Vector2i(1,0), Vector2i(1,-1),
										Vector2i(0,-1), Vector2i(-1,-1), Vector2i(-1,0), Vector2i(-1,1)]
	
	var dirRotationArray : Array[int] = [-90, -45, 0, 45, 90, 135, 180, -135]
	
	var dirArray : Array[Direction] = [Direction.NORTH, Direction.NORTHWEST, Direction.WEST,
								   Direction.SOUTHWEST, Direction.SOUTH, Direction.SOUTHEAST,
								   Direction.EAST, Direction.NORTHEAST]
	
	dirDict = {"Direction" : dirArray, "PosData" : dirPosArray, "RotData" : dirRotationArray}
	
	mH = get_parent()

func getDiagonals(dir : Direction):
	if dir == 0:
		return [dirDict["Direction"][dir + 1], dirDict["Direction"][7]]
	else:
		return [dirDict["Direction"][dir + 1], dirDict["Direction"][dir - 1]]

func getSides(dir : Direction):
	if dir%2 == 0:
		if dir == 0:
			return [dirDict["Direction"][dir + 2], dirDict["Direction"][6]]
		elif dir == 6:
			return [dirDict["Direction"][0], dirDict["Direction"][dir - 2]]
		else:
			return [dirDict["Direction"][dir + 2], dirDict["Direction"][dir - 2]]
			
	else:
		if dir != 7:
			return [dirDict["Direction"][dir + 1], dirDict["Direction"][dir - 1]]
		else:
			return [dirDict["Direction"][0], dirDict["Direction"][dir - 1]]

func getAll(dir : String):
	match dir:
		"Straight", "Cone", "L":
			return [dirDict["Direction"][0], dirDict["Direction"][2], dirDict["Direction"][4], dirDict["Direction"][6]]
		"Diagonal":
			return [dirDict["Direction"][1], dirDict["Direction"][3], dirDict["Direction"][5], dirDict["Direction"][7]]
		"Both", "Circle", "Square":
			return dirDict["Direction"]

func getOppDirection(dir : Direction):
	if dir < 4:
		return dirDict["Direction"][dir + 4]
	else:
		return dirDict["Direction"][dir - 4]

func getClosestDirection(start : Vector2i, target : Vector2i):
	var closestDirection : Direction
	var smallestVariation : int = 100
	for n in range(8):
		var counter = 0
		var sameDirection = true
		var helper = start + dirDict["PosData"][n]
		if helper == target:
			return dirDict["Direction"][n]
		while sameDirection:
			var xVar = abs(target.x - (helper + (dirDict["PosData"][n] * (1 + counter))).x)
			var zVar = abs(target.y - (helper + (dirDict["PosData"][n] * (1 + counter))).y)
			if smallestVariation != 200:
				if smallestVariation > xVar + zVar:
					closestDirection = dirDict["Direction"][n]
					smallestVariation = xVar + zVar
					sameDirection = false
				elif smallestVariation == xVar + zVar:
					counter += 1
				else:
					sameDirection = false
			else:
				closestDirection = dirDict["Direction"][n]
				smallestVariation = xVar + zVar
				sameDirection = false
	
	return closestDirection

func orderClosestDirections(dir : Array, start : Vector3, target : Vector3):
	var toReturn : Array[int]
	var remain = dir
	for m in range(dir.size()):
		var smallestVariation : int = 200
		var closestDirection
		for n in range(remain.size()):
			var counter = 0
			var sameDirection = true
			while sameDirection:
				var xVar = abs(target.x - (start + (dirDict["PosData"][remain[n]] * (1 + counter))).x)
				var zVar = abs(target.z - (start + (dirDict["PosData"][remain[n]] * (1 + counter))).z)
				if smallestVariation != 200:
					if smallestVariation > xVar + zVar:
						closestDirection = remain[n]
						smallestVariation = xVar + zVar
						sameDirection = false
					elif smallestVariation == xVar + zVar:
						counter += 1
					else:
						sameDirection = false
				else:
					closestDirection = remain[n]
					smallestVariation = xVar + zVar
					sameDirection = false
		remain.erase(closestDirection)
		toReturn.append(closestDirection)
	return toReturn
