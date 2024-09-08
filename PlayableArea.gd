extends Node
class_name PlayableArea

var mouse_sensitivity := 0.0005
var twist : float


var inMenu : bool = false

var playerTile : tile

var playerTurn : bool = true
var actionUsed : bool = false
var moveUsed : bool = false

var viewing : bool = false
var item : ItemResource
var moving : MoveablePiece
var action : ActionResource

var highlightedTile : tile

@onready var tileHolder = $Tiles
@onready var menuHolder = $Menu

@onready var Pointer = $Pointer
@onready var camera = $Twist/Camera3D
@onready var cameraBase = $Twist

func _ready():
	secondaryReady()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func secondaryReady():
	pass

func _process(_delta):
	if Input.is_action_just_pressed("Exit"):
		get_tree().quit()
	
	if playerTurn:
		
		
		if Input.is_action_just_pressed("Select"):
			if item and highlightedTile.hittable:
				#stopShowingOptions()
				#useItem(highlightedTile)
				#usedItem()
				pass
			if viewing:
				viewing = false
				openMenu()
		
		if Input.is_action_just_pressed("Cancel"):
			if item:
				#stopShowingOptions()
				item = null
				openMenu()
	if !inMenu:
		if Input.is_action_just_pressed("Left") or Input.is_action_just_pressed("Right") or Input.is_action_just_pressed("Forward") or Input.is_action_just_pressed("Backward"):
			#handleMovement()
			pass
	
	secondaryProcess(_delta)
	cameraControls()

func secondaryProcess(_delta):
	pass

func cameraControls():
	$Twist.rotate_y(twist)
	twist = 0


func highlightTile(tileToSelect : tile):
		if action:
			if action.AOE != 0:
				var pos = DirectionHandler.getAll("Both")
				for n in range(8):
					var currentTile = highlightedTile.global_position
					for m in range(action.AOE):
						currentTile += DirectionHandler.getPos(pos[n])
						#if lookForTile(currentTile):
							#lookForTile(currentTile).highlight.visible = true
							#lookForTile(currentTile).setColor("Red")

func endTurn():
	playerTurn = !playerTurn
	actionUsed = false
	moveUsed = false
	if !playerTurn:
		Pointer.visible = true
		$StaticHUD/TurnHUD/MoveOutline/Move.modulate = Color(0.86,0.63,0.72)
		$StaticHUD/TurnHUD/ActionOutline/Action.modulate = Color(0.86,0.63,0.72)
		$StaticHUD/TurnHUD/TurnOutline/Turn.modulate = Color(0.86,0.63,0.72)
	else:
		$StaticHUD/TurnHUD/MoveOutline/Move.modulate = Color(0.63,0.72,0.86)
		$StaticHUD/TurnHUD/ActionOutline/Action.modulate = Color(0.63,0.72,0.86)
		$StaticHUD/TurnHUD/TurnOutline/Turn.modulate = Color(0.63,0.72,0.86)

func openMenu():
	pass

func showItem():
	var tileData = item.getItemRange(playerTile.global_position)
	for n in range(tileData.size()):
		#if lookForTile(tileData[n]):
			#if item.itemType == "Damage":
			#	if lookForTile(tileData[n]).contains is EnemyPiece:
					pass
					#setHittable(lookForTile(tileData[n]))

func randPlacePiece(piece : MoveablePiece):
	var piecePlaced : bool = false
	while(!piecePlaced):
		var piecePos := randi_range(0, $Tiles.get_child_count() - 1)
		for n in range($Tiles.get_child_count()):
			if n == piecePos:
				if !$Tiles.get_child(n).contains:
					$Tiles.get_child(n).setPiece(piece)
					piecePlaced = true
					if piece is PlayerPiece:
						highlightTile($Tiles.get_child(n))
						playerTile = $Tiles.get_child(n)

func playerDeath():
	get_tree().quit()

func _unhandled_input(event : InputEvent):
	if event is InputEventMouseMotion:
		twist = -event.relative.x *  mouse_sensitivity
