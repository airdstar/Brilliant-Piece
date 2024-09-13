extends Resource
class_name ItemResource

@export_category("General")
@export var name : String
@export var desc : String
@export var associatedModel : String = "res://Item/Base.blend"
@export_enum("Damage", "Healing", "Defensive", "Hazard", "Status", "Movement") var itemType : String
@export_flags("Self", "Enemy", "Tile") var usableOn : int


@export var useAmount : int
var amountUsed = useAmount
@export var itemRange : int = 10

@export_category("Basic Stats")
@export var damage : int
@export var healing : int
@export var armor : int
@export var status : StatusResource
@export var hazard : HazardResource

func _ready():
	if !associatedModel:
		associatedModel = "res://Item/Base.blend"

func getItemRange(itemStart : Vector3):
	var toReturn : Array[Vector3]
	var pos = DirectionHandler.getAll("Both")
	for n in range(8):
		var tileData : Vector3 = itemStart
		for m in range(itemRange):
			tileData += DirectionHandler.dirDict["PosData"][pos[n]]
			if n < 4:
				if m > 0:
					var sides = DirectionHandler.getSides(DirectionHandler.getAll("Straight")[n])
					for l in range(m):
						toReturn.append(tileData + (DirectionHandler.dirDict["PosData"][sides[0]] * (l + 1)))
						toReturn.append(tileData + (DirectionHandler.dirDict["PosData"][sides[1]] * (l + 1)))
	
	return toReturn
