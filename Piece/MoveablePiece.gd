extends Piece
class_name MoveablePiece

var rc : Vector2i

var type : PieceTypeResource
var level : int
var maxHealth : int
var health : int
var armor : int

var healthStatus : Array[StatusResource]
var damageStatus : Array[StatusResource]
var otherStatus : Array[StatusResource]

signal death

func _ready():
	self.death.connect(FloorData.floor.pieceDeath)

func interact():
	var interactable = FloorData.floor.Handlers.SH.interactable
	var acting = FloorData.floor.Handlers.SH.actingPiece
	
	if interactable.damage:
		if interactable is ActionResource:
			damage((interactable.damage + acting.flatDamage()) * acting.percentDamage())
		else:
			damage(interactable.damage)
	if interactable.healing:
		heal(interactable.healing)
	if interactable.armor:
		addArmor(interactable.armor)
	if interactable.status:
		applyStatus(interactable.status)

func damage(damageAmount : int):
	if damageAmount >= armor:
		damageAmount -= armor
		armor = 0
	else:
		armor -= damageAmount
		damageAmount = 0
	
	health -= damageAmount
	
	if health <= 0:
		health = 0
		PlayerData.updateData()
		FloorData.updateData()
		death.emit(self)
	
	PlayerData.updateData()
	FloorData.updateData()

func heal(healingAmount : int):
	health += healingAmount
	if health >= maxHealth:
		health = maxHealth
	
	PlayerData.updateData()
	FloorData.updateData()

func addArmor(armorAmount : int):
	if armor == 0:
		armor = armorAmount
	
	PlayerData.updateData()
	FloorData.updateData()

func applyStatus(status : StatusResource):
	if status.effect.type == "Health":
		if !healthStatus.has(status):
			healthStatus.append(status)
	elif status.effect.type == "Damage":
		if !damageStatus.has(status):
			damageStatus.append(status)
			print("hi")
	else:
		if !otherStatus.has(status):
			otherStatus.append(status)
	
	PlayerData.updateData()
	FloorData.updateData()

func flatDamage():
	var toReturn : int = 0
	for n in range(damageStatus.size()):
		toReturn += damageStatus[n].effect.effectStrength

	return toReturn

func percentDamage():
	var toReturn : float = 1
	for n in range(damageStatus.size()):
		pass
	
	return toReturn
