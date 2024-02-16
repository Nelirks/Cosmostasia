extends PanelContainer
@onready var text_tutoriel = $TextTutoriel

@export var text_data = ""

func init(text:String):
	text_data = text
	$TextTutoriel.add_text(text)


#func _on_button_pressed():
#	TutorialGlobal.next()
#	get_parent().queue_free()
