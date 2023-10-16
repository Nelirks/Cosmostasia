extends Effect
class_name TargetTeamEffect

@export var effects : Array[Effect]

func apply() -> void :
	for effect in effects :
		effect.source = source
		for ally in target.get_allies() :
			if ally.is_dead : continue
			effect.target = ally
			effect.is_done = false
			effect.apply()
			if !effect.is_done :
				await effect.done
	is_done = true
