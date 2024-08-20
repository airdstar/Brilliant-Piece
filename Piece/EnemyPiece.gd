extends MoveablePiece
class_name EnemyPiece

@export var enemyType : EnemyResource

var type : String
var level : int
var maxHealth : int
var health : int

func _ready():
	setData()

func setData():
	type = enemyType.type[randi_range(0, enemyType.type.size() - 1)]
	level = randi_range(enemyType.minLevel,enemyType.maxLevel)
	maxHealth = enemyType.maxHealth + (enemyType.maxHealth * level * 0.5)
	health = maxHealth
