extends Resource
class_name AOEResource

@export var name : String
@export_enum("Straight", "Diagonal", "Both", "Circle", "Sides") var AOEdirection: String
@export_enum("None", "Forward", "Backward", "Both") var trailType : String
@export var AOErange : int = 1
@export var trailRange : int = 10


func getAOE():
	var toReturn : Array[Vector3]
	var pos = DirectionHandler.getAll(AOEdirection)
	for n in range(AOErange):
		pass
	return toReturn
