extends Node
class_name Floor

var enemies : Array[EnemyPiece]
var neutrals : Array

@onready var Handlers = $FloorHandlers

@onready var menuHolder = $Menu
@onready var HUD = $Menu/HUD


func _ready():
	pass

func _process(_delta : float):
	if Input.is_action_just_pressed("Exit"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("Save"):
		Handlers.SH.saveState()
	
	if Input.is_action_just_pressed("Reset"):
		Handlers.SH.resetState()


func pieceDeath(piece : MoveablePiece):
	if piece is EnemyPiece:
		PlayerData.gainExp(piece.enemyType.expAmount)
		PlayerData.playerInfo.items.append(piece.enemyType.itemPool.items[randi_range(0, piece.enemyType.itemPool.items.size() - 1)])
		PlayerData.playerInfo.coins += randi_range(piece.enemyType.coinDropMin, piece.enemyType.coinDropMax)
		FloorData.tiles[piece.rc.x][piece.rc.y].contains = null
		
		var pieceNum = FloorData.floor.enemies.find(piece)
		FloorData.floor.enemies.remove_at(pieceNum)
		FloorData.floorInfo.enemies.remove_at(pieceNum)
		
		piece.queue_free()
