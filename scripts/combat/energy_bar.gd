extends TextureRect

@export var is_player:bool = false

@export var energy_textures : Array[Texture]

@onready var update_timer : Timer = $EnergyUpdateTimer

var curr_energy : int = 0
var target_energy : int = 0

func change_energy(energy_value:int):
	update_timer.stop()
	target_energy = energy_value
	_update_display()

func _update_display() -> void :
	if curr_energy == target_energy : return
	
	if curr_energy < target_energy : 
		curr_energy += 1
		texture = energy_textures[curr_energy]
	else : 
		curr_energy -= 1
		texture = energy_textures[curr_energy]
	update_timer.start()
		
func _ready():
	if is_player:
		change_energy(GameManager.player.current_energy)
		GameManager.player.energy_updated.connect(change_energy)
	else:
		change_energy(GameManager.opponent.current_energy)
		GameManager.opponent.energy_updated.connect(change_energy)
