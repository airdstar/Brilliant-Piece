extends MoveablePiece
class_name EnemyPiece

@export var enemyType : EnemyResource

var type : String
var level : int

func _ready():
	setData()

func setData():
	pieceName = enemyType.name
	level = randi_range(enemyType.minLevel,enemyType.maxLevel)
	maxHealth = enemyType.maxHealth + int(enemyType.maxHealth * level * 0.5)
	health = maxHealth
	var amount = enemyType.type
	var possibleTypes = []
	if amount >= 32:
		amount -= 32
		possibleTypes.append("Queen")
	if amount >= 16:
		amount -= 16
		possibleTypes.append("King")
	if amount >= 8:
		amount -= 8
		possibleTypes.append("Knight")
	if amount >= 4:
		amount -= 4
		possibleTypes.append("Bishop")
	if amount >= 2:
		amount -= 2
		possibleTypes.append("Rook")
	if amount >= 1:
		amount -= 1
		possibleTypes.append("Pawn")
	
	type = possibleTypes[randi_range(0,possibleTypes.size() - 1)]
