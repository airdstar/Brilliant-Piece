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
