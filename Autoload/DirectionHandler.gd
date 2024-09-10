extends Node

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

var dirArray : Array[Direction] = [Direction.NORTH, Direction.NORTHWEST, Direction.WEST,
								   Direction.SOUTHWEST, Direction.SOUTH, Direction.SOUTHEAST,
								   Direction.EAST, Direction.NORTHEAST]

func getPos(dir : Direction):
	var toReturn : Vector3 = Vector3.ZERO
	if dir == 0 or dir == 1 or dir == 7:
		toReturn += Vector3(0,0,1)
	elif dir == 3 or dir == 4 or dir == 5:
		toReturn += Vector3(0,0,-1)
	
	if dir == 1 or dir == 2 or dir == 3:
		toReturn += Vector3(1,0,0)
	elif dir == 5 or dir == 6 or dir == 7:
		toReturn += Vector3(-1,0,0)
	
	return toReturn

func getDiagonals(dir : Direction):
	if dir == 0:
		return [dirArray[dir + 1], dirArray[7]]
	else:
		return [dirArray[dir + 1], dirArray[dir - 1]]

func getSides(dir : Direction):
	if dir%2 == 0:
		if dir == 0:
			return [dirArray[dir + 2], dirArray[6]]
		elif dir == 6:
			return [dirArray[0], dirArray[dir - 2]]
		else:
			return [dirArray[dir + 2], dirArray[dir - 2]]
			
	else:
		if dir != 7:
			return [dirArray[dir + 1], dirArray[dir - 1]]
		else:
			return [dirArray[0], dirArray[dir - 1]]

func getAll(dir : String):
	match dir:
		"Straight", "Cone", "L":
			return [dirArray[0], dirArray[2], dirArray[4], dirArray[6]]
		"Diagonal":
			return [dirArray[1], dirArray[3], dirArray[5], dirArray[7]]
		"Both", "Circle", "Square":
			return dirArray

func getOppDirection(dir : Direction):
	if dir < 4:
		return dirArray[dir + 4]
	else:
		return dirArray[dir - 4]

func getClosestDirection(start : Vector3, target : Vector3):
	var closestDirection : Direction
	var smallestVariation : int
	for n in range(8):
		var xVar = abs(target.x - (start + getPos(dirArray[n])).x)
		var zVar = abs(target.z - (start + getPos(dirArray[n])).z)
		if closestDirection:
			if smallestVariation > xVar + zVar:
				closestDirection = dirArray[n]
				smallestVariation = xVar + zVar
			elif smallestVariation == xVar + zVar:
				if (closestDirection == 0 or dirArray[n] == 0) and (closestDirection == 6 or dirArray[n] == 6):
					closestDirection = 6
				else:
					closestDirection = ((closestDirection + dirArray[n]) / 2)
		else:
			closestDirection = dirArray[n]
			smallestVariation = xVar + zVar
	
	return closestDirection
