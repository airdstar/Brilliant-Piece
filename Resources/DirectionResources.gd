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

func getApproxDirection():
	pass
