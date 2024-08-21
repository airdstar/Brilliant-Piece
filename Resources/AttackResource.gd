extends Resource
class_name AttackResource

@export var name : String
@export var animationPath : String
@export var damage : int
@export var scaling : float

@export var attackRange : int
@export var attackDirection : String #Straight/Diagonal/Both
@export var rangeExclusive : bool #Does it only hit that range
@export var blockable : bool

@export var knockback : bool
@export var status : String
@export var AOE : Vector2
