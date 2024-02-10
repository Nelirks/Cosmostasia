extends Effect
class_name HealEffect

var amount : int
var source : Character
var target : Character

func _init(amount : int, source : Character, target : Character) :
	self.amount  = amount
	self.source = source
	self.target = target

func apply() -> void :
	target.heal(amount)
	target.play_overlay(preload("res://vfx/selected_character_shine/heal_fx.tscn").instantiate())
	is_done = true
