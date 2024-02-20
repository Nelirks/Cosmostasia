extends Node3D

@onready var player_hand : HandDisplay = %PlayerHand
@onready var opponent_hand : HandDisplay = %OpponentHand

func _ready():
	AudioManager.post_event(AK.EVENTS.START_COMBATMUSIC)
	GameManager.combat.combat_end.connect(_on_combat_end)
	%FadeInTexture.visible = true
	var fade_in_tween : Tween = create_tween()
	var fade_in_base_modulate = %FadeInTexture.self_modulate
	fade_in_tween.tween_property(%FadeInTexture, "self_modulate", Color(fade_in_base_modulate.r, fade_in_base_modulate.g, fade_in_base_modulate.b, 0), 1)
	fade_in_tween.tween_callback(%FadeInTexture.queue_free)

func _on_character_clicked(is_host : bool, index : int) -> void :
	if player_hand.selected_card == null : return
	if !player_hand.selected_card.card.can_target(GameManager.get_player(is_host).get_character(index)) : return
	if player_hand.selected_card.card.position == Card.Position.DISCARD_PILE :
		printerr("ATTEMPT TO PLAY " + player_hand.selected_card.card.card_name + " FROM DISCARD")
		return
	GameManager.combat.query_card_play(NetworkManager.is_host, player_hand.selected_card.card.position - 1, is_host, index)
	player_hand.deselect_card()

func _on_targetless_play_area_clicked() -> void :
	if player_hand.selected_card == null : return
	if !player_hand.selected_card.card.can_target(null) : return
	if player_hand.selected_card.card.position == Card.Position.DISCARD_PILE :
		printerr("ATTEMPT TO PLAY " + player_hand.selected_card.card.card_name + " FROM DISCARD")
		return
	GameManager.combat.query_card_play(NetworkManager.is_host, player_hand.selected_card.card.position - 1, true, -1)
	player_hand.deselect_card()

func _unhandled_input(event):
	var mouse_event = event as InputEventMouseButton
	if mouse_event == null or !mouse_event.pressed: return
	if  mouse_event.button_index == MOUSE_BUTTON_RIGHT :
		($PlayerHand as HandDisplay).deselect_card()

func _on_end_turn_button_pressed():
	AudioManager.post_event(AK.EVENTS.END_TURN)
	GameManager.combat.query_end_turn()

func play_vfx(vfx_scene : PackedScene, source : CharacterCard3D, target : CharacterCard3D) -> void :
	var vfx : CombatVFX = vfx_scene.instantiate()
	add_child(vfx)
	vfx.set_context(source, target)

func _on_combat_end() -> void : 
	recursive_queue_free(self)
	GameManager.set_game_state.call_deferred(GameManager.GameState.GAME_END)

func recursive_queue_free(node : Node) -> void :
	for child in node.get_children() :
		node.remove_child(child)
		recursive_queue_free(child)
	node.queue_free()
