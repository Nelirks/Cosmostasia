extends Node3D

@onready var player_character_displays : Array[CharacterCard3D] = [%PlayerCharacter1, %PlayerCharacter2, %PlayerCharacter3]
@onready var opponent_character_displays : Array[CharacterCard3D] = [%OpponentCharacter1, %OpponentCharacter2, %OpponentCharacter3]

var player_card_displays : Array[PlayableCard3D] = []
var opponent_card_displays : Array[PlayableCard3D] = []

@onready var ally_card_positions : Array[Marker3D] = [%AllyDeck, %AllyCard1, %AllyCard2, %AllyCard3]
@onready var opponent_card_positions : Array[Marker3D] = [%OpponentDeck, %OpponentCard1, %OpponentCard2, %OpponentCard3]

func _ready():
	if GameManager.player != null:
		on_player_set()
	GameManager.player_set.connect(on_player_set)
	
# Called when the node enters the scene tree for the first time.
func on_player_set():
	for i in range(3) :
		player_character_displays[i].character = GameManager.player.get_character(i)
		opponent_character_displays[i].character = GameManager.opponent.get_character(i)
		

	for player_card in GameManager.player.get_all_cards() :
		var card_display : PlayableCard3D = preload("res://scenes/card_display/playable_card_3d.tscn").instantiate()
		add_child(card_display)
		card_display.card = player_card
		player_card_displays.append(card_display)
		set_card_display_position(card_display, true)
		card_display.card.position_set.connect(set_card_display_position.bind(card_display, true))


func set_card_display_position(card_display : PlayableCard3D, is_player : bool) -> void :
	card_display.visible = card_display.card.position < (ally_card_positions if is_player else opponent_card_positions).size()
	card_display.global_position = (ally_card_positions if is_player else opponent_card_positions)[card_display.card.position].global_position
	print(card_display.visible)
	print(card_display.global_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
