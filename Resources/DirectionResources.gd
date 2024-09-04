extends Node
class_name direction

func getDirection(dir : String):
	match dir:
		"North":
			return Vector3(0,0,1)
		"NorthWest":
			return Vector3(1,0,1)
		"West":
			return Vector3(1,0,0)
		"SouthWest":
			return Vector3(1,0,-1)
		"South":
			return Vector3(0,0,-1)
		"SouthEast":
			return Vector3(-1,0,-1)
		"East":
			return Vector3(-1,0,0)
		"NorthEast":
			return Vector3(-1,0,1)

func getDiagonals(dir : String):
	match dir:
		"North":
			return ["NorthWest", "NorthEast"]
		"West":
			return ["SouthWest", "NorthWest"]
		"South":
			return ["SouthEast", "SouthWest"]
		"East":
			return ["NorthEast", "SouthEast"]

func getSides(dir : String):
	match dir:
		"North":
			return ["West", "East"]
		"West":
			return ["South", "North"]
		"South":
			return ["East", "West"]
		"East":
			return ["North", "South"]
		"NorthWest":
			return ["West", "North"]
		"NorthEast":
			return ["North", "East"]
		"SouthWest":
			return ["South", "West"]
		"SouthEast":
			return ["East", "South"]

func getAllStraight():
	return ["North", "West", "South", "East"]

func getAllDiagonal():
	return ["NorthWest", "SouthWest", "SouthEast", "NorthEast"]

func getAllDirections():
	return ["North", "West", "South", "East", "NorthWest", "SouthWest", "SouthEast", "NorthEast"]

func getOppDirection(dir : String):
	match dir:
		"North":
			return "South"
		"West":
			return "East"
		"South":
			return "North"
		"East":
			return "West"
		"NorthWest":
			return "SouthEast"
		"NorthEast":
			return "SouthWest"
		"SouthWest":
			return "NorthEast"
		"SouthEast":
			return "NorthWest"

func getClosestDirection(start : Vector3, target : Vector3):
	var allDirections = getAllDirections()
	var closestDirection
	var smallestVariation
	for n in range(8):
		var xVar = abs(target.x - (start + getDirection(allDirections[n])).x)
		var zVar = abs(target.z - (start + getDirection(allDirections[n])).z)
		if closestDirection:
			if smallestVariation > xVar + zVar:
				closestDirection = allDirections[n]
				smallestVariation = xVar + zVar
			elif smallestVariation == xVar + zVar:
				if (closestDirection == "North" or allDirections[n] == "North"):
					if (closestDirection == "West" or allDirections[n] == "West"):
						closestDirection = "NorthWest"
					elif (closestDirection == "East" or allDirections[n] == "East"):
						closestDirection = "NorthEast"
				elif (closestDirection == "South" or allDirections[n] == "South"):
					if (closestDirection == "West" or allDirections[n] == "West"):
						closestDirection = "SouthWest"
					elif (closestDirection == "East" or allDirections[n] == "East"):
						closestDirection = "SouthEast"
		else:
			closestDirection = allDirections[n]
			smallestVariation = xVar + zVar
	
	return closestDirection
