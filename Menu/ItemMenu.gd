extends Control

var selectedItemPos := Vector3(0,-0.3,-0.9)
var itemCount : int
var highlightedItem : int
var items : Array[ItemResource]

func _ready():
	$SubViewport/Base/Items/Bomb.position = selectedItemPos

func _process(delta: float):
	$TextureRect/Screen.texture = $SubViewport.get_texture()
	$SubViewport/Base/Items/Bomb.rotate_y(-0.01)
	
	if Input.is_action_just_pressed("Cancel"):
		queue_free()
	
