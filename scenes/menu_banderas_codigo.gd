extends Control

const TAMANO_ICONO = 20
# Escena del juego principal
const EscenaJuego = preload("res://scenes/juego.tscn")

# Referencias a los nodos
var dropdown_jugador1: OptionButton
var dropdown_jugador2: OptionButton
var seleccion_jugador1: TextureRect
var seleccion_jugador2: TextureRect
var texto_seleccion1: Label
var texto_seleccion2: Label
var boton_jugar: Button
var boton_salir: Button

# Variables para las selecciones
var bandera_seleccionada_jugador1: String = ""
var bandera_seleccionada_jugador2: String = ""

# Lista de banderas disponibles
var banderas = [
	"Argentina.png",
	"Canada.png",
	"Chile.png",
	"Colombia.png",
	"EEUU.png",
	"España.png",
	"Alemania.png",
	"Italia.png",
	"Reino Unido.png",
	"Suecia.png"
]

func _ready():
	print("Creando menú de banderas por código...")
	_crear_interfaz()
	print("Menú de banderas creado correctamente")
	print("--- Probando la Base de Datos ---")
	
	# Comprobar si la base de datos ya tiene jugadores
	# CAMBIO: Usamos el nuevo nombre de la función -> obtener_jugadores()
	#var jugadores_existentes = DatabaseManager.obtener_jugadores()
	
	#if jugadores_existentes.is_empty():
		#print("Base de datos de jugadores vacía. Añadiendo datos de ejemplo.")
		# CAMBIO: Usamos el nuevo nombre -> agregar_jugador() y solo pasamos el nombre
		#DatabaseManager.agregar_jugador("Chris")
		#DatabaseManager.agregar_jugador("Ama")
	
	# CAMBIO: Usamos el nuevo nombre de la función -> obtener_jugadores()
	#var todos_los_jugadores = DatabaseManager.obtener_jugadores()
	#print("Jugadores guardados: ", todos_los_jugadores)
	#print("---------------------------------")

func _crear_interfaz():
	# Configurar el nodo principal
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	
	# Crear fondo
	var fondo = TextureRect.new()
	fondo.name = "Fondo"
	fondo.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	fondo.texture = load("res://assets/bg-beach-flags.png")
	fondo.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	add_child(fondo)
	
	# Estilo para fondos vidriados (semi-transparentes)
	var estilo_panel = StyleBoxFlat.new()
	estilo_panel.bg_color = Color(0, 0, 0, 0.5)
	estilo_panel.content_margin_left = 10
	estilo_panel.content_margin_right = 10
	estilo_panel.content_margin_top = 3
	estilo_panel.content_margin_bottom = 3
	estilo_panel.corner_radius_top_left = 8
	estilo_panel.corner_radius_top_right = 8
	estilo_panel.corner_radius_bottom_left = 8
	estilo_panel.corner_radius_bottom_right = 8
	
	# Crear título con fondo vidriado
	var panel_titulo = PanelContainer.new()
	panel_titulo.name = "PanelTitulo"
	panel_titulo.add_theme_stylebox_override("panel", estilo_panel)
	panel_titulo.position = Vector2(get_viewport().size.x/2 - 200, 150)
	#panel_titulo.size = Vector2(400, 70)
	add_child(panel_titulo)
	
	# Crear título
	var titulo = Label.new()
	titulo.name = "Titulo"
	titulo.text = "SELECCIONA TU BANDERA"
	titulo.add_theme_font_size_override("font_size", 25)
	titulo.add_theme_color_override("font_color", Color.WHITE)
	titulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	titulo.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	#titulo.position = Vector2(get_viewport().size.x/2 - 200, 120)
	#titulo.size = Vector2(400, 70)
	#add_child(titulo)
	panel_titulo.add_child(titulo)
	
	# Labels de jugadores con fondos vidriados
	var panel_jugador1_label = PanelContainer.new()
	panel_jugador1_label.name = "PanelJugador1Label"
	panel_jugador1_label.add_theme_stylebox_override("panel", estilo_panel)
	panel_jugador1_label.position = Vector2(get_viewport().size.x/2 - 260, 200)
	#panel_jugador1_label.size = Vector2(200, 50)
	add_child(panel_jugador1_label)
	
	# Labels de jugadores
	var jugador1_label = Label.new()
	jugador1_label.name = "Jugador1Label"
	#jugador1_label.text = "JUGADOR 1"
	jugador1_label.text = GameData.nombre_jugador1.to_upper()
	jugador1_label.add_theme_font_size_override("font_size", 20)
	jugador1_label.add_theme_color_override("font_color", Color.WHITE)
	jugador1_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	#jugador1_label.position = Vector2(get_viewport().size.x/2 - 300, 180)
	#jugador1_label.size = Vector2(200, 50)
	#add_child(jugador1_label)
	panel_jugador1_label.add_child(jugador1_label)
	
	var panel_jugador2_label = PanelContainer.new()
	panel_jugador2_label.name = "PanelJugador2Label"
	panel_jugador2_label.add_theme_stylebox_override("panel", estilo_panel)
	panel_jugador2_label.position = Vector2(get_viewport().size.x/2 + 60, 200)
	#panel_jugador2_label.size = Vector2(200, 50)
	add_child(panel_jugador2_label)
	
	var jugador2_label = Label.new()
	jugador2_label.name = "Jugador2Label"
	#jugador2_label.text = "JUGADOR 2"
	jugador2_label.text = GameData.nombre_jugador2.to_upper()
	jugador2_label.add_theme_font_size_override("font_size", 20)
	jugador2_label.add_theme_color_override("font_color", Color.WHITE)
	jugador2_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	#jugador2_label.position = Vector2(get_viewport().size.x/2 + 100, 180)
	#jugador2_label.size = Vector2(200, 50)
	#add_child(jugador2_label)
	panel_jugador2_label.add_child(jugador2_label)
	
	# Dropdowns de banderas
	dropdown_jugador1 = OptionButton.new()
	dropdown_jugador1.name = "DropdownJugador1"
	dropdown_jugador1.add_theme_font_size_override("font_size", 16)
	dropdown_jugador1.position = Vector2(get_viewport().size.x/2 - 300, 250)
	dropdown_jugador1.size = Vector2(200, 40)
	dropdown_jugador1.selected = -1
	add_child(dropdown_jugador1)
	
	dropdown_jugador2 = OptionButton.new()
	dropdown_jugador2.name = "DropdownJugador2"
	dropdown_jugador2.add_theme_font_size_override("font_size", 16)
	dropdown_jugador2.position = Vector2(get_viewport().size.x/2 + 20, 250)
	dropdown_jugador2.size = Vector2(200, 40)
	dropdown_jugador2.selected = -1
	add_child(dropdown_jugador2)
	
	# Áreas de selección
	seleccion_jugador1 = TextureRect.new()
	seleccion_jugador1.name = "SeleccionJugador1"
	seleccion_jugador1.expand_mode = TextureRect.EXPAND_FIT_WIDTH
	seleccion_jugador1.position = Vector2(get_viewport().size.x/2 - 270, 290)
	seleccion_jugador1.size = Vector2(120, 120)
	add_child(seleccion_jugador1)
	
	seleccion_jugador2 = TextureRect.new()
	seleccion_jugador2.name = "SeleccionJugador2"
	seleccion_jugador2.expand_mode = TextureRect.EXPAND_FIT_WIDTH
	seleccion_jugador2.position = Vector2(get_viewport().size.x/2 + 60, 290)
	seleccion_jugador2.size = Vector2(120, 120)
	add_child(seleccion_jugador2)
	
	# Textos de selección con fondos vidriados
	var panel_texto_seleccion1 = PanelContainer.new()
	panel_texto_seleccion1.name = "PanelTextoSeleccion1"
	panel_texto_seleccion1.add_theme_stylebox_override("panel", estilo_panel)
	panel_texto_seleccion1.position = Vector2(get_viewport().size.x/2 - 290, 410)
	#panel_texto_seleccion1.size = Vector2(200, 30)
	add_child(panel_texto_seleccion1)
	
	# Textos de selección
	texto_seleccion1 = Label.new()
	texto_seleccion1.name = "TextoSeleccion1"
	texto_seleccion1.text = "Selecciona una bandera"
	texto_seleccion1.add_theme_font_size_override("font_size", 14)
	texto_seleccion1.add_theme_color_override("font_color", Color.WHITE)
	texto_seleccion1.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	#texto_seleccion1.position = Vector2(get_viewport().size.x/2 - 300, 410)
	#texto_seleccion1.size = Vector2(200, 30)
	#add_child(texto_seleccion1)
	panel_texto_seleccion1.add_child(texto_seleccion1)
	
	var panel_texto_seleccion2 = PanelContainer.new()
	panel_texto_seleccion2.name = "PanelTextoSeleccion2"
	panel_texto_seleccion2.add_theme_stylebox_override("panel", estilo_panel)
	panel_texto_seleccion2.position = Vector2(get_viewport().size.x/2 + 30, 410)
	add_child(panel_texto_seleccion2)
	
	texto_seleccion2 = Label.new()
	texto_seleccion2.name = "TextoSeleccion2"
	texto_seleccion2.text = "Selecciona una bandera"
	texto_seleccion2.add_theme_font_size_override("font_size", 14)
	texto_seleccion2.add_theme_color_override("font_color", Color.WHITE)
	texto_seleccion2.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	#texto_seleccion2.position = Vector2(get_viewport().size.x/2 + 20, 410)
	#texto_seleccion2.size = Vector2(200, 30)
	#add_child(texto_seleccion2)
	panel_texto_seleccion2.add_child(texto_seleccion2)
	
	# Botones
	boton_jugar = Button.new()
	boton_jugar.name = "BotonJugar"
	boton_jugar.text = "¡JUGAR!"
	boton_jugar.add_theme_font_size_override("font_size", 24)
	boton_jugar.position = Vector2(get_viewport().size.x/2 - 100, get_viewport().size.y - 100)
	boton_jugar.size = Vector2(200, 40)
	boton_jugar.disabled = true
	boton_jugar.pressed.connect(_on_boton_jugar_pressed)
	add_child(boton_jugar)
	
	boton_salir = Button.new()
	boton_salir.name = "BotonSalir"
	boton_salir.text = "SALIR"
	boton_salir.add_theme_font_size_override("font_size", 18)
	boton_salir.position = Vector2(get_viewport().size.x/2 - 100, get_viewport().size.y - 50)
	boton_salir.size = Vector2(200, 30)
	boton_salir.pressed.connect(_on_boton_salir_pressed)
	add_child(boton_salir)
	
	# Poblar los dropdowns con las banderas
	_poblar_dropdowns()

func _poblar_dropdowns():
	print("Poblando dropdowns con banderas...")
	
	# Agregar opción inicial
	dropdown_jugador1.add_item("Seleccionar país...")
	dropdown_jugador2.add_item("Seleccionar país...")
	
	# Agregar las banderas a ambos dropdowns
	for bandera_archivo in banderas:
		var textura_original = load("res://assets/" + bandera_archivo)
		var imagen = textura_original.get_image()
		imagen.resize(TAMANO_ICONO, TAMANO_ICONO)
		var icono_pequeno = ImageTexture.create_from_image(imagen)
		var nombre_pais = bandera_archivo.replace(".png", "")
		#var icono_bandera = load("res://assets/" + bandera_archivo)
		
		dropdown_jugador1.add_icon_item(icono_pequeno, nombre_pais)
		dropdown_jugador2.add_icon_item(icono_pequeno, nombre_pais)
		
		#dropdown_jugador1.add_item(nombre_pais)
		#dropdown_jugador2.add_item(nombre_pais)
	
	# Conectar las señales de selección
	dropdown_jugador1.item_selected.connect(_on_dropdown_jugador1_selected)
	dropdown_jugador2.item_selected.connect(_on_dropdown_jugador2_selected)
	
	print("Dropdowns poblados correctamente")

func _actualizar_estado_dropdowns():
	for i in range(dropdown_jugador1.item_count):
		dropdown_jugador1.set_item_disabled(i, false)
		dropdown_jugador2.set_item_disabled(i, false)
	
	var seleccion_j1 = dropdown_jugador1.selected
	var seleccion_j2 = dropdown_jugador2.selected
	
	if seleccion_j1 > 0:
		dropdown_jugador2.set_item_disabled(seleccion_j1, true)
	
	if seleccion_j2 > 0:
		dropdown_jugador1.set_item_disabled(seleccion_j2, true)

func _on_dropdown_jugador1_selected(index: int):
	if index == 0:  # "Seleccionar país..."
		bandera_seleccionada_jugador1 = ""
		seleccion_jugador1.texture = null
		texto_seleccion1.text = "Selecciona una bandera"
	else:
		var bandera_archivo = banderas[index - 1]  # -1 porque el primer item es "Seleccionar país..."
		bandera_seleccionada_jugador1 = bandera_archivo
		seleccion_jugador1.texture = load("res://assets/" + bandera_archivo)
		texto_seleccion1.text = "Bandera seleccionada"
		
	_actualizar_estado_dropdowns()
	_verificar_selecciones()
		
		# Verificar que el jugador 2 no haya seleccionado la misma bandera
		#if bandera_seleccionada_jugador2 == bandera_archivo:
		#	print("Bandera ya seleccionada por jugador 2")
		#	dropdown_jugador1.selected = 0  # Resetear a "Seleccionar país..."
		#	return
		
		#bandera_seleccionada_jugador1 = bandera_archivo
		#seleccion_jugador1.texture = load("res://assets/" + bandera_archivo)
		#texto_seleccion1.text = "Bandera seleccionada"
		#print("Jugador 1 seleccionó: ", bandera_archivo)
	
	#_verificar_selecciones()

func _on_dropdown_jugador2_selected(index: int):
	if index == 0:  # "Seleccionar país..."
		bandera_seleccionada_jugador2 = ""
		seleccion_jugador2.texture = null
		texto_seleccion2.text = "Selecciona una bandera"
	else:
		var bandera_archivo = banderas[index - 1]  # -1 porque el primer item es "Seleccionar país..."
		
		# Verificar que el jugador 1 no haya seleccionado la misma bandera
		#if bandera_seleccionada_jugador1 == bandera_archivo:
		#	print("Bandera ya seleccionada por jugador 1")
		#	dropdown_jugador2.selected = 0  # Resetear a "Seleccionar país..."
		#	return
		
		bandera_seleccionada_jugador2 = bandera_archivo
		seleccion_jugador2.texture = load("res://assets/" + bandera_archivo)
		texto_seleccion2.text = "Bandera seleccionada"
		print("Jugador 2 seleccionó: ", bandera_archivo)
	_actualizar_estado_dropdowns()
	_verificar_selecciones()

func _verificar_selecciones():
	if bandera_seleccionada_jugador1 != "" and bandera_seleccionada_jugador2 != "":
		boton_jugar.disabled = false
		boton_jugar.add_theme_color_override("font_color", Color.GREEN)
		print("Ambos jugadores han seleccionado banderas - habilitando botón de jugar")
	else:
		boton_jugar.disabled = true
		boton_jugar.add_theme_color_override("font_color", Color.WHITE)

func _on_boton_jugar_pressed():
	print("Iniciando juego con banderas: ", bandera_seleccionada_jugador1, " y ", bandera_seleccionada_jugador2)
	
	# Guardar las banderas en el singleton
	GameData.set_banderas(bandera_seleccionada_jugador1, bandera_seleccionada_jugador2)
	
	# Cambiar a la escena del juego
	get_tree().change_scene_to_file("res://scenes/juego.tscn")

func _on_boton_salir_pressed():
	print("Saliendo del juego...")
	get_tree().quit()
