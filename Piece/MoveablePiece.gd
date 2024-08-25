extends Piece
class_name MoveablePiece

var maxHealth : int
var health : int

signal death

func fall():
	pass

func actionUsed(action : ActionResource):
	if action.damage:
		damage(action.damage)
	if action.healing:
		heal(action.healing)

func damage(damageAmount : int):
	health -= damageAmount
	if health <= 0:
		health = 0
		death.emit()

func heal(healingAmount : int):
	health += healingAmount
	if health >= maxHealth:
		health = maxHealth
