extends Node

var HUD

func displayInfo():
	if GameState.highlightedTile.contains is MoveablePiece:
		HUD.showPieceInfo()
		HUD.updatePortrait()
		HUD.updateLabels()
	else:
		HUD.hidePieceInfo()

func endedTurn():
	for n in range(3):
		if GameState.playerTurn:
			HUD.turnHUD[n].modulate = Color(0.63,0.72,0.86)
		else:
			HUD.turnHUD[n].modulate = Color(0.86,0.63,0.72)

func usedAction():
	HUD.turnHUD[1].modulate = Color(0.5,0.5,0.5)
	GameState.actionUsed = true

func usedMovement():
	HUD.turnHUD[0].modulate = Color(0.5,0.5,0.5)
	GameState.moveUsed = true
