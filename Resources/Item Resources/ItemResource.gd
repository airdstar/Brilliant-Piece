extends Interactable
class_name ItemResource

@export_category("Uses")
@export var amount : int = 1

func getTiles(iStart : Vector2i):
	print("hi")
	var toReturn : Array[tile]
	var pos = FloorData.floor.Handlers.DH.getAll("Both")
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
						toReturn.append(FloorData.tiles[tileData.x][tileData.y])
				if counter == 5:
					endSearch = true
				
				counter += 1
				
	return toReturn

func getUsable():
	var remainder = usableOn
	var possibleUses = []

	if remainder >= 4:
		remainder -= 4
		possibleUses.append("Tile")
	if remainder >= 2:
		remainder -= 2
		possibleUses.append("Enemy")
	if remainder >= 1:
		remainder -= 1
		possibleUses.append("Self")
	
	return possibleUses

func get_relevant_tiles(_iStart : Vector2i, pieceType : int):
	pass
