extends ItemResource
class_name WeaponResource

@export_category("Basic Stats")
@export var damage : int

@export_category("Ammunition")
@export var reliesOnAmmo : bool
@export_enum("Pistol", "Rifle", "Energy") var requiredAmmo : String
@export var currentAmmo : AmmoResource

@export_category("Durability")
@export var hasDurability : bool
@export var durability : int
var durabilityLeft = durability

@export_category("Range Variables")
@export_enum("Straight", "Diagonal", "Both", "Cone", "L") var direction : String
@export var iRange : int = 3
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
					if !FloorData.floor.Handlers.TH.lookForTile(tileData).obstructed:
						toReturn.append(FloorData.floor.Handlers.TH.lookForTile(tileData))
					else:
						toReturn.append(FloorData.floor.Handlers.TH.lookForTile(tileData))
						endSearch = true
				else:
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
