extends StackableStatusEffect

@export var base_max_feathers : int
@export var additional_feather_cd : float

var max_feathers : int
var cur_additional_feather_cd : int

var feather_status : StackableStatusEffect = preload("res://resources/game_data/status_effect_data/feather_status.tres")

func on_apply() :
	stacks = base_max_feathers
	cur_additional_feather_cd = additional_feather_cd

func on_effect_resolution(effect : Effect) -> void :
	if effect is DamageEffect and effect.source == owner and effect.target.player != owner.player :
		GameManager.combat.add_effect_immediate(ApplyStatusEffect.new(feather_status.duplicate().set_stacks(1), owner, effect.target))
	if effect is StartTurnNotifierEffect and effect.player == owner.player :
		cur_additional_feather_cd -= 1
		if cur_additional_feather_cd <= 0 :
			stacks += 1
			cur_additional_feather_cd = additional_feather_cd
