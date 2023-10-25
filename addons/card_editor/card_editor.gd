@tool
extends EditorPlugin

const _main_panel : PackedScene = preload("res://addons/card_editor/main_screen.tscn")

var _main_panel_instance : Control

func _enter_tree() -> void:
	_main_panel_instance = _main_panel.instantiate()
	get_editor_interface().get_editor_main_screen().add_child(_main_panel_instance)
	_make_visible(false)
	pass


func _exit_tree() -> void:
	if _main_panel_instance :
		_main_panel_instance.queue_free()

func _has_main_screen() -> bool:
	return true

func _make_visible(visible: bool) -> void:
	if _main_panel_instance :
		_main_panel_instance.visible = visible

func _get_plugin_name() -> String:
	return "Card Editor"

func _get_plugin_icon() -> Texture2D:
	return get_editor_interface().get_base_control().get_theme_icon("Node", "EditorIcons")
