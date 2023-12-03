extends DamageEffect
class_name DanseErratiqueEffect

var base_damage : int

func _init(base_damage : int, source : Character, target : Character) :
	self.base_damage = base_damage
	super(base_damage, source, target, DamageType.DIRECT)

func apply() -> void :
	super.apply()
	if not target.has_status("feather") :
		GameManager.combat.add_effect(DanseErratiqueEffect.new(base_damage, source, target.get_allies()[GameManager.rng.randi_range(0, target.get_allies().size() - 1)]))
	is_done = true
