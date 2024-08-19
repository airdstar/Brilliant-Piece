extends Node3D
class_name tile

var pointerHeight
var moveable := false
var material := StandardMaterial3D.new()
var contains : Piece
var obstructed := false

func _ready():
	$Base.material_override = material
	pointerHeight = [$PointerPos.position.y, $PointerPosBlocked.position.y]

func setPiece(piece : Piece):
	contains = piece
	piece.currentTile = self
	contains.global_position = $PiecePos.global_position

func getPointerPos():
	if contains:
		return pointerHeight[1]
	else:
		return pointerHeight[0]

func setColor(color : String):
	match color:
		"White":
			$Base.material_override.set_albedo(Color(1,1,1))
		"Black":
			$Base.material_override.set_albedo(Color(0,0,0))
		"Blue":
			$Base.material_override.set_albedo(Color(0.569,0.71,1))
		"Green":
			$Base.material_override.set_albedo(Color(0.569,1,0.71))
		"Red":
			$Base.material_override.set_albedo(Color(1,0.569,0.71))
	
