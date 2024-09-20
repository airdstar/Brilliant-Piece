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
@export_flags("Self", "Enemy", "Tile") var usableOn : int

@export_category("Other")
@export var obstructable : bool
@export var effect : EffectResource
@export var AOE : AOEResource

func getActionRange(actionStart : Vector3):
	var toReturn : Array[Vector3]
	var pos = FloorData.floor.Handlers.DH.getAll(actionDirection)
	var tileData : Vector3
	var targets = getUsable()
	if targets.has("Self"):
		toReturn.append(actionStart)
	if targets.has("Tile") or targets.has("Enemy"):
		for n in range(pos.size()):
			tileData = actionStart
			for m in range(actionRange):
				tileData += FloorData.floor.Handlers.DH.dirDict["PosData"][pos[n]]
				toReturn.append(tileData)
				if actionDirection == "Cone":
					var counter = m
					while counter > 1:
						toReturn.append(tileData + FloorData.floor.Handlers.DH.dirDict["PosData"][FloorData.floor.Handlers.DH.getSides(pos[n])[0]] * (counter / 2))
						toReturn.append(tileData + FloorData.floor.Handlers.DH.dirDict["PosData"][FloorData.floor.Handlers.DH.getSides(pos[n])[1]] * (counter / 2))
						counter -= 2
				elif actionDirection == "Square":
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
