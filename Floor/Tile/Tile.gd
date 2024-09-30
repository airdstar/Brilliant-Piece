extends Node3D
class_name tile

var piecePos : Vector3 = Vector3(0,0.3,0)
var pointerPos : float = 1.5
var pointerPosBlocked : int = 2

var rc : Vector2i

var contains : Piece
var hazard : HazardResource
var hazardModel
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
	if piece.rc:
		var tween = create_tween()
		tween.tween_property(piece, "global_position", piecePos + self.global_position, 0.2
							).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	else:
		contains.global_position = piecePos + self.global_position
	
	piece.rc = rc
	
	if piece is PlayerPiece:
		PlayerData.playerInfo.rc = rc
	elif piece is EnemyPiece:
		FloorData.floorInfo.enemies[FloorData.floor.enemies.find(piece)].rc = rc
	

func interact():
	var interactable = FloorData.floor.Handlers.SH.interactable
	var acting = FloorData.floor.Handlers.SH.actingPiece
	
	if contains is MoveablePiece:
		if interactable.damage:
			if interactable is ActionResource:
				contains.damage((interactable.damage + acting.flatDamage()) * acting.percentDamage())
			else:
				contains.damage(interactable.damage)
		if interactable.healing:
			contains.heal(interactable.healing)
		if interactable.armor:
			contains.addArmor(interactable.armor)
		if interactable.status:
			contains.applyStatus(interactable.status)
	
	if hazard:
		if interactable.damage:
			if hazard.destructable:
				FloorData.floorInfo.tiles[FloorData.floor.Handlers.TH.tileDict["Tiles"].find(self)].hazard = null
				hazard = null
				obstructed = false
				hazardModel.queue_free()
	
	if interactable.hazard:
		setHazard(interactable.hazard)
	
	if interactable is ActionResource:
		FloorData.floor.HUD.turnHUD[1].modulate = Color(0.5,0.5,0.5)
		FloorData.floorInfo.actionUsed = true
	
	FloorData.floor.Handlers.SH.interactable = null
	
	PlayerData.updateData()
	FloorData.updateData()

func setHazard(hazardIn : HazardResource):
	hazard = hazardIn
	if hazard.blockade:
		obstructed = true
	
	FloorData.floorInfo.tileInfo[rc.x][rc.y].hazard = hazard
	
	hazardModel = ResourceLoader.load(hazard.associatedModel).instantiate()
	add_child(hazardModel)
	hazardModel.position.y += 0.055


func getPointerPos():
	if contains or obstructed:
		return 2
	else:
		return 1.5

func setColor(color : Color):
	tileBase.material_override.set_albedo(color)
