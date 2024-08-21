extends Piece
class_name MoveablePiece

var maxHealth : int
var health : int

signal death

func damage(attack : AttackResource):
	health -= attack.damage
	if health <= 0:
		print("Dead")
		death.emit()
