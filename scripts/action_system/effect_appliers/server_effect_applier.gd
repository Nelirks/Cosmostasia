extends EffectApplier
class_name ServerEffectApplier

func apply_effect(effect : Effect) -> void :
	effect.apply()
	if multiplayer.has_multiplayer_peer() :
		ActionManager.apply_effect_from_str.rpc(var_to_str(effect))
