extends Resource
class_name Interactable

@export_category("General")
@export var name : String
@export var desc : String
@export_enum("Damage", "Healing", "Defensive", "Hazard", "Status", "Movement") var type : String
@export var AOE : AOEResource
@export_flags("Self", "Enemy", "Tile") var usableOn : int

@export_category("Basic Stats")
@export var damage : int
@export var healing : int
@export var armor : int
@export var status : StatusResource
@export var hazard : HazardResource
@export var effect : EffectResource



func getTiles(_iStart : Vector2i):
	pass

func getUsable():
	pass
