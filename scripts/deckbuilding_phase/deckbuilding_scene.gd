extends Node

@export var unselected_card_fx : PackedScene

var host_presets : Array = []
var client_presets : Array = []

var info_popup_scene : PackedScene = preload("res://scenes/info_popup/info_popup.tscn")
var info_popup : InfoPopup :
	set(value) :
		if info_popup != null :
			info_popup.queue_free()
		info_popup = value
		if info_popup != null :
			%Foreground.add_child(info_popup)

var player_character_selectors : Array[CharacterSelector]
var opponent_character_selectors : Array[CharacterSelector]
var preset_selectors : Array[PresetSelector]
var character_display : CharacterCard3D
var card_displays : Array[PlayableCard3D]
var card_amount_displays : Array[Label]

var selected_character_index : int :
	set(value) : 
		selected_character_index = value
		character_display.character = selected_character
		for i in range(3) : 
			player_character_selectors[i].set_active(selected_character_index == i)
			preset_selectors[i].set_text(selected_character.deck_presets[i].preset_name)
			preset_selectors[i].selected = selected_presets[selected_character_index] == i
		for i in range(5) : 
			card_displays[i].card = selected_character.card_pool[i]
		update_card_counts()
		if selected_character_index == 2 : state = DeckbuildingState.READY

@export var card_zoom_position_offset : Vector3
@export var card_zoom_scale : Vector3
@export var card_zoom_in_delay : float
@export var card_zoom_in_duration : float
@export var card_zoom_out_duration : float
var card_base_positions : Array[Vector3]
var card_base_scales : Array[Vector3]

var selected_character : Character :
	set(value) :
		printerr("Cannot directly set character")
	get :
		return GameManager.player.get_character(selected_character_index)

var selected_presets : Array[int] = [0, 0, 0]

enum DeckbuildingState { BROWSING, READY, SUBMITTED}
var state : DeckbuildingState :
	set(value) :
		state = value
		match state :
			DeckbuildingState.BROWSING :
				%SubmitButton.enable(true)
				%SubmitButton.set_text("Suivant")
			DeckbuildingState.READY :
				%SubmitButton.enable(true)
				%SubmitButton.set_text("Jouer")
			DeckbuildingState.SUBMITTED :
				%SubmitButton.enable(false)
				%SubmitButton.set_text("En attente")
				for selector in preset_selectors :
					selector.disabled = true

@rpc("any_peer", "call_remote", "reliable")
func notify_preset_choice(presets : Array) -> void : 
	if multiplayer.get_remote_sender_id() == 0 :
		host_presets = presets
		if !NetworkManager.is_multiplayer :
			client_presets = [0, 0, 0]
	else :
		client_presets = presets
	if host_presets.size() > 0 and client_presets.size() > 0 :
		apply_presets.rpc(host_presets, client_presets)

@rpc("authority", "call_local", "reliable")
func apply_presets(host_presets : Array, client_presets : Array) -> void :
	var host : Player = GameManager.get_player(true)
	for char_index in host.get_characters().size() :
		host.get_character(char_index).use_preset(host_presets[char_index])
	
	var client : Player = GameManager.get_player(false)
	for char_index in client.get_characters().size() :
		client.get_character(char_index).use_preset(client_presets[char_index])
		
	GameManager.set_game_state(GameManager.GameState.COMBAT)

func _ready():
	player_character_selectors.append_array(%PlayerCharacterSelector.get_children())
	opponent_character_selectors.append_array(%OpponentCharacterSelector.get_children())
	preset_selectors.append_array(%PresetSelector.get_children())
	character_display = %CharacterDisplay
	card_displays.append_array(%CardArea.get_children())
	card_amount_displays.append_array(%CardCounts.get_children())
	
	selected_character_index = 0
	for i in range(3) :
		player_character_selectors[i].set_text(GameManager.player.get_character(i).character_name)
		opponent_character_selectors[i].set_text(GameManager.opponent.get_character(i).character_name)
	for i in range(5) :
		card_base_positions.append(card_displays[i].position)
		card_base_scales.append(card_displays[i].scale)
		card_displays[i].mouse_entered.connect(on_playable_card_mouse_entered.bind(i))
		card_displays[i].mouse_exited.connect(on_playable_card_mouse_exited.bind(i))
		
	TutorialGlobal.trigger_tutorial("6_cardselect")
	TutorialGlobal.trigger_tutorial("2_cardeffect")
	TutorialGlobal.trigger_tutorial("3_cardtype")

func on_ally_character_selected(char_index : int) -> void :
	AudioManager.post_event(AK.EVENTS.DRAFT_VALIDATE_BUTTON)
	selected_character_index = char_index

func on_opponent_character_hovered(char_index : int) -> void :
	info_popup = info_popup_scene.instantiate()
	info_popup.add_string(GameManager.opponent.get_character(char_index).character_quote)
	info_popup.set_target_rect(opponent_character_selectors[char_index].get_global_rect())

func on_character_card_hovered() -> void :
	info_popup = info_popup_scene.instantiate()
	info_popup.add_string(character_display.character.passive.description)
	info_popup.set_target_rect(character_display.get_rect())
	AudioManager.post_event(AK.EVENTS.DRAFT_HOVER_CARD)

func on_playable_card_mouse_entered(card_index : int) -> void :
	if card_displays[card_index].tween != null : card_displays[card_index].tween.kill()
	card_displays[card_index].tween = create_tween()
	card_displays[card_index].tween.tween_interval(card_zoom_in_delay)
	card_displays[card_index].tween.tween_property(card_displays[card_index], "position", card_base_positions[card_index] + card_zoom_position_offset, card_zoom_in_duration)
	card_displays[card_index].tween.parallel().tween_property(card_displays[card_index], "scale", card_zoom_scale, card_zoom_in_duration)
	card_displays[card_index].tween.tween_callback(display_card_info_popup.bind(card_index))
	AudioManager.post_event(AK.EVENTS.DRAFT_HOVER_CARD)

func on_playable_card_mouse_exited(card_index : int) -> void :
	close_info_popup()
	if card_displays[card_index].tween != null : card_displays[card_index].tween.kill()
	card_displays[card_index].tween = create_tween()
	card_displays[card_index].tween.tween_property(card_displays[card_index], "position", card_base_positions[card_index], card_zoom_out_duration)
	card_displays[card_index].tween.parallel().tween_property(card_displays[card_index], "scale", card_base_scales[card_index], card_zoom_out_duration)

func display_card_info_popup(card_index : int) -> void :
	info_popup = info_popup_scene.instantiate()
	info_popup.add_string(card_displays[card_index].card.description, false)
	info_popup.set_target_rect(card_displays[card_index].get_rect())

func close_info_popup() -> void :
	info_popup = null

func on_preset_selected(preset_index : int) -> void :
	selected_presets[selected_character_index] = preset_index
	for i in range(3) :
		preset_selectors[i].selected = preset_index == i
	update_card_counts()
	AudioManager.post_event(AK.EVENTS.DRAFT_CLICK_CARD)

func update_card_counts() -> void :
	for i in range(5) : 
		var amount = selected_character.deck_presets[selected_presets[selected_character_index]].content[i]
		card_displays[i].overlay = unselected_card_fx.instantiate() if amount == 0 else null
		card_displays[i].use_text_color(amount != 0)
		card_amount_displays[i].text = str(amount)


func _on_submit_button_pressed():
	AudioManager.post_event(AK.EVENTS.DRAFT_VALIDATE_BUTTON)
	match state :
		DeckbuildingState.BROWSING : 
			selected_character_index += 1
			return
		DeckbuildingState.READY :
			if NetworkManager.is_host : 
				notify_preset_choice(selected_presets)
			else :
				notify_preset_choice.rpc(selected_presets)
			state = DeckbuildingState.SUBMITTED
			return
