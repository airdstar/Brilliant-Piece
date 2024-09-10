extends Resource
class_name AOEResource

@export var name : String
@export_enum("Straight", "Diagonal", "Both", "Circle", "Square", "Cone", "Sides") var AOEdirection: String
@export var AOErange : int
@export var trail : bool

func getAOE():
	var toReturn
	var pos = DirectionHandler.getAll(AOEdirection)
	for n in range(AOErange):
		pass
	return toReturn
