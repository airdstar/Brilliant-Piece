extends MoveablePiece
class_name EnemyPiece

@export var enemyType : EnemyResource

var prevDirection : int

func _ready():
	setData(0)

func setData(pieceNum : int):
	pieceName = enemyType.name
	level = randi_range(enemyType.minLevel,enemyType.maxLevel)
	maxHealth = enemyType.baseHealth + int(enemyType.baseHealth * level * 0.5)
	health = maxHealth
	type = enemyType.getType()
