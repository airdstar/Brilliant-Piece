extends Interactable
class_name ActionResource

@export_category("Range Variables")
@export_enum("Straight", "Diagonal", "Both", "Cone", "L") var direction : String
@export var iRange : int = 3
@export var rangeExclusive : bool = false   #Does it only hit that range
@export var obstructable : bool


func getTiles(iStart : Vector2i):
	var toReturn : Array[tile]
	var pos = FloorData.floor.Handlers.DH.posDict[direction]
	var tileData : Vector2i
	if getUsable().has("Self"):
		toReturn.append(FloorData.tiles[iStart.x][iStart.y])
	if getUsable().has("Enemy") or getUsable().has("Tile"):
		for n in range(pos.size()):
			tileData = iStart
			var counter = 1
			var endSearch = false
			while !endSearch:
				tileData += pos[n]
				
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

func get_relevant_tiles(_iStart : Vector2i, pieceType : int):
	var actionRange = getTiles(_iStart)
	var aoeRange : Array[tile]
	var possibleTiles : Array[tile]
	var aoeTiles : Array[tile]
	for n in range(actionRange.size()):
		match type:
			"Damage":
				if (actionRange[n].get_contain() != pieceType and actionRange[n].get_contain() != 0) or actionRange[n].obstructed:
					possibleTiles.append(actionRange[n])
				elif AOE != null:
					aoeRange = AOE.getAOE(actionRange[n].rc, FloorData.floor.Handlers.DH.getClosestDirection(_iStart, actionRange[n].rc))
					for m in range(aoeRange.size()):
						if (aoeRange[m].get_contain() != pieceType and aoeRange[m].get_contain() != 0) or aoeRange[m].obstructed:
							possibleTiles.append(actionRange[n])
			"Healing":
				if actionRange[n].get_contain() == pieceType:
					possibleTiles.append(actionRange[n])
				elif AOE != null:
					aoeRange = AOE.getAOE(actionRange[n].rc, FloorData.floor.Handlers.DH.getClosestDirection(_iStart, actionRange[n].rc))
					for m in range(aoeRange.size()):
						if aoeRange[m].get_contain() == pieceType:
							possibleTiles.append(actionRange[n])

			"Defensive":
				if actionRange[n].get_contain() == pieceType:
					possibleTiles.append(actionRange[n])
				elif AOE != null:
					aoeRange = AOE.getAOE(actionRange[n].rc, FloorData.floor.Handlers.DH.getClosestDirection(_iStart, actionRange[n].rc))
					for m in range(aoeRange.size()):
						if aoeRange[m].get_contain() == pieceType:
							possibleTiles.append(actionRange[n])
			"Status":
				var isBuff : bool = false
				if status.statusType == "Buff":
					isBuff = true
				
				if (actionRange[n].get_contain() == pieceType) == isBuff:
					possibleTiles.append(actionRange[n])
				elif AOE != null:
					aoeRange = AOE.getAOE(actionRange[n].rc, FloorData.floor.Handlers.DH.getClosestDirection(_iStart, actionRange[n].rc))
					for m in range(aoeRange.size()):
						if (aoeRange[m].get_contain() == pieceType) == isBuff:
							possibleTiles.append(actionRange[n])
			"Hazard":
				var isObstruction : bool = false
				if hazard.blockade:
					isObstruction = true
				
				if isObstruction:
					if actionRange[n].get_contain() == 0:
						possibleTiles.append(actionRange[n])
				else:
					possibleTiles.append(actionRange[n])
					
	return possibleTiles
	
