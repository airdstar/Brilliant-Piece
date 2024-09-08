extends Node

var HUD

func displayInfo():
	if $StaticHUD/SubViewport/Portrait.get_child_count() == 2:
		$StaticHUD/SubViewport/Portrait.remove_child($StaticHUD/SubViewport/Portrait.get_child(1))
	if GameState.highlightedTile.contains:
		$StaticHUD/Portrait.visible = true
		$StaticHUD/Status.visible = true
		var portraitPic = highlightedTile.contains.duplicate()
		$StaticHUD/SubViewport/Portrait.add_child(portraitPic)
		portraitPic.global_position = $StaticHUD/SubViewport/Portrait.global_position
		portraitPic.global_rotation.y = deg_to_rad(-90)
		if portraitPic is PlayerPiece:
			$StaticHUD/SubViewport/Portrait/Camera3D/MeshInstance3D.mesh.material.set_albedo(Color(0.63,0.72,0.86))
		elif portraitPic is EnemyPiece:
			$StaticHUD/SubViewport/Portrait/Camera3D/MeshInstance3D.mesh.material.set_albedo(Color(0.86,0.63,0.72))
		$StaticHUD/PortraitBackground.texture = $StaticHUD/SubViewport.get_texture()
		$StaticHUD/PortraitBackground.visible = true
		if highlightedTile.contains is MoveablePiece:
			HUD.updateLabels()
	else:
		HUD.visible = false

func usedAction():
	#$StaticHUD/TurnHUD/ActionOutline/Action.modulate = Color(0.5,0.5,0.5)
	GameState.actionUsed = true

func usedMovement():
	#$StaticHUD/TurnHUD/MoveOutline/Move.modulate = Color(0.5,0.5,0.5)
	GameState.moveUsed = true
