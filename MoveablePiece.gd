extends Piece
class_name MoveablePiece

var maxHealth : int
var health : int

signal death

func fall():
	pass

func damage(action : ActionResource):
	health -= action.damage
	if health <= 0:
		death.emit()
