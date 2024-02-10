extends Effect
class_name ApplyArmorEffect

var amount : int
var source : Character
var target : Character

func _init(amount : int, source : Character, target : Character) :
	self.amount  = amount
	self.source = source
	self.target = target

func apply() -> void :
	target.apply_armor(amount)
	target.play_overlay(preload("res://vfx/selected_character_shine/shield_fx.tscn").instantiate())
	is_done = true
