extends Interactable
class_name ActionResource

@export_category("Extended General")
@export_enum("Damage", "Healing", "Defensive", "Hazard", "Status", "Movement", "Creation") var actionType : String


@export_category("Basic Stats")
@export var damage : int
@export var healing : int
@export var armor : int
@export var status : StatusResource
@export var hazard : HazardResource
@export var effect : EffectResource

@export_category("Range Variables")
@export_enum("Straight", "Diagonal", "Both", "Cone", "L") var direction : String
@export var iRange : int = 3
@export var rangeExclusive : bool = false   #Does it only hit that range
@export var obstructable : bool
@export_flags("Self", "Enemy", "Tile") var usableOn : int
@export var AOE : AOEResource


func getTiles(iStart : Vector2i):
	var toReturn : Array[tile]
	var pos = FloorData.floor.Handlers.DH.getAll(direction)
	var tileData : Vector2i
	if getUsable().has("Self"):
		toReturn.append(FloorData.tiles[iStart.x][iStart.y])
	if getUsable().has("Enemy") or getUsable().has("Tile"):
		for n in range(pos.size()):
			tileData = iStart
			var counter = 1
			var endSearch = false
			while !endSearch:
				tileData += FloorData.floor.Handlers.DH.dirDict["PosData"][pos[n]]
				
				if tileData.x >= FloorData.floorInfo.rc.x or tileData.y >= FloorData.floorInfo.rc.y or tileData.x < 0 or tileData.y < 0:
					endSearch = true
				else:
					if FloorData.tiles[tileData.x][tileData.y] != null:
						if obstructable:
							toReturn.append(FloorData.tiles[tileData.x][tileData.y])
							if FloorData.tiles[tileData.x][tileData.y].obstructed:
								endSearch = true
						else:
							toReturn.append(FloorData.tiles[tileData.x][tileData.y])
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
