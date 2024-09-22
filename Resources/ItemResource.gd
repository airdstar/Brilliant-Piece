extends Resource
class_name ItemResource

@export_category("General")
@export var name : String
@export var desc : String
@export var associatedModel : String = "res://Item/Base.blend"
@export_enum("Damage", "Healing", "Defensive", "Hazard", "Status", "Movement") var itemType : String
@export_flags("Self", "Enemy", "Tile") var usableOn : int


@export var useAmount : int = 1
var amountUsed : int = 0
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
	var pos = FloorData.floor.Handlers.DH.getAll("Both")
	for n in range(8):
		var tileData : Vector3 = itemStart
		for m in range(itemRange):
			tileData += FloorData.floor.Handlers.DH.dirDict["PosData"][pos[n]]
			toReturn.append(tileData)
			if n % 2 == 0:
				var counter = m
				while counter > 0:
					toReturn.append(tileData + FloorData.floor.Handlers.DH.dirDict["PosData"][FloorData.floor.Handlers.DH.getSides(pos[n])[0]] * counter)
					toReturn.append(tileData + FloorData.floor.Handlers.DH.dirDict["PosData"][FloorData.floor.Handlers.DH.getSides(pos[n])[1]] * counter)
					counter -= 1
	
	return toReturn

func getUsable():
	var amount = usableOn
	var possibleUses = []

	if amount >= 4:
		amount -= 4
		possibleUses.append("Tile")
	if amount >= 2:
		amount -= 2
		possibleUses.append("Enemy")
	if amount >= 1:
		amount -= 1
		possibleUses.append("Self")
	
	return possibleUses

func use():
	amountUsed += 1
	if amountUsed == useAmount:
		PlayerData.playerInfo.items.erase(self)
