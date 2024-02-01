extends Control
class_name CharacterCard2D

@export var death_material : Material
@export var display_current_hp : bool = true :
	set(value) : 
		display_current_hp = value
		if character != null : 
			on_character_hp_changed()

var character : Character :
	set(value) :
		if character != null : 
			disconnect_signals()
		character = value
		visible = character != null
		if character != null :
			(%CharacterSprite as TextureRect).texture = character.character_texture
			(%CharacterName as Label).text = character.character_name
			connect_signals()
			

func connect_signals() -> void :
	character.hp_changed.connect(on_character_hp_changed)
	character.armor_changed.connect(on_character_hp_changed)
	on_character_hp_changed()

func disconnect_signals() -> void :
	character.hp_changed.disconnect(on_character_hp_changed)
	character.armor_changed.disconnect(on_character_hp_changed)

func set_overlay(material : Material) -> void :
	if %FXOverlay.material == death_material : return
	%FXOverlay.material = material
	%FXOverlay.visible = material != null

func on_character_hp_changed() -> void :
	if display_current_hp :
		%HealthBar.display_full(maxi(character.current_health, 0), character.max_health, character._armor)
		set_overlay(death_material if character.current_health <= 0 else null)
	else : 
		%HealthBar.display_max_health(character.max_health)
