extends CombatVFX

func set_context(source : CharacterCard3D, target : CharacterCard3D) : 
	global_position = target.global_position
	rotation.z = 0 if source.character.player == GameManager.player else PI
	$Slash1.rotation.x = source.position.signed_angle_to(target.position, Vector3(0, 0, 1))
