extends StatusEffect

@export var hp_threshold : int
@export var provoke_status : StatusEffect

var is_first_turn : bool = true
var active : bool = true

func on_effect_resolution(effect : Effect) -> void :
	if effect is CardPlayNotifierEffect :
		active = owner.current_health >= hp_threshold
		status_updated.emit()
		return
	if effect is StartTurnNotifierEffect :
		if effect.player != owner.player and !is_first_turn : return
		is_first_turn = false
		if active and !owner.has_status(provoke_status.id) :
			_add_effect(ApplyStatusEffect.new(provoke_status.duplicate().set_stacks(1), owner, owner))

func get_texture() -> Texture :
	if active : return icon
	else : return null
