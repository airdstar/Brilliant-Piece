extends Resource
class_name ItemResource

@export_category("General")
@export var name : String
@export var desc : String
@export var associatedModel : String
@export_enum("Damage", "Healing", "Defensive", "Hazard", "Status", "Ammo") var itemType : String
@export_flags("Self", "Enemy", "Tile") var usableOn : int


@export var useAmount : int
var amountUsed = useAmount
@export var itemRange : int = 10

@export_category("Basic Stats")
@export var damage : int
@export var healing : int
@export var armor : int

func getItemRange(itemStart : Vector3):
	var toReturn : Array[Vector3]
	var directions = 8
	var pos = Directions.getAllDirections()
	for n in range(directions):
		var tileData : Vector3 = itemStart
		for m in range(itemRange):
			tileData += Directions.getDirection(pos[n])
			toReturn.append(tileData)
			if n < 4:
				if m > 0:
					var sides = Directions.getSides(Directions.getAllStraight()[n])
					for l in range(m):
						toReturn.append(tileData + (Directions.getDirection(sides[0]) * (l + 1)))
						toReturn.append(tileData + (Directions.getDirection(sides[1]) * (l + 1)))
	
	return toReturn
