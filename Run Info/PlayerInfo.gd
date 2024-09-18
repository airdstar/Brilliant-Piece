extends Resource
class_name PlayerInfo

@export var currentPos : Vector3

@export var classType : ClassResource
@export var pieceType : PieceTypeResource

@export var level : int = 1
@export var expAmount : int

@export var maxHealth : int
@export var health : int
@export var armor : int = 0

@export var actions : Array[ActionResource]
@export var items : Array[ItemResource]
@export var coins : int = 0
@export var soul : int = 0
