extends EffectApplier
class_name ServerEffectApplier

func apply_effect(effect : Effect) -> void :
	effect.apply()
	ActionManager.apply_effect_from_str.rpc(var_to_str(effect))
