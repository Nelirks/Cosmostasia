extends Control
class_name CharacterCard2D

var character : Character :
	set(value) :
		character = value
		visible = character != null
		if character != null :
			(%CharacterSprite as TextureRect).texture = character.character_texture
			(%CharacterName as Label).text = character.character_name
			(%CharacterMaxHealth as Label).text = str(character.max_health)

func set_overlay(material : Material) -> void :
	%FXOverlay.material = material
	%FXOverlay.visible = material != null
