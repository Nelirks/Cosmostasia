extends Effect
class_name ApplyStatusEffect

@export var status : StatusEffect

func apply() -> void :
	target.apply_status(status)
	is_done = true
