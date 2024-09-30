extends Resource
class_name FloorInfo

@export var floorNum : int = 1
@export var layerData : LayerResource

@export var tileInfo : Array
@export var rc : Vector2i

@export var enemies : Array[EnemyInfo]
@export var neutrals : Array

@export var playerTurn : bool = true
@export var actionUsed : bool = false
@export var moveUsed : bool = false

@export var endLocation : Vector3

@export var isNew : bool = true

func setLayerInfo():
	if floorNum == 0:
		layerData = ResourceLoader.load("res://Resources/Layer Resources/TestLayer.tres")
	elif floorNum <= 5:
		layerData = ResourceLoader.load("res://Resources/Layer Resources/Bellcere.tres")

func endTurn():
	playerTurn = !playerTurn
	actionUsed = false
	moveUsed = false
	
	FloorData.floor.Handlers.UH.setTurnColors()
	FloorData.floor.Handlers.TH.checkHazards()
	
	if playerTurn:
		FloorData.floor.Handlers.UH.openMenu()
	else:
		FloorData.floor.Pointer.visible = true
		FloorData.floor.Handlers.EH.makeDecision()
