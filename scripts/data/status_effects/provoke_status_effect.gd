extends StackableStatusEffect
class_name ProvokeStatusEffect

func _init(stacks : int) :
	id = "provoke"
	self.stacks = stacks

func on_effect_resolution(effect : Effect) -> void :
	if effect is DamageEffect and owner.get_allies(false).find(effect.target) != -1 :
		effect.target = owner
		stacks -= 1
		if stacks <= 0 :
			owner.remove_status(id)
