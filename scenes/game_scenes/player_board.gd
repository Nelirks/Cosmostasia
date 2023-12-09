extends Control

var cards_display: Array[CardUI] = []

func _ready():
	if GameManager.player != null:
		on_player_set()
	GameManager.player_set.connect(on_player_set)
	
# Called when the node enters the scene tree for the first time.
func on_player_set():
	$"First Character".character = GameManager.player.get_character(0)
	$"Second Character".character = GameManager.player.get_character(1)
	$"Last Character".character = GameManager.player.get_character(2)
	
	
	for card in GameManager.player.get_all_cards() :
		var card_ui : CardUI = preload("res://scenes/game_scenes/cards_ui.tscn").instantiate()
		add_child(card_ui)
		card_ui.miracle_position = $"Miracle Card Position".position
		card_ui.middle_position = $"Middle Card Positon".position
		card_ui.prepared_position = $"Prepared Card Position".position
		card_ui.card = card
		cards_display.append(card_ui)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
