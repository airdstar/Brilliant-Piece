extends Control
class_name tile

var hovered : bool
var rc : Vector2i

var contains : Piece
var hazard : HazardResource
var hazardHolder : TextureRect
var obstructed := false

@onready var tileColor = $TileColor
@onready var interactable = $Interactable

func _ready():
	pass

func setPiece(piece : Piece):
	contains = piece
	if piece.rc:
		if FloorData.tiles[piece.rc.x][piece.rc.y] != self:
			FloorData.tiles[piece.rc.x][piece.rc.y].contains = null
		var tween = create_tween()
		tween.tween_property(piece, "position", self.position, 0.2
							).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	else:
		piece.position = position
	
	piece.rc = rc

func interact():
	var inter = FloorData.floor.Handlers.SH.interactable
	var acting = FloorData.floor.Handlers.SH.actingPiece
	
	if contains is MoveablePiece:
		contains.interact()
	
	if hazard:
		if inter.damage:
			if hazard.destructable:
				remove_child(hazardHolder)
				hazardHolder = null
				hazard = null
				obstructed = false
	
	if inter.hazard:
		setHazard(inter.hazard)
	
	if inter is ActionResource:
		FloorData.floor.HUD.turnHUD[1].modulate = Color(0.5,0.5,0.5)
		FloorData.floorInfo.actionUsed = true
	
	FloorData.floor.Handlers.SH.interactable = null
	
	FloorData.updateData()

func setHazard(hazardIn : HazardResource):
	hazard = hazardIn
	if hazard.blockade:
		obstructed = true
	
	FloorData.floorInfo.tileInfo[rc.x][rc.y].hazard = hazard
	
	hazardHolder = TextureRect.new()
	hazardHolder.set_texture(ResourceLoader.load(hazard.associatedSprite))
	add_child(hazardHolder)
	

func mouseHovered() -> void:
	FloorData.floor.Handlers.HH.highlightTile(Vector2i(rc.x,rc.y))

func mouseExited() -> void:
	if FloorData.floor.Handlers.TH.highlightedTile == self:
		FloorData.floor.Handlers.HH.unhighlightTile()
