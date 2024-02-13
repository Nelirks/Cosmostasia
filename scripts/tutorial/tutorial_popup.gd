extends PanelContainer
@onready var text_tutoriel = $TextTutoriel

func init(text:String):
	$TextTutoriel.add_text(text)


func _on_button_pressed():
	TutorialGlobal.next()
	get_parent().queue_free()
