extends MoveablePiece
class_name EnemyPiece

@export var enemyType : EnemyResource

var level : int

func _ready():
	setData()

func setData():
	pieceName = enemyType.name
	level = randi_range(enemyType.minLevel,enemyType.maxLevel)
	maxHealth = enemyType.maxHealth + int(enemyType.maxHealth * level * 0.5)
	health = maxHealth
	type = enemyType.getType()
