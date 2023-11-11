extends RefCounted
class_name StatusEffect

var id : String
var decay_on_turn_start : bool
var expire_at_zero_stacks : bool
var stacks : int :
	set(value) :
		stacks = value
		if stacks == 0 and expire_at_zero_stacks :
			owner.remove_status(id)

var owner : Character

func _init() -> void :
	id = "default_status"
	decay_on_turn_start = false
	expire_at_zero_stacks = false
	
func decay() -> void :
	if decay_on_turn_start :
		stacks -= 1

func on_apply() -> void :
	print(id + " applied to " + owner.char_name)

func on_remove() -> void :
	print(id + " removed from " + owner.char_name)

func on_combat_event(event : CombatEvent) -> void :
	pass
