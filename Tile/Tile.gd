extends Node3D
class_name tile

var piecePos : Vector3 = Vector3(0,0.3,0)
var pointerPos : float = 1.5
var pointerPosBlocked : int = 2

var pointerHeight
var moveable := false
var hittable := false
var material := StandardMaterial3D.new()
var contains : Piece
var obstructed := false

@onready var highlight := $Base/Highlight
@onready var tileBase := $Base
var lowestOpacity := 0.2
var additionalOpacity : float
var growing := true


func _ready():
	tileBase.material_override = material
	pointerHeight = [pointerPos, pointerPosBlocked]

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
	contains.global_position = piecePos + self.global_position

func actionUsed(action : ActionResource):
	if contains:
		contains.actionUsed(action)

func getPointerPos():
	if contains:
		return pointerHeight[1]
	else:
		return pointerHeight[0]

func setColor(color : String):
	match color:
		"White":
			tileBase.material_override.set_albedo(Color(1,1,1))
		"Black":
			tileBase.material_override.set_albedo(Color(0,0,0))
		"Gray":
			tileBase.material_override.set_albedo(Color(0.5,0.5,0.5))
		"Blue":
			tileBase.material_override.set_albedo(Color(0.63,0.72,0.86))
		"Green":
			tileBase.material_override.set_albedo(Color(0.63,0.86,0.72))
		"Red":
			tileBase.material_override.set_albedo(Color(0.86,0.63,0.72))
		"Orange":
			tileBase.material_override.set_albedo(Color(0.86,0.72,0.63))
	
