extends Effect
class_name TargetTeamEffect

@export var effect : Effect

func apply() -> void :
	var targets = target.get_allies()
	for index in range(targets.size()-1, -1, -1) :
		GameManager.combat.add_effect_immediate(effect.duplicate(true), source, targets[index])
	is_done = true
