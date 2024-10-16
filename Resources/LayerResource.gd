extends Resource
class_name LayerResource

@export var layerName : String
@export var possibleEnemies : Array[EnemyResource]
@export var possibleHazards : Array[HazardResource]
@export var possibleLayouts : Array[Texture2D]
var usedLayouts : Array[int]

@export var maxPossibleEnemies : int = 1
@export var minPossibleEnemies : int = 1
