extends Node
class_name HandDisplay

signal card_selected(card : Card)

@export var is_player : bool

@export var card_move_speed : float

@onready var card_positions : Array[Marker3D] = [$DrawPile, $PreparedCard, $MiddleCard, $MiracleCard, $DiscardPile]

var player : Player :
	get:
		return GameManager.player if is_player else GameManager.opponent
	set(value) :
		printerr("Cannot set value to player property in hand_display")

var cards : Dictionary

var selected_card : PlayableCard3D = null :
	set(value) : 
		selected_card = value
		if selected_card != null : 
			card_selected.emit(selected_card.card)

func _ready():
	for card in player.get_all_cards() : 
		_instantiate_card(card)
	player.card_created.connect(_instantiate_card)
	player.card_destroyed.connect(_destroy_card)
	player.draw_pile_top_updated.connect(_draw_pile_top_updated)

func _instantiate_card(card : Card) :
	var card_display = preload("res://scenes/card_display/playable_card_3d.tscn").instantiate()
	add_child(card_display)
	cards[card] = card_display
	card_display.card = card
	if !is_player : 
		card_display.flip(true, true)
	_connect_signals(card_display)
	_on_card_position_changed(card_display, true)

func _destroy_card(card : Card) :
	cards[card].queue_free()
	cards.erase(card)

func _connect_signals(card_display : PlayableCard3D) -> void :
	card_display.mouse_clicked.connect(_on_card_clicked.bind(card_display))
	card_display.mouse_entered.connect(_on_card_mouse_entered.bind(card_display))
	card_display.mouse_exited.connect(_on_card_mouse_exited.bind(card_display))
	card_display.card.position_changed.connect(_on_card_position_changed.bind(card_display))

func _on_card_clicked(card_display : PlayableCard3D) -> void :
	selected_card = card_display

func _on_card_mouse_entered(card_display : PlayableCard3D) -> void : 
	pass
	
func _on_card_mouse_exited(card_display : PlayableCard3D) -> void : 
	pass

func _on_card_position_changed(card_display : PlayableCard3D, immediate : bool = false) -> void :
	card_display.rotates_on_hover = card_display.card.is_in_hand
	if immediate : card_display.position = card_positions[card_display.card.position].position
	else :
		var tween = create_tween()
		tween.tween_property(card_display, "position", card_positions[card_display.card.position].position, card_move_speed)
	card_display.visible = card_display.card.is_in_hand or card_display.card == player.get_draw_pile_top_card()
	if is_player :
		card_display.flip(!card_display.card.is_in_hand, !card_display.card.is_in_hand and immediate)

func _draw_pile_top_updated() -> void : 
	cards[player.get_draw_pile_top_card()].visible = true

func deselect_card() -> void :
	selected_card = null
