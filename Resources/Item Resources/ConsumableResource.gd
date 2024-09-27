extends ItemResource
class_name ConsumableResource

@export_category("Basic Stats")
@export var damage : int
@export var healing : int
@export var armor : int
@export var status : StatusResource
@export var hazard : HazardResource
@export var effect : EffectResource

@export_flags("Self", "Enemy", "Tile") var usableOn : int

func getUsable():
	var amount = usableOn
	var possibleUses = []

	if amount >= 4:
		amount -= 4
		possibleUses.append("Tile")
	if amount >= 2:
		amount -= 2
		possibleUses.append("Enemy")
	if amount >= 1:
		amount -= 1
		possibleUses.append("Self")
	
	return possibleUses
