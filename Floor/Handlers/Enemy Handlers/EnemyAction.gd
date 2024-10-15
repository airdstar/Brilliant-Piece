extends enemyExtension

func get_possible_actions():
	var toReturn : Array
	for n in range(FloorData.floor.enemies.size()):
		toReturn.append([])
		for m in range(FloorData.floorInfo.enemies[n].actions.size()):
			toReturn[n].append(null)
			var actionHolder = FloorData.floorInfo.enemies[n].actions[m]
			var actionRange = actionHolder.getTiles(FloorData.floor.enemies[n].rc)
			if check_action(actionRange):
				toReturn[n] = []
				match actionHolder.type:
					"Damage":
						for o in range(actionRange.size()):
							if actionRange[o].contains:
								if actionRange[o].contains is PlayerPiece:
									toReturn[n][m].append(actionRange[o])
							elif actionRange[o].obstructed:
								if actionRange[o].hazard.destructable:
									toReturn[n][m].append(actionRange[o])
					"Healing":
						for o in range(actionRange.size()):
							if actionRange[o].contains:
								if actionRange[o].contains is EnemyPiece:
									toReturn[n][m].append(actionRange[o])
					"Defensive":
						for o in range(actionRange.size()):
							if actionRange[o].contains:
								if actionRange[o].contains is EnemyPiece:
									toReturn[n][m].append(actionRange[o])
					"Status":
						var isBuff : bool = false
						if actionHolder.status.statusType == "Buff":
							isBuff = true
						for o in range(actionRange.size()):
							if actionRange[o].contains:
								if isBuff:
									if actionRange[o].contains is EnemyPiece:
										toReturn[n][m].append(actionRange[o])
								else:
									if actionRange[o].contains is PlayerPiece:
										toReturn[n][m].append(actionRange[o])
	return toReturn

func check_action(actionRange : Array[tile]):
	for n in range(actionRange.size()):
		if actionRange[n].contains:
			return true
		if actionRange[n].obstructed and actionRange[n].hazard.destructable:
			return true
	return false
