extends Node
class_name InfoBox

var text : String :
	set(value) : 
		%Label.text = value
	get :
		return %Label.text
