extends PlayableArea
class_name Floor

var enemies : Array[EnemyPiece]
var neutrals : Array

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(_delta : float):
	if Input.is_action_just_pressed("Exit"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("Save"):
		Handlers.SH.saveState()
	
	if Input.is_action_just_pressed("Reset"):
		PlayerData.resetInfo()

	cameraControls()

func pieceDeath(piece : MoveablePiece):
	if piece is EnemyPiece:
		PlayerData.gainExp(piece.enemyType.expAmount)
		PlayerData.playerInfo.items.append(piece.enemyType.itemPool.items[randi_range(0, piece.enemyType.itemPool.items.size() - 1)])
		piece.currentTile.contains = null
		#var pieceNum = GameState.pieceDict["Enemy"]["Piece"].find(piece)
		#GameState.pieceDict["Enemy"]["Piece"].remove_at(pieceNum)
		#GameState.pieceDict["Enemy"]["Behavior"].remove_at(pieceNum)
		#GameState.pieceDict["Enemy"]["Position"].remove_at(pieceNum)
		piece.queue_free()
