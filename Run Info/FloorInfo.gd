extends Resource
class_name FloorInfo

@export var floorNum : int = 0
@export var layerData : LayerResource

@export var tiles : Array[TileInfo]

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
		layerData = ResourceLoader.load("res://Resources/Layer Resources/StartingLayer.tres")
