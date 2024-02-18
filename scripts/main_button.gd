extends TextureButton
class_name MainButton

func enable(state : bool) -> void :
	disabled = !state
	self_modulate = Color.WHITE if state else Color.DIM_GRAY

func set_text(str : String) -> void :
	$Label.text = str
