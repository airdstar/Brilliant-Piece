extends Node3D
class_name tile

var piecePos : Vector3 = Vector3(0,0.3,0)
var pointerPos : float = 1.5
var pointerPosBlocked : int = 2

var contains : Piece
var hazard : HazardResource
var obstructed := false

@onready var highlight := $Base/Highlight
@onready var tileBase := $Base
var lowestOpacity := 0.2
var additionalOpacity : float
var growing := true


func _ready():
	tileBase.material_override = StandardMaterial3D.new()

func _process(_delta):
	if growing:
		additionalOpacity += 0.001
	else:
		additionalOpacity -= 0.001
	
	if highlight.visible:
		highlight.mesh.material.set_albedo(Color(1,1,1,lowestOpacity + additionalOpacity))

func SwitchHighlight():
	growing = !growing

func setPiece(piece : Piece, dir : int):
	contains = piece
	piece.setPieceOrientation(dir)
	if piece.currentTile:
		piece.previousTile = piece.currentTile
		piece.previousTile.contains = null
		var tween = create_tween()
		tween.tween_property(piece, "global_position", piecePos + self.global_position, 0.2).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	else:
		contains.global_position = piecePos + self.global_position
	
	piece.currentTile = self
	
	if piece is PlayerPiece:
		PlayerData.playerInfo.currentPos = global_position
	elif piece is EnemyPiece:
		FloorData.floorInfo.enemies[FloorData.floor.enemies.find(piece)].currentPos = global_position
	

func actionUsed(action : ActionResource):
	if contains is MoveablePiece:
		if action.damage:
			contains.damage(action.damage)
		if action.healing:
			contains.heal(action.healing)
		if action.armor:
			contains.addArmor(action.armor)

func itemUsed(item : ItemResource):
	if contains is MoveablePiece:
		if item.damage:
			contains.damage(item.damage)
		if item.healing:
			contains.heal(item.healing)
		if item.armor:
			contains.addArmor(item.armor)
	if item.hazard:
		hazard = item.hazard
	item.use()
	

func getPointerPos():
	if contains:
		return 2
	else:
		return 1.5

func setColor(color : Color):
	tileBase.material_override.set_albedo(color)
