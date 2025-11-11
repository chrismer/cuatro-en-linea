extends Control

# Referencias a los nodos de la escena
@onready var nombre_j1_input = $NombreJ1_Input
@onready var nombre_j2_input = $NombreJ2_Input
@onready var continuar_button = $ContinuarButton
@onready var ranking_grid = $PanelContainer/VBoxContainer/ScrollContainer/RankingGrid
var menuSimple = preload("res://scenes/menu_simple.tscn")

func _ready():
	# Conectamos la señal del botón a nuestra función
	continuar_button.pressed.connect(_on_continuar_pressed)
	actualizar_tabla_ranking()
	
func actualizar_tabla_ranking():
	# Borramos cualquier dato viejo
	for child in ranking_grid.get_children():
		child.queue_free()
	
	# Creamos las cabeceras
	ranking_grid.add_child(crear_label_cabecera("Jugador"))
	ranking_grid.add_child(crear_label_cabecera("País"))
	ranking_grid.add_child(crear_label_cabecera("Victorias"))
	
	# CAMBIO: Obtenemos los datos desde nuestro nuevo RankingManager
	var sorted_ranking = RankingManager.get_sorted_ranking()
	
	# Recorremos los datos y creamos una fila por cada entrada
	for fila in sorted_ranking:
		var nombre = fila["nombre"]
		var pais = fila["bandera"].replace(".png", "")
		var victorias = str(fila["victorias"])
		
		var label_nombre = crear_label_celda(nombre)
		var label_pais = crear_label_celda(pais)
		var label_victorias = crear_label_celda(victorias)
		
		label_victorias.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		
		ranking_grid.add_child(label_nombre)
		ranking_grid.add_child(label_pais)
		ranking_grid.add_child(label_victorias)

# NUEVO: Funciones de ayuda para crear las etiquetas (Labels)
func crear_label_cabecera(texto: String) -> Label:
	var label = Label.new()
	label.text = texto
	label.add_theme_font_size_override("font_size", 18)
	# NUEVO: Hacemos que la etiqueta se expanda horizontalmente
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return label

func crear_label_celda(texto: String) -> Label:
	var label = Label.new()
	label.text = texto
	label.add_theme_font_size_override("font_size", 16)
	# NUEVO: Hacemos que la etiqueta se expanda horizontalmente
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return label

func _on_continuar_pressed():
	# Obtenemos el texto de los campos de entrada
	var nombre1 = nombre_j1_input.text
	var nombre2 = nombre_j2_input.text
	
	# Si un jugador no escribe nada, le asignamos un nombre por defecto
	if nombre1.is_empty():
		nombre1 = "Jugador 1"
	if nombre2.is_empty():
		nombre2 = "Jugador 2"
		
	# Guardamos los nombres en nuestro singleton GameData
	GameData.set_nombres(nombre1, nombre2)
	#DatabaseManager.agregar_jugador(nombre1)
	#DatabaseManager.agregar_jugador(nombre2)
	
	# Cambiamos a la escena de selección de banderas
	#get_tree().change_scene_to_file("res://scenes/menu_simple.tscn")
	get_tree().change_scene_to_packed(menuSimple)
