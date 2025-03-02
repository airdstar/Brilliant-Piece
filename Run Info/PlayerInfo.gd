extends Resource
class_name PlayerInfo

@export var rc : Vector2i
@export var currentFloorNum : int = 1

@export var classType : ClassResource
@export var pieceType : PieceTypeResource

@export var level : int = 1
@export var expAmount : int = 0

@export var maxHealth : int
@export var health : int
@export var armor : int = 0

@export var healthStatus : Array[StatusResource]
@export var damageStatus : Array[StatusResource]
@export var otherStatus : Array[StatusResource]

@export var actions : Array[ActionResource]
@export var items : Array[ItemResource]
@export var coins : int = 0
@export var soul : int = 0

@export var isNew : bool = true
