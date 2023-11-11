extends Effect
class_name ConditionalEffect

var condition : GameCondition
var effects : Array[Effect]
var fallback_effects : Array[Effect]

func _init(condition : GameCondition, effects : Array[Effect], fallback_effects : Array[Effect] = []) -> void:
	self.condition = condition
	self.effects = effects
	self.fallback_effects = fallback_effects

func apply() -> void :
	if condition.is_met() :
		GameManager.combat.add_effects_immediate(effects)
	else : 
		GameManager.combat.add_effects_immediate(fallback_effects)
	is_done = true
