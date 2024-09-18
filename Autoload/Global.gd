extends Node

var colorDict : Dictionary = {"White" : Color(1,1,1,1), "Black" : Color(0,0,0,1),
								"Gray" : Color(0.5,0.5,0.5,1), "Blue" : Color(0.63,0.72,0.86,1),
								"Red" : Color(0.86,0.63,0.72,1), "Orange" : Color(0.86,0.72,0.63,1),
								"Green" : Color(0.63,0.86,0.72,1)}

var expArray : Array[int] = [10, 20, 30, 40, 50]

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

var dirDict : Dictionary

func _ready():
	var dirPosArray : Array[Vector3] = [Vector3(0,0,1), Vector3(1,0,1), Vector3(1,0,0), Vector3(1,0,-1),
										Vector3(0,0,-1), Vector3(-1,0,-1), Vector3(-1,0,0), Vector3(-1,0,1)]
	
	var dirRotationArray : Array[int] = [-90, -45, 0, 45, 90, 135, 180, -135]
	
	dirDict = {"PosData" : dirPosArray, "RotData" : dirRotationArray}
