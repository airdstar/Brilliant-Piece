extends Menu
class_name BasicMenu

func addOptions():
	optionCount = 2
	if !GameState.moveUsed:
		optionCount += 1
	if !GameState.actionUsed:
		optionCount += 1
	var prevPos = Vector2(0,0)
	for n in range(optionCount):
		var toAdd = preload("res://UI/Menu/BasicMenuOption.tscn").instantiate()
		options.append(toAdd)
		add_child(toAdd)
		if n != optionCount - 1 and n == 0:
			toAdd.SetSprite(1)
		elif n == optionCount - 1 and n != 0:
			toAdd.SetSprite(2)
			toAdd.setOptionType("End")
		elif optionCount != 1:
			toAdd.SetSprite(3)
		
		if n == optionCount - 2:
			toAdd.setOptionType("Items")
		
		match n:
			0:
				if !GameState.actionUsed:
					toAdd.setOptionType("Action")
				elif !GameState.moveUsed:
					toAdd.setOptionType("Move")
				hoverToggle()
			1:
				if !GameState.actionUsed and !GameState.moveUsed:
					toAdd.setOptionType("Move")
		
		if n > 0 and n < optionCount - 1:
			if prevPos == Vector2(0,0):
				prevPos = Vector2(0,-22)
			else:
				prevPos += Vector2(0,-21)
		elif n == optionCount - 1:
			if optionCount == 2:
				prevPos += Vector2(0,-1)
			prevPos += Vector2(0,-26)
		toAdd.position = prevPos

func hoverToggle():
	options[highlightedOption].highlight.visible = !options[highlightedOption].highlight.visible
	options[highlightedOption].hovered = !options[highlightedOption].hovered

func selectOption():
	hasSelectedOption = true
	options[highlightedOption].selectToggle()
	match options[highlightedOption].type:
		"Move":
			animation.play("SelectCloseMenu")
			await get_tree().create_timer(0.1).timeout
			GameState.moving = GameState.playerPiece
			TileHandler.show("Movement")
			queue_free()
		"Action":
			var toAdd = preload("res://UI/Menu/ActionMenu.tscn").instantiate()
			add_child(toAdd)
		"End":
			animation.play("SelectCloseMenu")
			await get_tree().create_timer(0.1).timeout
			GameState.endTurn()
			queue_free()
		"Items":
			var toAdd = preload("res://UI/Menu/ItemMenu.tscn").instantiate()
			add_child(toAdd)
