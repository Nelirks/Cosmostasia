extends Node

const t_background = preload("res://scenes/tutorial/tutorial_background.tscn")
const tutos:tutorial_tab = preload("res://scripts/data/tutorial_box/tutorials.tres")

@export var tutorial_datas: Array[tutorial_data]
var in_queue: Array[tutorial_data]

var current_scene: Node

var is_active:bool = false
var current_tutorial:tutorial_data = null

func _ready():
	for i in tutos.tab.size(): 
		tutorial_datas.append(tutos.tab[i])
		#J'ai pas trouvé mieux 
		#quand on tente de passer tutos.tab directement il veut pas car la variable est de type "res://scripts/tutorial.gd" au lieu de tutorial

func play_tutorial(tutorial:tutorial_data):
	var back = t_background.instantiate()
	back.init(tutorial)
	#scene.get_node("Foreground").add_child(back)
	get_tree().get_root().add_child(back)

func trigger_tutorial(tutorial_id:String):
	#current_scene = scene
	for data in tutorial_datas:
		if data.tutorial_name == tutorial_id and !data.used:
			data.used = true
			
			if is_active:
				in_queue.append(data)
			else:
				is_active = true
				play_tutorial(data)
				
func next():
	if in_queue.is_empty():
		is_active = false
	else:
		play_tutorial(in_queue.pop_front())

