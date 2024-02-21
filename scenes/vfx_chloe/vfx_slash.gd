extends CombatVFX

func set_context(source : CharacterCard3D, target : CharacterCard3D) : 
	rotation.z = 0 if source.character.player == GameManager.player else PI

func play() -> void :
	super.play()
	AudioManager.post_event(AK.EVENTS.CARD_MULTI_HIT)
