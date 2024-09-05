extends Resource
class_name ActionResource

@export_category("General")
@export var name : String
@export var desc : String
@export var animationPath : String
@export var iconPath : String

@export_category("Basic Stats")
@export_enum("Attack", "Heal", "Defense", "Status") var actionType : String

@export var damage : int
@export var healing : int
@export var armor : int
@export var status : StatusResource
@export var hazard : HazardResource

@export_category("Targeting")
@export_enum("Straight", "Diagonal", "Both", "Cone", "Circle", "Square") var actionDirection : String
@export var range : int
@export var rangeExclusive : bool #Does it only hit that range
@export var canTargetSelf : bool

@export_category("Other")
@export var blockable : bool
@export var knockback : bool
@export var AOE : int

func getActionRange(actionStart : Vector3):
	var toReturn : Array[Vector3]
	var pos = DirectionHandler.getAll(actionDirection)
	var directions = pos.size()
	
	for n in range(directions):
		var tileData : Vector3 = actionStart
		for m in range(range):
			tileData += DirectionHandler.getPos(pos[n])
			if !rangeExclusive:
				toReturn.append(tileData)
				if n < 4:
					if (actionDirection == "Cone" or actionDirection == "Circle") and m > 0:
						var sides = DirectionHandler.getSides(DirectionHandler.getAll("Straight")[n])
						for l in range(m):
							toReturn.append(tileData + (DirectionHandler.getPos(sides[0]) * (l + 1)))
							toReturn.append(tileData + (DirectionHandler.getPos(sides[1]) * (l + 1)))
	
	return toReturn
