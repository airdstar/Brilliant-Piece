extends Resource
class_name BehaviorResource

@export_category("General")
@export_enum("Player", "Enemy", "Neutral", "Obstruction", "Away") var target : String
@export_enum("Attack", "Status", "Defense", "Heal") var type : String
