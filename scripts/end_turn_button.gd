extends TextureButton
class_name EndTurnButton

@export var active_turn_button_texture : Texture
@export var inactive_turn_button_texture : Texture

func _ready():
	GameManager.combat.turn_set.connect(on_turn_start)
	on_turn_start()

func on_turn_start() -> void :
	var player_turn : bool = GameManager.combat.is_player_turn()
	texture_normal = active_turn_button_texture if player_turn else inactive_turn_button_texture
	($Label as Label).text = "Tour suivant" if player_turn else "Tour adverse"
	disabled = !player_turn
