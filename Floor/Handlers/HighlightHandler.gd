extends Handler

func highlightTile(tPos : Vector2i):
	var tileToSelect = FloorData.tiles[tPos.x][tPos.y]
	mH.TH.highlightedTile = tileToSelect
	mH.TH.setTilePattern()
	tileToSelect.tileColor.modulate = Global.colorDict["Gray"]
	
	mH.UH.displayInfo()

func unhighlightTile():
	mH.TH.highlightedTile = null
	mH.TH.setTilePattern()
	mH.UH.displayInfo()
