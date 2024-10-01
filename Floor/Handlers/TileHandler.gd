extends Handler

var highlightedTile : tile
var iTiles : Array[tile]


func setTilePattern():
	for n in range(FloorData.floorInfo.rc.x):
		for m in range(FloorData.floorInfo.rc.y):
			if FloorData.tiles[n][m] != null:
				var cTile = FloorData.tiles[n][m]
				if highlightedTile != cTile:
					if !iTiles.has(cTile):
						if (cTile.rc.x + cTile.rc.y)%2 == 1:
							cTile.set_color(Global.colorDict["Black"])
						else:
							cTile.set_color(Global.colorDict["White"])
					else:
						cTile.set_color(Global.colorDict["Blue"])

func show():
	if mH.SH.moving:
		iTiles = PlayerData.playerInfo.pieceType.getMoveableTiles(PlayerData.playerInfo.rc)
	elif mH.SH.interactable:
		iTiles = mH.SH.interactable.getTiles(PlayerData.playerInfo.rc)
	setTilePattern()

func stopShowing():
	iTiles.clear()
	setTilePattern()

func checkHazards():
	if !FloorData.floorInfo.playerTurn:
		var playerTile = FloorData.tiles[PlayerData.playerPiece.rc.x][PlayerData.playerPiece.rc.y]
		if playerTile.hazard:
			if playerTile.hazard.effectType == "OnRest":
				if playerTile.hazard.effect.nextFloor:
					FloorData.nextFloor()
