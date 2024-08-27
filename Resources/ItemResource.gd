extends Resource
class_name ItemResource

@export_category("General")
@export var name : String
@export var desc : String
@export var associatedModel : String
@export_enum("Damage", "Healing", "Defensive", "Hazard", "Status", "Ammo") var itemType : String
@export_flags("Self", "Enemy", "Tile") var usableOn : int


@export var useAmount : int
var amountUsed = useAmount
@export var itemRange : int = 3
#Direction is square always

@export_category("Basic Stats")
@export var damage : int
@export var healing : int
@export var armor : int
