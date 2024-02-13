extends CombatVFX

func set_context(source : CharacterCard3D, target : CharacterCard3D) -> void :
	global_position = target.global_position
