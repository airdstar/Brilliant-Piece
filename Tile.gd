extends Node3D
class_name tile

var pointerHeight
var moveable := false
var material := StandardMaterial3D.new()
var contains : Piece
var closeTiles := [null, null, null, null]

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
	

func Direction1Found(area):
	closeTiles[0] = area.get_parent()

func Direction2Found(area):
	closeTiles[1] = area.get_parent()

func Direction3Found(area):
	closeTiles[2] = area.get_parent()

func Direction4Found(area):
	closeTiles[3] = area.get_parent()


func Direction1Lost(_area):
	closeTiles[0] = null

func Direction2Lost(_area):
	closeTiles[1] = null

func Direction3Lost(_area):
	closeTiles[2] = null

func Direction4Lost(_area):
	closeTiles[3] = null
