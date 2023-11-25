extends StackableStatusEffect
class_name ProvokeStatusEffect

func _init(stacks : int) :
	super("provoke", StatusType.POSITIVE, stacks)

func on_effect_resolution(effect : Effect) -> void :
	if effect is CardPlayNotifierEffect :
		if effect.card.character.player != owner.player and effect.card.targetting == Card.Targetting.OPPONENT :
			stacks -= 1

func _on_stacks_changed() -> void :
	if stacks <= 0 :
		owner.remove_status(self)
