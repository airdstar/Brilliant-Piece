extends Control

var currentlySelected = null
@onready var turnHUD : Array[TextureRect] = [$TurnHUD/MoveOutline/Move, $TurnHUD/ActionOutline/Action, $TurnHUD/TurnOutline/Turn]
@onready var textLabels = [$Portrait/Status/NameLabel, $Portrait/Status/TypeLabel, $Portrait/Status/HealthLabel]

func _ready():
	pass


func showFloorInfo():
	$Floor_Player.visible = true

func hideFloorInfo():
	$Floor_Player.visible = false

func showPieceInfo():
	$Portrait.visible = true

func hidePieceInfo():
	$Portrait.visible = false

func updatePortrait():
	if currentlySelected != null:
		$SubViewport/Portrait.remove_child(currentlySelected)
	$Portrait.visible = true
	currentlySelected = FloorData.floor.Handlers.TH.highlightedTile.contains.modelHolder.duplicate()
	$SubViewport/Portrait.add_child(currentlySelected)
	currentlySelected.global_position = $SubViewport/Portrait.global_position
	currentlySelected.global_rotation.y = deg_to_rad(-90)
	if FloorData.floor.Handlers.TH.highlightedTile.contains is PlayerPiece:
		$SubViewport/Portrait/Camera3D/MeshInstance3D.mesh.material.set_albedo(Color(0.63,0.72,0.86))
	elif FloorData.floor.Handlers.TH.highlightedTile.contains is EnemyPiece:
		$SubViewport/Portrait/Camera3D/MeshInstance3D.mesh.material.set_albedo(Color(0.86,0.63,0.72))
	$Portrait/PortraitBackground.texture = $SubViewport.get_texture()

func updateLabels():
	var piece = FloorData.floor.Handlers.TH.highlightedTile.contains
	textLabels[0].text = " " + piece.pieceName + " lvl " + str(piece.level)
	textLabels[1].text = " " + piece.type.typeName
	textLabels[2].text = " [img]res://UI/Heart.png[/img] " + str(piece.health) + "/" + str(piece.maxHealth)
	if piece.armor > 0:
		textLabels[2].text += "   [img]res://UI/Armor.png[/img] " + str(piece.armor)
