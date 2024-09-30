extends Handler

var tileDict : Dictionary
var highlightedTile : tile
var iTiles : Array[tile]

func lookForTile(pos : Vector3):
	if tileDict["TilePos"].has(pos):
		return tileDict["Tiles"][tileDict["TilePos"].find(pos)]
	return null

func setTilePattern():
	for n in range(FloorData.floorInfo.rc.x):
		for m in range(FloorData.floorInfo.rc.y):
			if FloorData.tiles[n][m] != null:
				var cTile = FloorData.tiles[n][m]
				cTile.highlight.visible = false
				if highlightedTile != cTile:
					if !iTiles.has(cTile):
						if (int(cTile.position.x + cTile.position.z)%2 == 1 or int(cTile.position.x + cTile.position.z)%2 == -1):
							cTile.setColor(Global.colorDict["Black"])
						else:
							cTile.setColor(Global.colorDict["White"])
					else:
						cTile.setColor(Global.colorDict["Blue"])

func show():
	FloorData.floor.Pointer.visible = true
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
