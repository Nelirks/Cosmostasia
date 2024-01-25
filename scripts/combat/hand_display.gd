extends Node
class_name HandDisplay

signal card_selected(card : Card)

@export var is_player : bool

@onready var card_positions : Array[Marker3D] = [$DrawPile, $PreparedCard, $MiddleCard, $MiracleCard, $DiscardPile]

var player : Player :
	get:
		return GameManager.player if is_player else GameManager.opponent
	set(value) :
		printerr("Cannot set value to player property in hand_display")

var cards : Array[PlayableCard3D]

var _selected_card : PlayableCard3D = null :
	set(value) : 
		_selected_card = value
		if _selected_card != null : 
			card_selected.emit(_selected_card.card)

func _ready():
	if player.get_all_cards().size() > 0 :
		_instantiate_cards()
	else :
		player.deck_ready.connect(_instantiate_cards)

func _instantiate_cards() :
	for card in player.get_all_cards() :
		print(str(NetworkManager.is_host) + card.card_name)
		var card_display = preload("res://scenes/card_display/playable_card_3d.tscn").instantiate()
		add_child(card_display)
		cards.append(card_display)
		card_display.card = card
		_connect_signals(card_display)
		card_display.position = card_positions[card.position].position

func _connect_signals(card_display : PlayableCard3D) -> void :
	card_display.mouse_clicked.connect(_on_card_clicked.bind(card_display))
	card_display.mouse_entered.connect(_on_card_mouse_entered.bind(card_display))
	card_display.mouse_exited.connect(_on_card_mouse_exited.bind(card_display))
	card_display.card.position_changed.connect(_on_card_position_changed.bind(card_display))

func _on_card_clicked(card_display : PlayableCard3D) -> void :
	_selected_card = card_display

func _on_card_mouse_entered(card_display : PlayableCard3D) -> void : 
	pass
	
func _on_card_mouse_exited(card_display : PlayableCard3D) -> void : 
	pass

func _on_card_position_changed(card_display : PlayableCard3D) -> void :
	var tween = create_tween()
	tween.tween_property(card_display, "position", card_positions[card_display.card.position].position, 0.5)

func get_selected_card_index() -> int : 
	if _selected_card == null : return -1
	return _selected_card.card.position - 1

func deselect_card() -> void :
	_selected_card = null
