extends StatusEffect

@export var damage : int

var background : Image = Image.load_from_file("res://resources/sprites/status_icons/Passiflisirmee.png")
var grey_elements : Image = Image.load_from_file("res://resources/sprites/status_icons/Passiflisirmeegris.PNG")
var miracle_icon : Image = Image.load_from_file("res://resources/sprites/status_icons/Passiflisirmee3.png")
var middle_icon : Image = Image.load_from_file("res://resources/sprites/status_icons/Passiflisirmee2 2.PNG")
var prepared_icon : Image = Image.load_from_file("res://resources/sprites/status_icons/Passiflisirmee1.png")

var cards_played : Array[bool]

func on_apply():
	cards_played = [false, false, false]

func on_effect_resolution(effect : Effect) -> void :
	if effect is CardPlayNotifierEffect and (effect as CardPlayNotifierEffect).card.character == owner : 
		cards_played[effect.card_position] = true
		if cards_played[0] and cards_played[1] and cards_played[2] :
			cards_played = [false, false, false]
			for target in owner.get_enemies() :
				_add_effect(DamageEffect.new(damage, owner, target))
		status_updated.emit()

func get_texture() -> Texture :
	var result : Image = Image.load_from_file("res://resources/sprites/status_icons/Passiflisirmee.png")
	var image_rect = Rect2(Vector2.ZERO, result.get_size())
	result.blend_rect(grey_elements, image_rect, Vector2.ZERO)
	if cards_played[0] : result.blend_rect(prepared_icon, image_rect, Vector2.ZERO)
	if cards_played[1] : result.blend_rect(middle_icon, image_rect, Vector2.ZERO)
	if cards_played[2] : result.blend_rect(miracle_icon, image_rect, Vector2.ZERO)
	
	return ImageTexture.create_from_image(result)
