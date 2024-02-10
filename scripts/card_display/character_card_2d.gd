extends Control
class_name CharacterCard2D

@export var death_fx : PackedScene
@export var is_combat_display : bool = true :
	set(value) : 
		is_combat_display = value
		if character != null : 
			on_character_hp_changed()

var overlay : OverlayVFX :
	set(value) :
		if overlay != null : overlay.queue_free()
		overlay = value
		if overlay != null :
			add_child(overlay)
			overlay.size = size
			overlay.position = Vector2.ZERO


var character : Character :
	set(value) :
		if character != null : 
			disconnect_signals()
		character = value
		visible = character != null
		if character != null :
			(%CharacterSprite as TextureRect).texture = character.character_texture
			(%CharacterName as Label).text = character.character_name
			if is_combat_display and character.passive != null : _on_status_added(character.passive)
			connect_signals()

var status_displays : Dictionary

func connect_signals() -> void :
	character.hp_changed.connect(on_character_hp_changed)
	character.armor_changed.connect(on_character_hp_changed)
	character.status_added.connect(_on_status_added)
	character.status_removed.connect(_on_status_removed)
	on_character_hp_changed()

func disconnect_signals() -> void :
	character.hp_changed.disconnect(on_character_hp_changed)
	character.armor_changed.disconnect(on_character_hp_changed)
	character.status_added.disconnect(_on_status_added)
	character.status_removed.disconnect(_on_status_removed)

func on_character_hp_changed() -> void :
	if is_combat_display :
		%HealthBar.display_full(maxi(character.current_health, 0), character.max_health, character._armor)
		if character.current_health <= 0 : overlay = death_fx.instantiate()
	else : 
		%HealthBar.display_max_health(character.max_health)

func _on_status_added(status : StatusEffect) -> void :
	status_displays[status] = null
	_on_status_updated(status)
	status.status_updated.connect(_on_status_updated.bind(status))

func _on_status_updated(status : StatusEffect) -> void :
	if status.get_texture() != null :
		if status_displays[status] == null : 
			status_displays[status] = preload("res://scenes/card_display/status_effect_display.tscn").instantiate()
			%StatusEffectDisplays.add_child(status_displays[status])
		status_displays[status].update_texture(status.get_texture())
		if status is StackableStatusEffect :
			status_displays[status].update_amount(status.stacks)
	else :
		if status_displays[status] != null :
			status_displays[status].queue_free()

func _on_status_removed(status : StatusEffect) -> void :
	if status_displays[status] != null :
		status_displays[status].queue_free()
	status.status_updated.disconnect(_on_status_updated)
	status_displays.erase(status)
