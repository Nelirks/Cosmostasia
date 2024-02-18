extends Effect
class_name DamageEffect

var damage : int
var multiplier : float

var source : Character
var target : Character

enum DamageType { DIRECT, INDIRECT }
var _damage_type : DamageType
var single_target : bool

func _init(damage : int, source : Character, target : Character, _damage_type : DamageType = DamageType.DIRECT, single_target : bool = true) :
	self.damage = damage
	multiplier = 1
	self.source = source
	self.target = target
	self._damage_type = _damage_type
	self.single_target = single_target

func apply() -> void :
	target.take_damage(source, damage * multiplier, _damage_type == DamageType.DIRECT)
	if _damage_type == DamageType.DIRECT and damage * multiplier > 0 : 
		source.play_combat_vfx(preload("res://scenes/vfx_chloe/vfx explosion.tscn"), target)
		if single_target : source.play_combat_vfx(preload("res://scenes/vfx_chloe/vfx_single_target_slash.tscn"), target)
	is_done = true

func add_fixed_damage(amount : int, apply_if_indirect : bool = false) -> void :
	if not apply_if_indirect and _damage_type == DamageType.INDIRECT : return
	damage += amount

func add_damage_multiplier(mult : float, apply_if_indirect : bool = false) -> void :
	if not apply_if_indirect and _damage_type == DamageType.INDIRECT : return
	multiplier *= mult
