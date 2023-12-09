extends StatusEffect

var applied : bool

@export var energy_gain : int

func start_turn() -> void :
	applied = false

func on_effect_resolution(effect : Effect) -> void :
	var card_effect : CardPlayNotifierEffect = effect as CardPlayNotifierEffect
	if not applied and card_effect != null and card_effect.card.character == owner and card_effect.card_position == 0 :
		applied = true
		_add_effect(RegenEnergyEffect.new(energy_gain, false, owner, owner.player))
