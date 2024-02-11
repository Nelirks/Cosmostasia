extends Node

const t_background = preload("res://scenes/tutorial/tutorial_background.tscn")


@export var tutorial_datas: Array[tutorial_data]

var current_tutorial:tutorial_data = null
func _ready():
	tutorial_datas.append(preload("res://scripts/data/tutorial_box/0_welcome.tres"))

func play_tutorial(tutorial:tutorial_data,scene:Node, pos:Vector2):
	var back = t_background.instantiate()
	back.init(tutorial,pos)
	scene.get_node("Foreground").add_child(back)
	#get_tree().get_root().add_child(back)

func trigger_tutorial(tutorial_id:String,scene:Node, pos:Vector2):
	for data in tutorial_datas:
		if data.tutorial_name == tutorial_id and !data.used:
			data.used = true
			play_tutorial(data,scene, pos)
			

