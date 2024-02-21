extends CombatVFX

func set_context(source : CharacterCard3D, target : CharacterCard3D) : 
	global_position = target.global_position
	#$Slash1.rotation.x = source.position.signed_angle_to(target.position, Vector3(0, 0, 1))

func play() -> void :
	super.play()
	AudioManager.post_event(AK.EVENTS.CARD_SINGLE_HIT)
	
