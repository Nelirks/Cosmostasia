extends CombatEvent
class_name StartTurnEvent

var player : Player

func _init(player : Player) :
	self.player = player
