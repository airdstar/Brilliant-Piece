extends Resource
class_name LayerResource

@export var layerName : String
@export var possibleEnemies : Array[EnemyResource]
@export var possibleLayouts : Array[String]
var usedLayouts : Array[int]

@export var maxPossibleEnemies : int = 1
@export var minPossibleEnemies : int = 1
