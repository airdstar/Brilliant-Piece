extends Piece
class_name MoveablePiece

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
	match dir:
		2:
			global_rotation.y = deg_to_rad(0)
		3:
			global_rotation.y = deg_to_rad(45)
		4:
			global_rotation.y = deg_to_rad(90)
		5:
			global_rotation.y = deg_to_rad(135)
		6:
			global_rotation.y = deg_to_rad(180)
		7:
			global_rotation.y = deg_to_rad(-135)
		0:
			global_rotation.y = deg_to_rad(-90)
		1:
			global_rotation.y = deg_to_rad(-45)
