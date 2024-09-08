extends Piece
class_name MoveablePiece

var type : PieceTypeResource
var maxHealth : int
var health : int
var armor : int

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

func setPieceOrientation(dir : String):
	match dir:
		"West":
			global_rotation.y = deg_to_rad(0)
		"SouthWest":
			global_rotation.y = deg_to_rad(45)
		"South":
			global_rotation.y = deg_to_rad(90)
		"SouthEast":
			global_rotation.y = deg_to_rad(135)
		"East":
			global_rotation.y = deg_to_rad(180)
		"NorthEast":
			global_rotation.y = deg_to_rad(-135)
		"North":
			global_rotation.y = deg_to_rad(-90)
		"NorthWest":
			global_rotation.y = deg_to_rad(-45)
