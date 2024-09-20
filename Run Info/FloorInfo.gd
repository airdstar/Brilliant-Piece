extends Resource
class_name FloorInfo

@export var floorNum : int = 0
@export var layerData : LayerResource = ResourceLoader.load("res://Resources/Layer Resources/TestLayer.tres")

@export var tiles : Array[TileInfo]

@export var enemies : Array[EnemyInfo]
@export var neutrals : Array

@export var endLocation : Vector3

@export var isNew : bool = true
