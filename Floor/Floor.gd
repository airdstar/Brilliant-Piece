extends Node
class_name Floor

var enemies : Array[EnemyPiece]
var neutrals : Array

@onready var Handlers = $FloorHandlers

@onready var menuHolder = $Menu
@onready var HUD = $Menu/HUD
@onready var camera = $Camera2D



func _ready():
	Handlers.UH.currentMenu = $Menu/MenuNew

func _process(_delta : float):
	if Input.is_action_just_pressed("Exit"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("Save"):
		Handlers.SH.saveState()
	
	if Input.is_action_just_pressed("Reset"):
		Handlers.SH.resetState()
		FloorData.reload_floor()


func pieceDeath(piece : MoveablePiece):
	if piece is EnemyPiece:
		PlayerData.gainExp(piece.enemyType.expAmount)
		PlayerData.addItem(piece.enemyType.itemPool.getItem())
		PlayerData.playerInfo.coins += randi_range(piece.enemyType.coinDropMin, piece.enemyType.coinDropMax)
		FloorData.tiles[piece.rc.x][piece.rc.y].contains = null
		
		var pieceNum = FloorData.floor.enemies.find(piece)
		FloorData.floor.enemies.remove_at(pieceNum)
		FloorData.floorInfo.enemies.remove_at(pieceNum)
		
		piece.queue_free()


func endTurn() -> void:
	FloorData.floorInfo.endTurn()
