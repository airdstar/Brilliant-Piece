extends Menu
class_name BasicMenu

func addOptions():
	optionCount = 2
	var move = false
	var action = false
	if !FloorData.floor.Handlers.SH.moveUsed:
		optionCount += 1
		move = true
	if !FloorData.floor.Handlers.SH.actionUsed:
		optionCount += 1
		action = true
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
				if action:
					toAdd.setOptionType("Action")
				elif move:
					toAdd.setOptionType("Move")
				hoverToggle()
			1:
				if action and move:
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
			FloorData.floor.Handlers.SH.actingPiece = PlayerData.playerPiece
			FloorData.floor.Handlers.SH.moving = true
			FloorData.floor.Handlers.TH.show("Movement")
			queue_free()
		"Action":
			var toAdd = preload("res://UI/Menu/ActionMenu.tscn").instantiate()
			add_child(toAdd)
		"End":
			animation.play("SelectCloseMenu")
			await get_tree().create_timer(0.1).timeout
			FloorData.floor.Handlers.SH.endTurn()
			queue_free()
		"Items":
			var toAdd = preload("res://UI/Menu/ItemMenu.tscn").instantiate()
			add_child(toAdd)
