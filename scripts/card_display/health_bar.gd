extends Node
class_name HealthBar

@onready var base_health_fill_width : float = %HealthFill.size.x
@onready var base_armor_fill_width : float = %ArmorFill.size.x

func display_full(health : int, max_health : int, armor : int) -> void :
	%HealthFill.size.x = base_health_fill_width * float(health) / float(max_health)
	%ArmorFill.size.x = base_armor_fill_width * float(armor) / float(max_health)
	%Label.text = str(health) + " / " + str(max_health) + (" (" + str(armor) + ")" if armor > 0 else "")

func display_max_health(max_health : int) : 
	%HealthFill.size.x = base_health_fill_width
	%ArmorFill.size.x = base_armor_fill_width
	%Label.text = str(max_health)
