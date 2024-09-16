extends MoveablePiece
class_name EnemyPiece

@export var enemyType : EnemyResource

var level : int
var prevDirection : DirectionHandler.Direction

func _ready():
	setData()

func setData():
	pieceName = enemyType.name
	level = randi_range(enemyType.minLevel,enemyType.maxLevel)
	maxHealth = enemyType.baseHealth + int(enemyType.baseHealth * level * 0.5)
	health = maxHealth
	type = enemyType.getType()
