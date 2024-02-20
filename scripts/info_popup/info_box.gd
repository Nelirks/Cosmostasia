extends Control
class_name InfoBox

var text : String :
	set(value) : 
		%Label.text = value
	get :
		return %Label.text

func get_height() -> int :
	return 32 + (%Label as RichTextLabel).get_content_height()
