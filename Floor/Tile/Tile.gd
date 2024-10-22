extends Node2D
class_name tile

var hovered : bool
var rc : Vector2i

var contains : Piece
var hazard : HazardResource
var hazardHolder : Sprite2D
var obstructed := false

@onready var tileColor = $TileColor
@onready var interactable = $Interactable

func _ready():
	pass

func setPiece(piece : Piece, type : int):
	## 0 is for loading an area
	## 1 is for moving to a new tile
	## 2 is for being pushed to a new tile
	## 3 is for falling onto a new tile
	contains = piece
	match type:
		0:
			piece.position = position
		1:
			var tween = create_tween()
			tween.tween_property(piece, "position", self.position, 0.2
								).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		2:
			var tween = create_tween()
			tween.tween_property(piece, "position", self.position, 0.15
								).set_trans(Tween.TRANS_BACK)
		3:
			piece.position = position
			piece.scale = Vector2(2,2)
			var tween = create_tween()
			tween.tween_property(piece, "scale", Vector2(1,1), 0.15
								).set_trans(Tween.TRANS_BACK)
	piece.rc = rc

func interact():
	var inter = FloorData.floor.Handlers.SH.interactable
	var _acting = FloorData.floor.Handlers.SH.actingPiece
	
	
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
	
	
	FloorData.updateData()

func setHazard(hazardIn : HazardResource):
	hazard = hazardIn
	if hazard.blockade:
		obstructed = true
	
	FloorData.floorInfo.tileInfo[rc.x][rc.y].hazard = hazard
	
	hazardHolder = Sprite2D.new()
	hazardHolder.set_texture(hazard.associatedSprite)
	add_child(hazardHolder)
	

func mouseHovered() -> void:
	FloorData.floor.Handlers.HH.highlightTile(Vector2i(rc.x,rc.y))

func mouseExited() -> void:
	if FloorData.floor.Handlers.TH.highlightedTile == self:
		FloorData.floor.Handlers.HH.unhighlightTile()
