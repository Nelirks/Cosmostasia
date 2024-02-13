extends Node3D
const ENERGY_CHARGED = preload("res://resources/3d_asset/materials/energy_charged.tres")
const ENERGY_EMPTY = preload("res://resources/3d_asset/materials/energy_empty.tres")

@export var is_player:bool = false

@onready var b1:MeshInstance3D = $Barre1
@onready var b2:MeshInstance3D = $Barre2
@onready var b3:MeshInstance3D = $Barre3
@onready var b4:MeshInstance3D = $Barre4
@onready var b5:MeshInstance3D = $Barre5

@onready var update_timer : Timer = $EnergyUpdateTimer

var curr_energy : int = 0
var target_energy : int = 0
var energy_bar

var updating:bool = false

func change_energy(energy_value:int):
	update_timer.stop()
	target_energy = energy_value
	_update_display()

func _update_display() -> void :
	if curr_energy == target_energy : return
	
	if curr_energy < target_energy : 
		curr_energy += 1
		_energy_switch(curr_energy - 1, true)
	else : 
		_energy_switch(curr_energy - 1, false)
		curr_energy -= 1
	update_timer.start()

func _energy_switch(mesh_to_switch:int, state:bool):
	if state:
		energy_bar[mesh_to_switch].set_surface_override_material(0,ENERGY_CHARGED)
	else:
		energy_bar[mesh_to_switch].set_surface_override_material(0,ENERGY_EMPTY)
		
func _ready():
	energy_bar = [b1,b2,b3,b4,b5] 
	if is_player:
		change_energy(GameManager.player.current_energy)
		GameManager.player.energy_updated.connect(change_energy)
	else:
		change_energy(GameManager.opponent.current_energy)
		GameManager.opponent.energy_updated.connect(change_energy)
