extends Control

var currentlySelected = null
@onready var turnHUD : Array[TextureRect] = [$TurnHUD/MoveOutline/Move, $TurnHUD/ActionOutline/Action, $TurnHUD/TurnOutline/Turn]
@onready var textLabels = [$Status/NameLabel, $Status/TypeLabel, $Status/LevelLabel, $Status/HealthLabel, $Status/SoulLabel]

func _ready():
	pass

func updateTurn():
	pass

func showPieceInfo():
	$Status.visible = true
	$Portrait.visible = true

func hidePieceInfo():
	$Status.visible = false
	$Portrait.visible = false

func updatePortrait():
	if currentlySelected != null:
		$SubViewport/Portrait.remove_child(currentlySelected)
	$Portrait.visible = true
	currentlySelected = GameState.highlightedTile.contains.modelHolder.duplicate()
	$SubViewport/Portrait.add_child(currentlySelected)
	currentlySelected.global_position = $SubViewport/Portrait.global_position
	currentlySelected.global_rotation.y = deg_to_rad(-90)
	if currentlySelected is PlayerPiece:
		$SubViewport/Portrait/Camera3D/MeshInstance3D.mesh.material.set_albedo(Color(0.63,0.72,0.86))
	elif currentlySelected is EnemyPiece:
		$SubViewport/Portrait/Camera3D/MeshInstance3D.mesh.material.set_albedo(Color(0.86,0.63,0.72))
	$Portrait/PortraitBackground.texture = $SubViewport.get_texture()

func updateLabels():
	var piece = GameState.highlightedTile.contains
	textLabels[0].text = piece.pieceName
	textLabels[1].text = piece.type.typeName
	textLabels[2].text = "Enemy lvl " + str(piece.level)
	textLabels[3].text = "[img]res://UI/Heart.png[/img] " + str(piece.health) + "/" + str(piece.maxHealth)
	textLabels[4].text = ""
	if piece.armor > 0:
		textLabels[3].text += "   [img]res://UI/Armor.png[/img] " + str(piece.armor)
	if piece is PlayerPiece:
		textLabels[2].text = str(piece.classType.className) + " lvl " + str(piece.level) 
		textLabels[4].text = "[img]res://UI/Soul.png[/img] " + str(piece.soul) + "/" + str(piece.maxSoul)
