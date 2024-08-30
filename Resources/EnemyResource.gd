extends Resource
class_name EnemyResource

@export_category("General")
@export var name : String
@export var desc : String
@export var associatedScene : String
@export_flags("Pawn", "Rook", "Bishop", "Knight", "King", "Queen") var type : int


@export_category("Stats")
@export var maxHealth : int
@export var attacks : ActionSetResource
@export var maxLevel : int
@export var minLevel : int

func getType():
	var amount = type
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
	
	return(possibleTypes[randi_range(0,possibleTypes.size() - 1)])
