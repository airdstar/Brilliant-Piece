extends Handler

var actingPiece : MoveablePiece
var moving : bool = false
var interactable : Interactable = null

func saveState():
	FloorData.saveInfo()

func loadState():
	FloorData.loadInfo()

func resetState():
	FloorData.resetInfo()
	PlayerData.resetInfo()
