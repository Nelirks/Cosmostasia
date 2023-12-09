extends StatusEffect
class_name ExclusiveStatusEffect

func apply(target : Character) -> void :
	if !target.has_status(id) : super.apply(target)
