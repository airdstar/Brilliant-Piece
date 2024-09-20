extends Menu
class_name ItemMenu

var selectedItemPos := Vector3(-4,-1,0)
var leftItemPos := Vector3(-8,-2,9)
var rightItemPos := Vector3(-8,-2,-9)

var itemCount : int
var physicalItems : Array[Node3D]
var itemIndicators : Array[TextureRect]

func _process(_delta: float):
	$MenuTop/Screen.texture = $SubViewport.get_texture()
	if itemCount != 0:
		physicalItems[highlightedOption].rotate_y(-0.01)

func addOptions():
	options = PlayerData.playerInfo.items
	itemCount = options.size()
	if itemCount > 0:
		var loopAmount = 4 - itemCount
		if loopAmount <= 1:
			loopAmount = 1
		for m in range(loopAmount):
			for n in range(itemCount):
				var s = ResourceLoader.load(options[n].associatedModel)
				s = s.instantiate()
				physicalItems.append(s)
				$SubViewport/Base.add_child(s)
				if m == 0:
					var t = TextureRect.new()
					t.set_texture(load("res://UI/Menu/ItemHighlight.png"))
					$MenuTop/Screen.add_child(t)
					t.size = Vector2(4,4)
					t.position = Vector2(4 + n * 5,1)
					itemIndicators.append(t)
		swapItem()

func selectOption():
	FloorData.floor.Handlers.SH.item = options[highlightedOption]
	FloorData.floor.Handlers.TH.show("Item")
	FloorData.floor.Handlers.UH.fullyCloseMenu()

func swapItem():
	for n in range(physicalItems.size()):
		physicalItems[n].position = Vector3(0,200,0)
	
	for n in range(itemCount):
		itemIndicators[n].modulate = Color(0.5,0.5,0.5)
	
	physicalItems[highlightedOption].position = selectedItemPos
	physicalItems[highlightedOption].set_rotation_degrees(Vector3(0,-90,0))
	itemIndicators[highlightedOption].modulate = Color(0.9,0.9,0.9)
	
	$MenuTop/NameLabel.text = options[highlightedOption].name
	$MenuBottom/StatsLabel.text = options[highlightedOption].desc
	$MenuBottom/StatsLabel.text += "\n" + options[highlightedOption].itemType
	
	if highlightedOption == 0:
		physicalItems[physicalItems.size() - 1].position = leftItemPos
		physicalItems[physicalItems.size() - 1].set_rotation_degrees(Vector3(0,-90,0))
	else:
		physicalItems[highlightedOption - 1].position = leftItemPos
		physicalItems[highlightedOption - 1].set_rotation_degrees(Vector3(0,-90,0))
	
	if highlightedOption == physicalItems.size() - 1:
		physicalItems[0].position = rightItemPos
		physicalItems[0].set_rotation_degrees(Vector3(0,-90,0))
	else:
		physicalItems[highlightedOption + 1].position = rightItemPos
		physicalItems[highlightedOption + 1].set_rotation_degrees(Vector3(0,-90,0))
	
