extends Resource
class_name ActionResource

@export var name : String
@export var desc : String
@export var animationPath : String
@export var iconPath : String

@export_enum("Attack", "Heal", "Armor", "Status") var actionType : String

@export var damage : int
@export var healing : int
@export var armor : int
@export var status : StatusResource

@export_enum("Straight", "Diagonal", "Both", "Cone", "Circle", "Square") var actionDirection : String
@export var range : int
@export var rangeExclusive : bool #Does it only hit that range
@export var canTargetSelf : bool

@export var blockable : bool
@export var knockback : bool
@export var AOE : int

func getActionRange(actionStart : Vector3):
	var toReturn : Array[Vector3]
	var directions
	var pos
	
	if actionDirection == "Straight" or actionDirection == "Cone":
		directions = 4
		pos = Directions.getAllStraight()
	elif actionDirection == "Diagonal":
		directions = 4
		pos = Directions.getAllDiagonal()
	elif actionDirection == "Both" or actionDirection == "Circle":
		directions = 8
		pos = Directions.getAllDirections()
	
	for n in range(directions):
		var tileData : Vector3 = actionStart
		for m in range(range):
			tileData += Directions.getDirection(pos[n])
			if rangeExclusive and m != range - 1:
				pass
			else:
				toReturn.append(tileData)
				if n < 4:
					if (actionDirection == "Cone" or actionDirection == "Circle") and m > 0:
						var sides = Directions.getSides(Directions.getAllStraight()[n])
						for l in range(m):
							toReturn.append(tileData + (Directions.getDirection(sides[0]) * (l + 1)))
							toReturn.append(tileData + (Directions.getDirection(sides[1]) * (l + 1)))
	
	return toReturn
