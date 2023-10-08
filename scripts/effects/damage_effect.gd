extends Effect
class_name DamageEffect

@export var damage : int

func apply(source : Character, target : Character) -> void :
	target.current_health -= damage
