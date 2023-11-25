extends Effect
class_name DiscardCardEffect

var source : Character
var target : Player
var pattern : Array[bool]

func _init(pattern : Array[bool], source : Character, target : Player) :
	self.source = source
	self.target = target
	self.pattern = pattern

func apply() -> void :
	for i in range(pattern.size()) :
		if pattern[i] :
			target.discard_card(i)
	is_done = true
