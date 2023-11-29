extends Control

var selected_card : int

func _process(_delta: float) -> void:
	if GameManager.player == null : return
	($Console as RichTextLabel).text = "CURRENT TURN : " + ("PLAYER" if GameManager.combat.is_player_turn() else "OPPONENT") + "\n"
	($Console as RichTextLabel).text += "| "
	for i in range(3) :
		($Console as RichTextLabel).text += "%30s | " % GameManager.opponent.get_character(i).char_name
	($Console as RichTextLabel).text += "\n| "
	for i in range(3) :
		($Console as RichTextLabel).text += ("%18d" % GameManager.opponent.get_character(i).current_health) + ("(%d) /" %GameManager.opponent.get_character(i)._armor) + ("%10d" %GameManager.opponent.get_character(i).max_health) + " | "
	($Console as RichTextLabel).text += "\n\n| "
	for i in range(3) :
		($Console as RichTextLabel).text += "%30s | " % GameManager.player.get_character(i).char_name
	($Console as RichTextLabel).text += "\n| "
	for i in range(3) :
		($Console as RichTextLabel).text += ("%18d" % GameManager.player.get_character(i).current_health) + (" (%d) /" %GameManager.player.get_character(i)._armor)  + ("%10d" %GameManager.player.get_character(i).max_health) + " | "
	($Console as RichTextLabel).text += "\n\n| "
	for i in range(3) :
		($Console as RichTextLabel).text += "%30s | " % GameManager.player.get_card_in_hand(i).card_name
