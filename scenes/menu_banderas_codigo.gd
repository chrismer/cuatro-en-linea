extends Control

# Escena del juego principal
const EscenaJuego = preload("res://scenes/juego.tscn")

# Referencias a los nodos
var banderas_jugador1: GridContainer
var banderas_jugador2: GridContainer
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
	"argentina_flags_flag_16969.png",
	"japan_flags_flag_17019.png",
	"russia_flags_flag_17058.png",
	"brazil_flags_flag_16979.png",
	"germany_flags_flag_17001.png",
	"italy_flags_flag_17018.png",
	"france_flags_flag_16999.png",
	"spain_flags_flag_17068.png"
]

func _ready():
	print("Creando menú de banderas por código...")
	_crear_interfaz()
	print("Menú de banderas creado correctamente")

func _crear_interfaz():
	# Configurar el nodo principal
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	
	# Crear fondo
	var fondo = TextureRect.new()
	fondo.name = "Fondo"
	fondo.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	fondo.texture = load("res://assets/fondoMenu.png")
	fondo.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	add_child(fondo)
	
	# Crear título
	var titulo = Label.new()
	titulo.name = "Titulo"
	titulo.text = "SELECCIONA TU BANDERA"
	titulo.add_theme_font_size_override("font_size", 36)
	titulo.add_theme_color_override("font_color", Color.WHITE)
	titulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	titulo.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	titulo.position = Vector2(get_viewport().size.x/2 - 200, 50)
	titulo.size = Vector2(400, 70)
	add_child(titulo)
	
	# Labels de jugadores
	var jugador1_label = Label.new()
	jugador1_label.name = "Jugador1Label"
	jugador1_label.text = "JUGADOR 1"
	jugador1_label.add_theme_font_size_override("font_size", 24)
	jugador1_label.add_theme_color_override("font_color", Color.WHITE)
	jugador1_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	jugador1_label.position = Vector2(get_viewport().size.x/2 - 375, 150)
	jugador1_label.size = Vector2(250, 50)
	add_child(jugador1_label)
	
	var jugador2_label = Label.new()
	jugador2_label.name = "Jugador2Label"
	jugador2_label.text = "JUGADOR 2"
	jugador2_label.add_theme_font_size_override("font_size", 24)
	jugador2_label.add_theme_color_override("font_color", Color.WHITE)
	jugador2_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	jugador2_label.position = Vector2(get_viewport().size.x/2 + 125, 150)
	jugador2_label.size = Vector2(250, 50)
	add_child(jugador2_label)

	# Contenedores de banderas
	banderas_jugador1 = GridContainer.new()
	banderas_jugador1.name = "BanderasJugador1"
	banderas_jugador1.columns = 3
	banderas_jugador1.add_theme_constant_override("h_separation", 5)
	banderas_jugador1.add_theme_constant_override("v_separation", 5)
	banderas_jugador1.position = Vector2(get_viewport().size.x/2 - 375, 220)
	banderas_jugador1.size = Vector2(180, 150)
	add_child(banderas_jugador1)

	banderas_jugador2 = GridContainer.new()
	banderas_jugador2.name = "BanderasJugador2"
	banderas_jugador2.columns = 3
	banderas_jugador2.add_theme_constant_override("h_separation", 5)
	banderas_jugador2.add_theme_constant_override("v_separation", 5)
	banderas_jugador2.position = Vector2(get_viewport().size.x/2 + 125, 220)
	banderas_jugador2.size = Vector2(180, 150)
	add_child(banderas_jugador2)
	
	# Áreas de selección
	seleccion_jugador1 = TextureRect.new()
	seleccion_jugador1.name = "SeleccionJugador1"
	seleccion_jugador1.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	seleccion_jugador1.position = Vector2(get_viewport().size.x/2 - 375, 450)
	seleccion_jugador1.size = Vector2(250, 100)
	add_child(seleccion_jugador1)
	
	seleccion_jugador2 = TextureRect.new()
	seleccion_jugador2.name = "SeleccionJugador2"
	seleccion_jugador2.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	seleccion_jugador2.position = Vector2(get_viewport().size.x/2 + 125, 450)
	seleccion_jugador2.size = Vector2(250, 100)
	add_child(seleccion_jugador2)
	
	# Textos de selección
	texto_seleccion1 = Label.new()
	texto_seleccion1.name = "TextoSeleccion1"
	texto_seleccion1.text = "Selecciona una bandera"
	texto_seleccion1.add_theme_font_size_override("font_size", 16)
	texto_seleccion1.add_theme_color_override("font_color", Color.WHITE)
	texto_seleccion1.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	texto_seleccion1.position = Vector2(get_viewport().size.x/2 - 375, 560)
	texto_seleccion1.size = Vector2(250, 30)
	add_child(texto_seleccion1)
	
	texto_seleccion2 = Label.new()
	texto_seleccion2.name = "TextoSeleccion2"
	texto_seleccion2.text = "Selecciona una bandera"
	texto_seleccion2.add_theme_font_size_override("font_size", 16)
	texto_seleccion2.add_theme_color_override("font_color", Color.WHITE)
	texto_seleccion2.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	texto_seleccion2.position = Vector2(get_viewport().size.x/2 + 125, 560)
	texto_seleccion2.size = Vector2(250, 30)
	add_child(texto_seleccion2)
	
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
	
	# Crear las banderas
	_crear_banderas_jugador(banderas_jugador1, 1)
	_crear_banderas_jugador(banderas_jugador2, 2)

func _crear_banderas_jugador(contenedor: GridContainer, jugador: int):
	print("Creando banderas para jugador ", jugador)
	
	for i in range(banderas.size()):
		var bandera = TextureButton.new()
		bandera.custom_minimum_size = Vector2(50, 40)
		
		# Cargar la textura de la bandera
		var textura = load("res://assets/" + banderas[i])
		bandera.texture_normal = textura
		
		# Conectar el clic
		bandera.pressed.connect(_on_bandera_seleccionada.bind(banderas[i], jugador))

		contenedor.add_child(bandera)
	
	print("Banderas creadas para jugador ", jugador)

func _on_bandera_seleccionada(nombre_bandera: String, jugador: int):
	print("Bandera seleccionada: ", nombre_bandera, " por jugador ", jugador)

	if jugador == 1:
		if bandera_seleccionada_jugador1 == nombre_bandera:
			bandera_seleccionada_jugador1 = ""
			seleccion_jugador1.texture = null
			texto_seleccion1.text = "Selecciona una bandera"
		else:
			if bandera_seleccionada_jugador2 == nombre_bandera:
				print("Bandera ya seleccionada por jugador 2")
				return

			bandera_seleccionada_jugador1 = nombre_bandera
			seleccion_jugador1.texture = load("res://assets/" + nombre_bandera)
			texto_seleccion1.text = "Bandera seleccionada"
	else:
		if bandera_seleccionada_jugador2 == nombre_bandera:
			bandera_seleccionada_jugador2 = ""
			seleccion_jugador2.texture = null
			texto_seleccion2.text = "Selecciona una bandera"
		else:
			if bandera_seleccionada_jugador1 == nombre_bandera:
				print("Bandera ya seleccionada por jugador 1")
				return

			bandera_seleccionada_jugador2 = nombre_bandera
			seleccion_jugador2.texture = load("res://assets/" + nombre_bandera)
			texto_seleccion2.text = "Bandera seleccionada"

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
