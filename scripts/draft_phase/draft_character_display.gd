extends Control
class_name DraftCharacterDisplay

signal selected()

var info_popup_scene = preload("res://scenes/info_popup/info_popup.tscn")
var info_popup : InfoPopup = null

var character : Character :
	set(value) :
		character = value
		if character == null :
			visible = false
		else :
			visible = true
			(%CharacterSprite as TextureRect).texture = character.character_texture
			(%CharacterName as Label).text = character.character_name
			(%CharacterMaxHealth as Label).text = str(character.max_health)

var hovered : bool = false

func _ready():
	visible = false

var is_selected : bool :
	set(value) : 
		if character == null : return
		is_selected = value
		if is_selected : selected.emit()

func _on_gui_input(event):
	var mouse_click = event as InputEventMouseButton
	if mouse_click != null :
		if mouse_click.button_index == MOUSE_BUTTON_LEFT and mouse_click.pressed :
			is_selected = true

func _on_mouse_entered():
	if info_popup != null : info_popup.queue_free()
	if character == null : return
	info_popup = info_popup_scene.instantiate()
	get_tree().root.add_child(info_popup)
	info_popup.set_content([character.character_quote, character.passive.description if character.passive != null else "PASSIVE UNIMPLEMENTED"])
	info_popup.set_target_rect((%CharacterSprite as Control).get_global_rect())

func _on_mouse_exited():
	if info_popup != null : info_popup.queue_free()
	info_popup = null

func _exit_tree():
	if info_popup != null : info_popup.queue_free()
