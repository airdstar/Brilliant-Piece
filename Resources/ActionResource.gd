extends Resource
class_name ActionResource

@export_category("General")
@export var name : String
@export var desc : String
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
@export var actionRange : int = 1
@export var rangeExclusive : bool = false   #Does it only hit that range
@export var canTargetSelf : bool = false

@export_category("Other")
@export var obstructable : bool
@export var effect : EffectResource
@export var AOE : int

func getActionRange(actionStart : Vector3):
	var toReturn : Array[Vector3]
	var pos = DirectionHandler.getAll(actionDirection)
	var tileData : Vector3
	for n in range(pos.size()):
		tileData = actionStart
		for m in range(actionRange):
			tileData += DirectionHandler.dirDict["PosData"][pos[n]]
			toReturn.append(tileData)
			if actionDirection == "Cone":
				var counter = m
				while counter > 1:
					toReturn.append(tileData + DirectionHandler.dirDict["PosData"][DirectionHandler.getSides(pos[n])[0]] * (counter / 2))
					toReturn.append(tileData + DirectionHandler.dirDict["PosData"][DirectionHandler.getSides(pos[n])[1]] * (counter / 2))
					counter -= 2
			elif actionDirection == "Square":
				if n % 2 == 0:
					var counter = m
					while counter > 0:
						toReturn.append(tileData + DirectionHandler.dirDict["PosData"][DirectionHandler.getSides(pos[n])[0]] * counter)
						toReturn.append(tileData + DirectionHandler.dirDict["PosData"][DirectionHandler.getSides(pos[n])[1]] * counter)
						counter -= 1
	return toReturn
