extends Node3D
const ENERGY_CHARGED = preload("res://resources/3d_asset/materials/energy_charged.tres")
const ENERGY_EMPTY = preload("res://resources/3d_asset/materials/energy_empty.tres")

@export var is_player:bool = false

@onready var b1:MeshInstance3D = $Barre1
@onready var b2:MeshInstance3D = $Barre2
@onready var b3:MeshInstance3D = $Barre3
@onready var b4:MeshInstance3D = $Barre4
@onready var b5:MeshInstance3D = $Barre5

var energy:int = 0

var energy_bar

func change_energy(energy_value:int):
	if energy >= energy_value:
		for i in range(4,-1,-1):
			_energy_switch(i,i < energy_value)
	else:
		for i in range(5):
			_energy_switch(i,i < energy_value)
			await get_tree().create_timer(0.2).timeout 
	energy = energy_value

func _energy_switch(mesh_to_switch:int, state:bool):
	if state:
		energy_bar[mesh_to_switch].set_surface_override_material(0,ENERGY_CHARGED)
	else:
		energy_bar[mesh_to_switch].set_surface_override_material(0,ENERGY_EMPTY)
		
func _ready():
	energy_bar = [b1,b2,b3,b4,b5] 
	if is_player:
		pass
		#GameManager.player.energy_updated.connect(change_energy)
	else:
		pass
		#GameManager.opponnent.energy_updated.connect(change_energy)
	await get_tree().create_timer(5).timeout
	#GameManager.player.current_energy = 5
	change_energy(5)
	
	


