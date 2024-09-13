extends Node
class_name PlayableArea

var mouse_sensitivity := 0.0005
var twist : float

@onready var menuHolder = $Menu

@onready var Pointer = $Pointer
@onready var camera = $Twist/Camera3D
@onready var cameraBase = $Twist

func _ready():
	pass

func cameraControls():
	$Twist.rotate_y(twist)
	twist = 0

func _unhandled_input(event : InputEvent):
	if event is InputEventMouseMotion:
		twist = -event.relative.x *  mouse_sensitivity
