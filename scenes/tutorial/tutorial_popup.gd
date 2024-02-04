extends PanelContainer
@onready var text_tutoriel = $TextTutoriel

func init(text:String,pos:Vector2):
	$TextTutoriel.add_text(text)
	self.position = pos
