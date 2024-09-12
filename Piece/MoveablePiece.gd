extends Piece
class_name MoveablePiece

var previousTile : tile
var currentTile : tile

var type : PieceTypeResource
var maxHealth : int
var health : int
var armor : int
@onready var modelHolder = $Model

signal death

func fall():
	pass

func actionUsed(action : ActionResource):
	if action.damage:
		damage(action.damage)
	if action.healing:
		heal(action.healing)

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
		death.emit()

func heal(healingAmount : int):
	health += healingAmount
	if health >= maxHealth:
		health = maxHealth

func setPieceOrientation(dir : DirectionHandler.Direction):
	global_rotation.y = deg_to_rad(DirectionHandler.dirDict["RotData"][dir])
