extends Node2D

var character: Character:
	set(value):
		if character != null:
			character.hp_changed.disconnect(update_health)
		character = value
		update_sprite()
		character.hp_changed.connect(update_health)

func update_health():
	(%Life_Background as ColorRect).set_size(Vector2(float(character.current_health) / float(character.max_health) * 150.0, 16))
	(%Life_Text as Label).text = str(character.current_health)

func update_sprite():
	(%Character_Sprite as TextureRect).texture = character.character_texture


