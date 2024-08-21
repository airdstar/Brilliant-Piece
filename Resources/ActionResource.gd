extends Resource
class_name ActionResource

@export var name : String
@export var animationPath : String
@export var damage : int
@export var healing : int

@export var range : int
@export var actionDirection : String #Straight/Diagonal/Both
@export var rangeExclusive : bool #Does it only hit that range
@export var blockable : bool

@export var knockback : bool
@export var status : String
@export var AOE : int
