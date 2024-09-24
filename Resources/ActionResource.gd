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
@export_enum("Straight", "Diagonal", "Both", "Cone", "L") var actionDirection : String
@export var actionRange : int = 1
@export var rangeExclusive : bool = false   #Does it only hit that range
@export_flags("Self", "Enemy", "Tile") var usableOn : int

@export_category("Other")
@export var obstructable : bool
@export var effect : EffectResource
@export var AOE : AOEResource

func getActionRange(actionStart : Vector3):
	var toReturn : Array[tile]
	var pos = FloorData.floor.Handlers.DH.getAll(actionDirection)
	var tileData : Vector3
	var targets = getUsable()
	if targets.has("Self"):
		toReturn.append(actionStart)
	if targets.has("Tile") or targets.has("Enemy"):
		for n in range(pos.size()):
			tileData = actionStart
			var actionCounter = 1
			var endSearch = false
			while !endSearch:
				tileData += FloorData.floor.Handlers.DH.dirDict["PosData"][pos[n]]
				if FloorData.floor.Handlers.TH.lookForTile(tileData):
					if obstructable:
						if !FloorData.floor.Handlers.TH.lookForTile(tileData).obstructed:
							toReturn.append(FloorData.floor.Handlers.TH.lookForTile(tileData))
						else:
							toReturn.append(FloorData.floor.Handlers.TH.lookForTile(tileData))
							endSearch = true
					else:
						toReturn.append(FloorData.floor.Handlers.TH.lookForTile(tileData))
				else:
					if obstructable:
						endSearch = true
				
				if actionCounter == actionRange:
					endSearch = true
				
				actionCounter += 1
				
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
