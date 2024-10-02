extends Handler

var highlightedTile : tile
var iTiles : Array[tile]


func setTilePattern():
	for n in range(FloorData.floorInfo.rc.x):
		for m in range(FloorData.floorInfo.rc.y):
			if FloorData.tiles[n][m] != null:
				var cTile = FloorData.tiles[n][m]
				if !iTiles.has(cTile):
					if (cTile.rc.x + cTile.rc.y)%2 == 1:
						cTile.tileColor.set_color(Global.tileBlackColor[0])
					else:
						cTile.tileColor.set_color(Global.tileWhiteColor[0])
				else:
					if mH.SH.moving:
						cTile.tileColor.set_color(Global.colorDict["Blue"])
					elif mH.SH.interactable:
						if cTile.contains == PlayerData.playerPiece:
							cTile.tileColor.set_color(Global.colorDict["Green"])
						else:
							cTile.tileColor.set_color(Global.colorDict["Orange"])

func show():
	if mH.SH.moving:
		iTiles = PlayerData.playerInfo.pieceType.getMoveableTiles(PlayerData.playerInfo.rc)
	elif mH.SH.interactable:
		iTiles = mH.SH.interactable.getTiles(PlayerData.playerInfo.rc)
	setTilePattern()

func stopShowing():
	mH.SH.moving = false
	iTiles.clear()
	setTilePattern()

func checkHazards():
	if !FloorData.floorInfo.playerTurn:
		var playerTile = FloorData.tiles[PlayerData.playerPiece.rc.x][PlayerData.playerPiece.rc.y]
		if playerTile.hazard:
			if playerTile.hazard.effectType == "OnRest":
				if playerTile.hazard.effect.nextFloor:
					FloorData.nextFloor()
