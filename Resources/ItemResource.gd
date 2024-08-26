extends Resource
class_name ItemResource

@export var name : String
@export_enum("Damage", "Healing", "Hazard", "Status", "Ammo", "Artifact") var itemType : String
@export_flags("Self", "Enemy", "Tile") var usableOn : int

@export var useAmount : int
var amountUsed = useAmount

@export var itemRange : int
