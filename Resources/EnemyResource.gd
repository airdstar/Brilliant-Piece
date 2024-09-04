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
	var resource
	if amount >= 32:
		amount -= 32
		possibleTypes.append(ResourceLoader.load("res://Resources/PieceType Resources/Queen.tres"))
	if amount >= 16:
		amount -= 16
		possibleTypes.append(ResourceLoader.load("res://Resources/PieceType Resources/King.tres"))
	if amount >= 8:
		amount -= 8
		possibleTypes.append(ResourceLoader.load("res://Resources/PieceType Resources/Knight.tres"))
	if amount >= 4:
		amount -= 4
		possibleTypes.append(ResourceLoader.load("res://Resources/PieceType Resources/Bishop.tres"))
	if amount >= 2:
		amount -= 2
		possibleTypes.append(ResourceLoader.load("res://Resources/PieceType Resources/Rook.tres"))
	if amount >= 1:
		amount -= 1
		possibleTypes.append(ResourceLoader.load("res://Resources/PieceType Resources/Pawn.tres"))
	
	return(possibleTypes[randi_range(0,possibleTypes.size() - 1)])
