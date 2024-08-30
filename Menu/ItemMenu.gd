extends Control

var selectedItemPos := Vector3(0,-1,-5)
var leftItemPos := Vector3(-8,-2,-7.5)
var rightItemPos := Vector3(8,-2,-7.5)
var itemCount : int
var highlightedItem : int
var items : Array[ItemResource]
var physicalItems : Array[Node3D]

func _process(_delta: float):
	$TextureRect/Screen.texture = $SubViewport.get_texture()
	physicalItems[highlightedItem].rotate_y(-0.01)
	
	
	if Input.is_action_just_pressed("Cancel"):
		queue_free()
	
	if Input.is_action_just_pressed("Left"):
		if highlightedItem == 0:
			highlightedItem = itemCount - 1
		else:
			highlightedItem -= 1
		swapItem()
	
	if Input.is_action_just_pressed("Right"):
		if highlightedItem == itemCount - 1:
			highlightedItem = 0
		else:
			highlightedItem += 1
		swapItem()
	
	if Input.is_action_just_pressed("Select"):
		get_parent().get_parent().get_parent().inMenu = false
		get_parent().get_parent().get_parent().item = items[highlightedItem]
		get_parent().get_parent().get_parent().showItem()
		get_parent().get_parent().get_parent().Pointer.visible = true
		get_parent().queue_free()

func setItems(itemList : Array[ItemResource]):
	items = itemList
	itemCount = items.size()
	highlightedItem = 0
	if itemCount > 0:
		if itemCount == 1:
			for m in range(3):
				for n in range(itemCount):
					var s = ResourceLoader.load(items[n].associatedModel)
					s = s.instantiate()
					physicalItems.append(s)
					$SubViewport/Base/Items.add_child(s)
		elif itemCount == 2:
			for m in range(2):
				for n in range(itemCount):
					var s = ResourceLoader.load(items[n].associatedModel)
					s = s.instantiate()
					physicalItems.append(s)
					$SubViewport/Base/Items.add_child(s)
		else:
			for n in range(itemCount):
				var s = ResourceLoader.load(items[n].associatedModel)
				s = s.instantiate()
				physicalItems.append(s)
				$SubViewport/Base/Items.add_child(s)
			
		swapItem()

func swapItem():
	for n in range(physicalItems.size()):
		physicalItems[n].position = Vector3(0,200,0)
	
	physicalItems[highlightedItem].position = selectedItemPos
	physicalItems[highlightedItem].set_rotation_degrees(Vector3(0,-90,0))
	
	$TextureRect/NameLabel.text = items[highlightedItem].name
	$TextureRect/StatsLabel.text = items[highlightedItem].desc
	$TextureRect/StatsLabel.text += "\n" + items[highlightedItem].itemType
	
	if highlightedItem == 0:
		physicalItems[physicalItems.size() - 1].position = leftItemPos
		physicalItems[physicalItems.size() - 1].set_rotation_degrees(Vector3(0,-90,0))
	else:
		physicalItems[highlightedItem - 1].position = leftItemPos
		physicalItems[highlightedItem - 1].set_rotation_degrees(Vector3(0,-90,0))
	
	if highlightedItem == physicalItems.size() - 1:
		physicalItems[0].position = rightItemPos
		physicalItems[0].set_rotation_degrees(Vector3(0,-90,0))
	else:
		physicalItems[highlightedItem + 1].position = rightItemPos
		physicalItems[highlightedItem + 1].set_rotation_degrees(Vector3(0,-90,0))
	
