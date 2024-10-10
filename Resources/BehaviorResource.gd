extends Resource
class_name BehaviorResource

@export_category("General")
@export_enum("Player", "Enemy", "Neutral", "Obstruction", "Nothing") var target : String
@export_flags("Attack", "Buff", "Debuff", "Defense", "Tank", "Heal") var type : int
@export_flags("Close", "Medium", "Far") var desiredRange : int
