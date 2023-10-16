extends Effect
class_name ApplyArmorEffect

@export var amount : int

func apply() -> void :
	target.apply_armor(amount)
	is_done = true
