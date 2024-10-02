extends Control

var currentlySelected = null
@onready var turnHUD : Array[TextureRect] = [$TurnHUD/MoveOutline/Move, $TurnHUD/ActionOutline/Action, $TurnHUD/TurnOutline/Turn]
@onready var textLabels = [$Portrait/Status/NameLabel, $Portrait/Status/TypeLabel, $Portrait/Status/HealthLabel]

func _ready():
	pass


func updateFloorInfo():
	$Floor_Player/FloorInfo.text = "[center]Floor " + str(FloorData.floorInfo.floorNum) + "\n" + str(FloorData.floorInfo.layerData.layerName)

func showPieceInfo():
	$Portrait.visible = true

func hidePieceInfo():
	$Portrait.visible = false

func updateLabels():
	var piece = FloorData.floor.Handlers.TH.highlightedTile.contains
	textLabels[0].text = " " + piece.pieceName + " lvl " + str(piece.level)
	textLabels[1].text = " " + piece.type.typeName
	textLabels[2].text = " [img]res://UI/Heart.png[/img] " + str(piece.health) + "/" + str(piece.maxHealth)
	if piece.armor > 0:
		textLabels[2].text += "   [img]res://UI/Armor.png[/img] " + str(piece.armor)
