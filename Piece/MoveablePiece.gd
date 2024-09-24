extends Piece
class_name MoveablePiece

var previousTile : tile
var currentTile : tile

var type : PieceTypeResource
var level : int
var maxHealth : int
var health : int
var armor : int

var healthStatus : Array[StatusResource]
var damageStatus : Array[StatusResource]
var otherStatus : Array[StatusResource]

@onready var modelHolder = $Model

signal death

func loadModel(model):
	model = model.instantiate()
	modelHolder.add_child(model)

func fall():
	pass

func actionUsed(action : ActionResource):
	if action.damage:
		damage(action.damage)
	if action.healing:
		heal(action.healing)
	if action.armor:
		addArmor(action.armor)
	
	PlayerData.updateData()
	FloorData.updateData()

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
	if status.effect.effectType == "Health":
		if !healthStatus.has(status):
			healthStatus.append(status)
	elif status.effect.effectType == "Damage":
		if !damageStatus.has(status):
			damageStatus.append(status)
	else:
		if !otherStatus.has(status):
			otherStatus.append(status)
	
	PlayerData.updateData()
	FloorData.updateData()


func setPieceOrientation(dir : int):
	global_rotation.y = deg_to_rad(FloorData.floor.Handlers.DH.dirDict["RotData"][dir])
