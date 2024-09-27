extends Interactable
class_name ItemResource

@export var associatedModel : String = "res://Item/Base.blend"

func getTiles(iStart : Vector3):
	var toReturn : Array[tile]
	var pos = FloorData.floor.Handlers.DH.getAll("Both")
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
					toReturn.append(FloorData.floor.Handlers.TH.lookForTile(tileData))
				
				if counter == 5:
					endSearch = true
				
				counter += 1
				
	return toReturn
