extends Control
class_name CharacterCard2D

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
	%FXOverlay.material = material
	%FXOverlay.visible = material != null

func on_character_hp_changed() -> void :
	if display_current_hp :
		%HealthBar.size.x = %HealthBackground.size.x * clampf(float(character.current_health)/float(character.max_health), 0.0, 1.0)
		%HealthLabel.text = str(character.current_health) + " / " + str(character.max_health) + (" (" + str(character._armor) + ")" if character._armor > 0 else "")
		%ArmorBar.visible = character._armor > 0
		%ArmorBar.size.x = %HealthBackground.size.x * clampf(float(character._armor)/float(character.max_health), 0.0, 1.0)
	else : 
		%ArmorBar.visible = false
		%HealthLabel.text = str(character.max_health)
