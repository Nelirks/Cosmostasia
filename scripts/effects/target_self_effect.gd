extends Effect
class_name TargetSelfEffect

@export var effects : Array[Effect]

func _init() -> void :
	print(effects.size())

func apply() -> void :
	for effect in effects :
		effect.source = source
		effect.target = source
	
	for effect in effects :
		effect.apply()
		if !effect.is_done :
			await effect.done
	is_done = true
