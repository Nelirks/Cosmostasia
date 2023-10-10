extends Effect
class_name DamageEffect

@export var damage : int

func apply() -> void :
	target.current_health -= damage
	is_done = true
