extends Effect
class_name DamageEffect

var damage : int
var multiplier : float

var source : Character
var target : Character

enum DamageType { DIRECT, INDIRECT }
var _damage_type : DamageType

func _init(damage : int, source : Character, target : Character, _damage_type : DamageType = DamageType.DIRECT) :
	self.damage = damage
	multiplier = 1
	self.source = source
	self.target = target
	self._damage_type = _damage_type

func apply() -> void :
	target.take_damage(source, damage * multiplier)
	is_done = true

func add_fixed_damage(amount : int, apply_if_indirect : bool = false) -> void :
	if not apply_if_indirect and _damage_type == DamageType.INDIRECT : return
	damage += amount

func add_damage_multiplier(mult : float, apply_if_indirect : bool = false) -> void :
	if not apply_if_indirect and _damage_type == DamageType.INDIRECT : return
	multiplier *= mult
