extends Control

func _ready():
	# Cambiar automáticamente al menú de banderas (versión por código)
	#get_tree().change_scene_to_file("res://scenes/menu_simple.tscn")
	get_tree().change_scene_to_file("res://scenes/ingresar_nombres.tscn")
