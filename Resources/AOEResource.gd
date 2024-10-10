extends Resource
class_name AOEResource

@export_enum("Straight", "Diagonal", "Both", "L", "Sides") var AOEdirection: String
## Trails go in the specified direction until the edges of map or stopped by an obstruction
@export_enum("None", "Forward", "Backward", "Both") var trailType : String
## Amount of tiles the AOE can go
@export var AOErange : int = 1
## Width of trail
@export var trailWidth : int = 0


func getAOE(AOEstart : Vector2i, relativeDir : int):
	var toReturn : Array[tile]
	var pos : Array[Vector2i]
	
	if AOEdirection != "Sides":
		pos = FloorData.floor.Handlers.DH.posDict[AOEdirection]
		
	
	var tileData : Vector2i
	for n in range(pos.size()):
		tileData = AOEstart
		var counter := 1
		var endSearch := false
		while !endSearch:
			tileData += pos[n]
			
			if tileData.x >= FloorData.floorInfo.rc.x or tileData.y >= FloorData.floorInfo.rc.y or tileData.x < 0 or tileData.y < 0:
				endSearch = true
			else:
				if FloorData.tiles[tileData.x][tileData.y] != null:
					toReturn.append(FloorData.tiles[tileData.x][tileData.y])
					if FloorData.tiles[tileData.x][tileData.y].obstructed:
						endSearch = true
			
			if counter == AOErange:
				endSearch = true
				
			counter += 1
			
	return toReturn
