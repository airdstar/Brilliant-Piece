extends Resource
class_name EnemyInfo

@export var enemyType : EnemyResource
@export var pieceType : PieceTypeResource

@export var rc : Vector2i

@export var level : int = 1

@export var maxHealth : int
@export var health : int
@export var armor : int = 0

@export var actions : Array[ActionResource]
