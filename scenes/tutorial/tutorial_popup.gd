extends PanelContainer
@onready var text_tutoriel = $TextTutoriel

func init(text:String,pos:Vector2):
	$TextTutoriel.add_text(text)
	#self.position = pos


func _on_button_pressed():
	get_parent().queue_free()
