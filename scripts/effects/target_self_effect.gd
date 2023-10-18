extends Effect
class_name TargetSelfEffect

@export var effect : Effect

func apply() -> void :
	GameManager.combat.add_effect_immediate(effect, source, source)
	is_done = true
