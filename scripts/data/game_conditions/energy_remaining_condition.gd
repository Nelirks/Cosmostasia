extends GameCondition
class_name EnergyRemainingCondition

var player : Player
var threshold : int

func _init(player : Player, threshold : int) :
	self.player = player
	self.threshold = threshold

func is_met() -> bool :
	return player.current_energy >= threshold
