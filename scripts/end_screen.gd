extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var is_defeat : bool = GameManager.player.get_characters().size() == 0
	var is_victory : bool = GameManager.opponent.get_characters().size() == 0
	if is_defeat and is_victory : ($Result as RichTextLabel).text = "DRAW"
	elif is_victory : ($Result as RichTextLabel).text = "VICTORY"
	elif is_defeat : ($Result as RichTextLabel).text = "DEFEAT"
