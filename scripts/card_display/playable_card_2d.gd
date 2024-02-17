extends Control
class_name PlayableCard2D

@export var borders : Array[Texture]

@export var texture_dissolve_material : ShaderMaterial
@export var text_dissolve_material : ShaderMaterial

var card: Card:
	set(value):
		if card != null : disconnect_signals()
		card = value
		if card != null : 
			update_card_infos()
			connect_signals()

var overlay : OverlayVFX :
	set(value) :
		if overlay != null : overlay.queue_free()
		overlay = value
		if overlay != null :
			add_child(overlay)
			overlay.size = size
			overlay.position = Vector2.ZERO

func connect_signals() -> void :
	card.cost_updated.connect(update_cost)

func disconnect_signals() -> void :
	card.cost_updated.disconnect(update_cost)

func update_cost() -> void : 
	%CardCost.text = str(card.cost)

func update_name() -> void :
	%CardName.text = card.card_name

func update_borders() -> void :
	%CardBorders.texture = borders[card.cardType]

func update_character_name() -> void :
	%CardCharacter.text = card.character.character_name

func update_flavor_text() -> void :
	%CardFlavorText.text = "[i]" + card.quote + "[/i]"

func update_description() -> void :
	%CardDescription.text = DescriptionHandler.develop_tags(card.description)

func update_texture() -> void :
	%CardSprite.texture = card.card_texture

func update_card_infos():
	update_cost()
	update_name()
	update_character_name()
	update_borders()
	update_flavor_text()
	update_description()
	update_texture()

func use_text_color(use : bool) -> void :
	if use : 
		%CardDescription.text = DescriptionHandler.develop_tags(card.description)
	else :
		%CardDescription.text = card.description.replace("!S!", "").replace("!K!", "")

func dissolve(duration : float) -> void :
	%TextureArea.material = texture_dissolve_material
	%TextArea.material = text_dissolve_material
	var dissolve_tween : Tween = create_tween()
	
	dissolve_tween.tween_method(set_dissolve_progress, 0.0, 1.0, duration)
	dissolve_tween.tween_interval(0.5)
	dissolve_tween.tween_callback(reset_dissolve)

func set_dissolve_progress(value : float) -> void :
	texture_dissolve_material.set_shader_parameter("Progress", value)
	text_dissolve_material.set_shader_parameter("Progress", value)

func reset_dissolve() -> void :
	%TextureArea.material = null
	%TextArea.material = null
	set_dissolve_progress(0)
