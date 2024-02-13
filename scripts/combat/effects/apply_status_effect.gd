extends Effect
class_name ApplyStatusEffect

var status : StatusEffect
var source : Character
var target : Character

func _init(status : StatusEffect, source : Character, target : Character) :
	self.status = status
	self.source = source
	self.target = target

func apply() -> void :
	TutorialGlobal.trigger_tutorial("8_status")
	status.apply(target)
	is_done = true
