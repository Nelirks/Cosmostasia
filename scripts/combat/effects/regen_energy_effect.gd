extends Effect
class_name RegenEnergyEffect

var source : Character
var target : Player
var amount : int
var immediate : bool

func _init(amount : int, immediate : bool, source : Character, target : Player) :
	self.amount = amount
	self.immediate = immediate
	self.source = source
	self.target = target

func apply() -> void :
	if immediate : target.current_energy += amount
	else : target.energy_regen += amount
	is_done = true
