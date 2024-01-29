extends Node
class_name CharacterContainer

@onready var player_characters : Array[CharacterCard3D]
@onready var opponent_characters : Array[CharacterCard3D]

signal character_clicked(is_host : bool, index : int)

func _ready():
	for i in range(3) :
		player_characters.append_array($PlayerCharacters.get_children())
		opponent_characters.append_array($OpponentCharacters.get_children())
		player_characters[i].character = GameManager.player.get_character(i)
		opponent_characters[i].character = GameManager.opponent.get_character(i)
		_connect_signals(player_characters[i])
		_connect_signals(opponent_characters[i])

func _connect_signals(character_display : CharacterCard3D) -> void :
	character_display.mouse_clicked.connect(_on_character_clicked.bind(character_display))
	character_display.mouse_entered.connect(_on_character_mouse_entered.bind(character_display))
	character_display.mouse_exited.connect(_on_character_mouse_exited.bind(character_display))

func _on_character_clicked(character_display : CharacterCard3D) -> void :
	var is_player : bool = player_characters.find(character_display) != -1
	character_clicked.emit(is_player == NetworkManager.is_host, (player_characters if is_player else opponent_characters).find(character_display))

func _on_character_mouse_entered(character_display : CharacterCard3D) -> void :
	pass
	
func _on_character_mouse_exited(character_display : CharacterCard3D) -> void :
	pass
