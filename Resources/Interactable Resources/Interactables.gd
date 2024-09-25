extends Resource
class_name Interactable

@export_category("General")
@export var name : String
@export var desc : String
@export var iconPath : String
@export var associatedModel : String = "res://Item/Base.blend"
@export_enum("Damage", "Healing", "Defensive", "Hazard", "Status", "Movement") var type : String

@export_category("Basic Stats")
@export var damage : int
@export var healing : int
@export var armor : int
@export var status : StatusResource
@export var hazard : HazardResource
@export var effect : EffectResource

@export_category("Range Variables")
@export_enum("Straight", "Diagonal", "Both", "Cone", "L") var direction : String
@export var iRange : int = 1
@export var rangeExclusive : bool = false   #Does it only hit that range
@export var obstructable : bool
@export var AOE : AOEResource
@export_flags("Self", "Enemy", "Tile") var usableOn : int

func getTiles(iStart : Vector3):
	var toReturn : Array[tile]
	var pos = FloorData.floor.Handlers.DH.getAll(direction)
	var tileData : Vector3
	if getUsable().has("Self"):
		toReturn.append(FloorData.floor.Handlers.TH.lookForTile(iStart))
	if getUsable().has("Enemy") or getUsable().has("Tile"):
		for n in range(pos.size()):
			tileData = iStart
			var counter = 1
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
				
				if counter == iRange:
					endSearch = true
				
				counter += 1
				
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
