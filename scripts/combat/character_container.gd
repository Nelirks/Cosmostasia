extends Node
class_name CharacterContainer

signal request_vfx(vfx : PackedScene, source_position : Vector3, target_position : Vector3)

@onready var player_characters : Array[CharacterCard3D]
@onready var opponent_characters : Array[CharacterCard3D]

@export var player_character_targetable_fx : PackedScene
@export var opponent_character_targetable_fx : PackedScene

var info_popup : InfoPopup :
	set(value) :
		if info_popup != null : info_popup.queue_free()
		info_popup = value
		if info_popup != null : $InfoPopupContainer.add_child(info_popup)

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
	character_display.character.combat_vfx_request.connect(play_vfx.bind(character_display))

func _on_character_clicked(character_display : CharacterCard3D) -> void :
	var is_player : bool = player_characters.find(character_display) != -1
	character_clicked.emit(is_player == NetworkManager.is_host, (player_characters if is_player else opponent_characters).find(character_display))

func _on_character_mouse_entered(character_display : CharacterCard3D) -> void :
	info_popup = preload("res://scenes/info_popup/info_popup.tscn").instantiate()
	for status in character_display.character._statuses :
		if status.description != "" :
			info_popup.add_string(status.description)
	info_popup.set_target_rect(character_display.get_rect())
	
func _on_character_mouse_exited(character_display : CharacterCard3D) -> void :
	info_popup = null

func on_card_selected(card : Card) -> void :
	for player_character in player_characters :
		if card != null and (card.can_target(player_character.character) or card.targetting == Card.Targetting.NO_TARGET and card.character == player_character.character) :
			player_character.play_overlay(player_character_targetable_fx, self)
		else :
			player_character.stop_overlay(self)
			
	for opponent_character in opponent_characters :
		if card != null and card.can_target(opponent_character.character) :
			opponent_character.play_overlay(opponent_character_targetable_fx, self)
		else :
			opponent_character.stop_overlay(self)

func play_vfx(vfx_scene : PackedScene, target : Character, source : CharacterCard3D) :
	request_vfx.emit(vfx_scene, get_character_global_position(target), source.global_position)

func get_character_global_position(character : Character) -> Vector3 :
	if character == null : return Vector3.ZERO
	for player_char in player_characters :
		if player_char.character == character :
			return player_char.global_position
	for opponent_char in opponent_characters :
		if opponent_char.character == character :
			return opponent_char.global_position
	return Vector3.ZERO
