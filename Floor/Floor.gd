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
		Handlers.SH.resetState()

	cameraControls()

func pieceDeath(piece : MoveablePiece):
	if piece is EnemyPiece:
		PlayerData.gainExp(piece.enemyType.expAmount)
		PlayerData.playerInfo.items.append(piece.enemyType.itemPool.items[randi_range(0, piece.enemyType.itemPool.items.size() - 1)])
		PlayerData.playerInfo.coins += randi_range(piece.enemyType.coinDropMin, piece.enemyType.coinDropMax)
		piece.currentTile.contains = null
		
		var pieceNum = FloorData.floor.enemies.find(piece)
		FloorData.floor.enemies.remove_at(pieceNum)
		FloorData.floorInfo.enemies.remove_at(pieceNum)
		
		piece.queue_free()
