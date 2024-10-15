extends Resource
class_name EnemyResource

@export_category("General")
@export var name : String
@export var desc : String
@export var associatedSprite : Texture2D
@export_flags("Pawn", "Rook", "Bishop", "Knight", "King", "Queen") var type : int

@export_category("Stats")
## Health of minimum level
@export var baseHealth : int = 3
## currentHealth + (this * currentHealth) to calculate health for every level
@export var healthScaling : float = 0.4
@export var actions : ActionSetResource
## Max possible level
@export var maxLevel : int = 1
## Minimum possible level
@export var minLevel : int = 1

@export_category("Drops")
## Exp dropped at the minimum level
@export var expAmount : int = 1
## (currentExpAmount * expScaling) to calculate exp for every level
@export var expScaling : float = 1.5
## Every possible drop, chances included, update the resource to change
@export var itemPool : ItemPoolResource
## Minimum amount of coin that can drop
@export var coinDropMin : int = 1
## Maximum amount of coin that can drop
@export var coinDropMax : int = 1

func getType():
	var amount = type
	var possibleTypes = []
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
