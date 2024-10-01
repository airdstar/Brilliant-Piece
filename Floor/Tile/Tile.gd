extends Control
class_name tile

var rc : Vector2i
var contains : Piece
var hazard : HazardResource

var obstructed := false

func setPiece(piece : Piece, dir : int):
	contains = piece
	piece.setPieceOrientation(dir)
	if piece.rc:
		FloorData.tiles[piece.rc.x][piece.rc.y].contains = null
		var tween = create_tween()
		tween.tween_property(piece, "global_position", self.global_position, 0.2
							).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	else:
		pass
	
	piece.rc = rc
	
	FloorData.updateData()

func interact():
	var interactable = FloorData.floor.Handlers.SH.interactable
	var acting = FloorData.floor.Handlers.SH.actingPiece
	
	if contains is MoveablePiece:
		contains.interact()
	
	if hazard:
		if interactable.damage:
			if hazard.destructable:
				FloorData.floorInfo.tiles[FloorData.floor.Handlers.TH.tileDict["Tiles"].find(self)].hazard = null
				hazard = null
				obstructed = false
	
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
