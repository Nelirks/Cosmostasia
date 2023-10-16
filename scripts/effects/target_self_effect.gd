extends Effect
class_name TargetSelfEffect

@export var effects : Array[Effect]

func apply() -> void :
	for effect in effects :
		effect.source = source
		effect.target = source
		effect.apply()
		if !effect.is_done :
			await effect.done
	is_done = true
