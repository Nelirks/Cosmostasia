extends Node3D

@export var is_player_side : bool

func _ready():
	GameManager.combat.turn_set.connect(update_current_turn)
	update_current_turn()

func update_current_turn():
	if GameManager.combat.is_player_turn() == is_player_side :
		for particle_emitter in $FireBig.get_children() :
			particle_emitter.emitting = true
		for particle_emitter in $FireSmall.get_children() :
			particle_emitter.emitting = false
			($firelight as OmniLight3D).set_param(Light3D.Param.PARAM_ENERGY, 1.3)
			($firelight as OmniLight3D).set_param(Light3D.Param.PARAM_RANGE, 5)
			
	else :
		for particle_emitter in $FireBig.get_children() :
			particle_emitter.emitting = false
		for particle_emitter in $FireSmall.get_children() :
			particle_emitter.emitting = true
			($firelight as OmniLight3D).set_param(Light3D.Param.PARAM_ENERGY, 0.4)
			($firelight as OmniLight3D).set_param(Light3D.Param.PARAM_RANGE, 0.5)
	
