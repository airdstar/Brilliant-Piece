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
	match type:
		0:
			piece.position = position
		1:
			var tween = create_tween()
			tween.tween_property(piece, "position", self.position, 0.2
								).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		2:
			
			var particles := CPUParticles2D.new()
			particles.amount = 18
			particles.lifetime = 0.09
			particles.spread = 65
			particles.gravity = Vector2.ZERO
			particles.initial_velocity_min = 165
			particles.initial_velocity_max = 250
			particles.scale_amount_min = 3
			particles.scale_amount_max = 5
			particles.color = Color(0.7,0.7,0.7)
			
			particles.z_index = 1
			particles.position = (piece.position + self.position)/2
			particles.set_rotation_degrees(FloorData.floor.Handlers.DH.dirDict["RotData"][FloorData.floor.Handlers.DH.getClosestDirection(piece.rc, rc)] - 180)
			
			Global.create_particles(particles, FloorData.floor, 0)
			
			
			
			var tween = create_tween()
			tween.tween_property(piece, "position", self.position, 0.15
								).set_trans(Tween.TRANS_BACK)
			
		3:
			var scaleTween = create_tween()
		
			scaleTween.tween_property(piece, "scale", Vector2(0.6,0.6), 0.15
								).set_trans(Tween.TRANS_QUART)
		
			await get_tree().create_timer(0.15).timeout
			
			piece.scale = Vector2(2,2)
			piece.position = position
			
			var tween = create_tween()
			tween.tween_property(piece, "scale", Vector2(1,1), 0.15
								).set_trans(Tween.TRANS_BACK)
			
			
			
			var particles := CPUParticles2D.new()
			particles.amount = 18
			particles.lifetime = 0.1
			particles.spread = 180
			particles.gravity = Vector2.ZERO
			particles.initial_velocity_min = 165
			particles.initial_velocity_max = 250
			particles.scale_amount_min = 3
			particles.scale_amount_max = 5
			particles.color = Color(0.7,0.7,0.7)
			
			particles.z_index = 1
			particles.position = position
			
			Global.create_particles(particles, FloorData.floor, 0.15)
	
	if FloorData.tiles[piece.rc.x][piece.rc.y].contains == piece:
		FloorData.tiles[piece.rc.x][piece.rc.y].contains = null
	piece.rc = rc
	contains = piece

func interact():
	var inter = FloorData.floor.Handlers.SH.interactable
	var _acting = FloorData.floor.Handlers.SH.actingPiece
	
	
	if contains is MoveablePiece:
		contains.interact()
	
	if hazard:
		if inter.damage:
			if obstructed:
				remove_hazard()
	
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

func remove_hazard():
	remove_child(hazardHolder)
	hazardHolder = null
	hazard = null
	obstructed = false

func get_contain():
	if contains:
		if contains is PlayerPiece:
			return 1
		elif contains is EnemyPiece:
			return 2
	else:
		return 0

func has_target():
	if contains:
		return true
	elif obstructed:
		return true
	else:
		return false

func set_interactable(type : String, relevant : bool):
	interactable.visible = true
	match type:
		"Move":
			interactable.modulate = Global.colorDict["White"]
		"Damage":
			interactable.modulate = Global.colorDict["Orange"]
		"Healing":
			interactable.modulate = Global.colorDict["Green"]
		"Defensive":
			interactable.modulate = Global.colorDict["Blue"]
		"Status":
			interactable.modulate = Global.colorDict["Green"]
		"Hazard":
			interactable.modulate = Global.colorDict["Green"]
	
	if !relevant:
		interactable.modulate -= Color(0,0,0,0.5)



func mouseHovered() -> void:
	FloorData.floor.Handlers.HH.highlightTile(Vector2i(rc.x,rc.y))

func mouseExited() -> void:
	if FloorData.floor.Handlers.TH.highlightedTile == self:
		FloorData.floor.Handlers.HH.unhighlightTile()
