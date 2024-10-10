extends enemyExtension

func determine_targets():
	for n in range(FloorData.floor.enemies.size()):
		var currentEnemy = FloorData.floor.enemies[n]
		for m in range(currentEnemy.enemyType.possibleBehaviors.size()):
			var currentBehavior = currentEnemy.enemyType.possibleBehaviors[m]
			match currentBehavior:
				pass

func change_target(enemyNum : int):
	pass
