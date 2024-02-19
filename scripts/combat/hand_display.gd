extends Node
class_name HandDisplay

signal card_selected(card : Card)
signal request_vfx(vfx : CombatVFX, source : Character, target : Character)

@export var is_player : bool

@export var card_move_duration : float
@export var card_zoom_in_delay : float
@export var card_zoom_in_duration : float
@export var card_zoom_out_duration : float

@export var dissolve_duration : float

@onready var card_positions : Array[Marker3D] = [$DrawPile, $PreparedCard, $MiddleCard, $MiracleCard, $DrawPile]

@export var selected_card_fx : PackedScene

var info_popup : InfoPopup :
	set(value) :
		if info_popup != null : info_popup.queue_free()
		info_popup = value
		if info_popup != null : $InfoPopupContainer.add_child(info_popup)

var player : Player :
	get:
		return GameManager.player if is_player else GameManager.opponent
	set(value) :
		printerr("Cannot set value to player property in hand_display")

var cards : Dictionary

var selected_card : PlayableCard3D = null :
	set(value) : 
		if selected_card != null :
			selected_card.overlay = null
		selected_card = value
		if selected_card != null : 
			selected_card.overlay = selected_card_fx.instantiate()
			card_selected.emit(selected_card.card)
		card_selected.emit(selected_card.card if selected_card != null else null)

var hovered_card : PlayableCard3D = null
var last_played_card : Card

@export var played_card_visibility_duration : float

func _ready():
	for card in player.get_all_cards() : 
		_register_card(card)
	player.card_created.connect(_register_card)
	player.card_destroyed.connect(_destroy_card)
	player.draw_pile_top_updated.connect(_draw_pile_top_updated)

func _register_card(card : Card) -> void :
	cards[card] = null
	card.position_changed.connect(_on_card_position_changed.bind(card))
	card.card_played.connect(_on_card_played.bind(card))
	
	if card.is_in_hand or card == player.get_draw_pile_top_card() :
		_create_card_display(card)
		_update_card_position(card, true)

func _destroy_card(card : Card) :
	if last_played_card == card : last_played_card = null
	if cards[card] != null : _destroy_card_display(card)
	await get_tree().create_timer(dissolve_duration + 0.1).timeout
	cards.erase(card)

func _create_card_display(card : Card) -> void :
	cards[card] = preload("res://scenes/card_display/playable_card_3d.tscn").instantiate()
	add_child(cards[card])
	cards[card].card = card
	
func _destroy_card_display(card : Card, immediate : bool = false) -> void :
	if card == null or !cards.has(card) or cards[card] == null : return
	if immediate : 
		if cards[card].tween : cards[card].tween.kill()
		cards[card].queue_free()
		cards[card] = null
	else :
		cards[card].position.z -= 0.01
		cards[card].dissolve(dissolve_duration)
		await get_tree().create_timer(dissolve_duration).timeout
		_destroy_card_display(card, true)

func _connect_mouse_signals(card_display : PlayableCard3D) -> void :
	if card_display.mouse_clicked.is_connected(_on_card_clicked) : return
	card_display.mouse_clicked.connect(_on_card_clicked.bind(card_display))
	card_display.mouse_entered.connect(_on_card_mouse_entered.bind(card_display))
	card_display.mouse_exited.connect(_on_card_mouse_exited.bind(card_display))

func _disconnect_mouse_signals(card_display : PlayableCard3D) -> void :
	if !card_display.mouse_clicked.is_connected(_on_card_clicked) : return
	card_display.mouse_clicked.disconnect(_on_card_clicked)
	card_display.mouse_entered.disconnect(_on_card_mouse_entered)
	card_display.mouse_exited.disconnect(_on_card_mouse_exited)

func _on_card_clicked(card_display : PlayableCard3D) -> void :
	selected_card = card_display

func _on_card_mouse_entered(card_display : PlayableCard3D) -> void :
	hovered_card = card_display
	if card_display.tween : card_display.tween.kill()
	card_display.tween = create_tween()
	card_display.tween.tween_interval(card_zoom_in_delay)
	card_display.tween.tween_property(hovered_card, "position", Vector3(card_positions[card_display.card.position].position.x, 5.5, 0.5), card_zoom_in_duration)
	card_display.tween.parallel().tween_property(hovered_card, "scale", Vector3(2.1, 2.1, 2.1), card_zoom_in_duration)
	if is_player : card_display.tween.tween_callback(_display_info_popup)
	if !is_player and card_display.card.revealed :
		card_display.tween.parallel().tween_method(card_display.set_z_rotation, card_display.rotation.z, PI, card_zoom_in_duration)

func _on_card_mouse_exited(card_display : PlayableCard3D) -> void : 
	if hovered_card == null : return
	info_popup = null
	if card_display.tween : card_display.tween.kill()
	card_display.tween = create_tween()
	card_display.tween.tween_property(hovered_card, "position", Vector3(card_positions[card_display.card.position].position.x, 0, 0), card_zoom_out_duration)
	card_display.tween.parallel().tween_property(hovered_card, "scale", Vector3.ONE, card_zoom_out_duration)
	if !is_player and card_display.card.revealed :
		card_display.tween.parallel().tween_method(card_display.set_z_rotation, card_display.rotation.z, 0, card_zoom_in_duration)
	hovered_card = null

func _on_card_position_changed(card : Card, immediate : bool = false) -> void :
	if !card.is_in_hand and card != player.get_draw_pile_top_card() and card != last_played_card :
		if cards[card] != null : _destroy_card_display(card)
		return
	if cards[card] == null : 
		_create_card_display(card)
		_update_card_position(card, true)
	else :
		_update_card_position(card, immediate)

func _update_card_position(card : Card, immediate : bool) -> void :
	var card_display = cards[card]
	if card == last_played_card : return
	
	if immediate : 
		card_display.position = card_positions[card_display.card.position].position
		card_display.scale = card_positions[card_display.card.position].scale
		if card_display.card.is_in_hand : _connect_mouse_signals(card_display)
		else : _disconnect_mouse_signals(card_display)
	else : 
		_disconnect_mouse_signals(card_display)
		if card_display.tween : 
			card_display.tween.kill()
		card_display.tween = create_tween()
		card_display.tween.tween_property(card_display, "position", card_positions[card_display.card.position].position, card_move_duration)
		card_display.tween.parallel().tween_property(card_display, "scale", card_positions[card_display.card.position].scale, card_move_duration)
		if card_display.card.is_in_hand : card_display.tween.tween_callback(_connect_mouse_signals.bind(card_display))
	
	if is_player :
		card_display.flip(!card_display.card.is_in_hand, 0 if immediate else card_move_duration)
	else :
		card_display.flip(!card_display.card.is_in_hand or !card_display.card.revealed, 0)

func _on_card_played(card : Card) -> void :
	if cards[card] == null :
		return
	var card_display = cards[card]
	if card_display.tween : 
		card_display.tween.kill()
	if last_played_card != null and cards[last_played_card] != null: 
		_destroy_card_display(last_played_card)
	last_played_card = card
	_disconnect_mouse_signals(card_display)
	card_display.tween = create_tween()
	card_display.tween.tween_property(card_display, "position", $PlayedCard.position, card_move_duration)
	card_display.tween.parallel().tween_property(card_display, "scale", $PlayedCard.scale, card_move_duration)
	if !is_player : 
		card_display.tween.parallel().tween_method(card_display.set_z_rotation, card_display.rotation.z, PI, card_move_duration)
		card_display.tween.parallel().tween_method(card_display.set_y_rotation, card_display.rotation.y, 0, card_move_duration)
	card_display.tween.tween_interval(played_card_visibility_duration)
	card_display.tween.tween_callback(_destroy_card_display.bind(card))

func _draw_pile_top_updated() -> void : 
	if !player.get_draw_pile_top_card() : return
	if cards[player.get_draw_pile_top_card()] == null : 
		_create_card_display(player.get_draw_pile_top_card())
		_update_card_position(player.get_draw_pile_top_card(), true)

func deselect_card() -> void :
	selected_card = null

func _display_info_popup():
	info_popup = preload("res://scenes/info_popup/info_popup.tscn").instantiate()
	info_popup.add_string(hovered_card.card.description, false)
	info_popup.set_target_rect(hovered_card.get_rect())

func on_card_vfx_request(vfx : CombatVFX, source : Character, target : Character) -> void :
	request_vfx.emit(vfx, source, target)
