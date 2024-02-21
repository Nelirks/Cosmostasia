extends Node3D

@export var is_player : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.combat.combat_end.connect(_on_combat_end)

func _on_combat_end() -> void :
	if is_player and GameManager.player.get_characters().size() == 0 : visible = false
	if !is_player and GameManager.opponent.get_characters().size() == 0 : visible = false
