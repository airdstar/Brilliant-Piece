extends Node3D
class_name tile

var pointerHeight
var moveable := false
var hittable := false
var material := StandardMaterial3D.new()
var contains : Piece
var obstructed := false

@onready var highlight := $Base/Highlight
var lowestOpacity := 0.2
var additionalOpacity : float
var growing := true


func _ready():
	$Base.material_override = material
	pointerHeight = [$PointerPos.position.y, $PointerPosBlocked.position.y]

func _process(_delta):
	if growing:
		additionalOpacity += 0.001
	else:
		additionalOpacity -= 0.001
	
	if highlight.visible:
		highlight.mesh.material.set_albedo(Color(1,1,1,lowestOpacity + additionalOpacity))


func ToggleGrow():
	growing = !growing

func setPiece(piece : Piece):
	contains = piece
	piece.currentTile = self
	contains.global_position = $PiecePos.global_position

func actionUsed(action : ActionResource):
	if contains:
		contains.damage(action)

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
		"Gray":
			$Base.material_override.set_albedo(Color(0.5,0.5,0.5))
		"Blue":
			$Base.material_override.set_albedo(Color(0.63,0.72,0.86))
		"Green":
			$Base.material_override.set_albedo(Color(0.63,0.86,0.72))
		"Red":
			$Base.material_override.set_albedo(Color(0.86,0.63,0.72))
		"Orange":
			$Base.material_override.set_albedo(Color(0.86,0.72,0.63))
	
