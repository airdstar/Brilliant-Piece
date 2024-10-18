extends Handler

var highlightedTile : tile
var iTiles : Array[tile]
var aoeTiles : Array[tile]

func setTilePattern():
	for n in range(FloorData.floorInfo.rc.x):
		for m in range(FloorData.floorInfo.rc.y):
			if FloorData.tiles[n][m] != null:
				var cTile = FloorData.tiles[n][m]
				if cTile != highlightedTile:
					if (cTile.rc.x + cTile.rc.y)%2 == 1:
						cTile.tileColor.modulate = Global.tileBlackColor[0]
					else:
						cTile.tileColor.modulate = Global.tileWhiteColor[0]
				if !iTiles.has(cTile):
					FloorData.tiles[n][m].interactable.visible = false
				else:
					cTile.interactable.visible = true
					if mH.SH.moving:
						cTile.interactable.modulate = Global.colorDict["White"]
					elif mH.SH.interactable:
						if cTile.contains == PlayerData.playerPiece:
							cTile.interactable.modulate = Global.colorDict["Green"]
						else:
							cTile.interactable.modulate = Global.colorDict["Orange"]
	if mH.SH.interactable and highlightedTile != null:
		if mH.SH.interactable.AOE and iTiles.has(highlightedTile):
			showAOE()

func showAOE():
	aoeTiles = mH.SH.interactable.AOE.getAOE(highlightedTile.rc, mH.DH.getClosestDirection(PlayerData.playerPiece.rc, highlightedTile.rc))
	for o in range(aoeTiles.size()):
		aoeTiles[o].interactable.visible = true

func show():
	if mH.SH.moving:
		iTiles = PlayerData.playerInfo.pieceType.getMoveableTiles(PlayerData.playerInfo.rc)
	elif mH.SH.interactable:
		iTiles = mH.SH.interactable.getTiles(PlayerData.playerInfo.rc)
	setTilePattern()

func stopShowing():
	mH.SH.interactable = null
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
