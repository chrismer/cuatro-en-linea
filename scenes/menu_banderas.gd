extends Control

# --- 1. REFERENCIAS A NODOS EXISTENTES EN LA ESCENA ---
# Obtenemos acceso a los nodos que creamos en el editor.
@onready var banderas_jugador1 = $BanderasJugador1
@onready var banderas_jugador2 = $BanderasJugador2
@onready var seleccion_jugador1 = $SeleccionJugador1
@onready var seleccion_jugador2 = $SeleccionJugador2
@onready var texto_seleccion1 = $TextoSeleccion1
@onready var texto_seleccion2 = $TextoSeleccion2
@onready var boton_jugar = $BotonJugar
@onready var boton_salir = $BotonSalir

# --- 2. VARIABLES DE ESTADO ---
# Variables para guardar las selecciones actuales.
var bandera_seleccionada_j1: Texture2D = null
var bandera_seleccionada_j2: Texture2D = null
var bandera_path_j1: String = ""
var bandera_path_j2: String = ""

# Diccionario para mapear cada botón a la ruta de su textura.
# Lo llenaremos en la función _ready.
var mapa_banderas = {}

# --- 3. INICIALIZACIÓN ---
func _ready():
	# Conectamos las señales de los botones principales.
	boton_jugar.pressed.connect(_on_boton_jugar_pressed)
	boton_salir.pressed.connect(_on_boton_salir_pressed)

	# --- Lógica para conectar todos los botones de banderas ---
	# Para el Jugador 1:
	for boton in banderas_jugador1.get_children():
		# Guardamos la ruta de la textura del botón en nuestro mapa.
		var textura = boton.texture_normal
		if textura:
			mapa_banderas[boton] = textura.resource_path
		# Conectamos la señal 'pressed' de cada botón a la función de lógica.
		# Le pasamos el propio botón y el número del jugador (1).
		boton.pressed.connect(_on_bandera_seleccionada.bind(boton, 1))

	# Hacemos lo mismo para el Jugador 2.
	for boton in banderas_jugador2.get_children():
		var textura = boton.texture_normal
		if textura:
			mapa_banderas[boton] = textura.resource_path
		boton.pressed.connect(_on_bandera_seleccionada.bind(boton, 2))

# --- 4. LÓGICA DEL JUEGO ---
func _on_bandera_seleccionada(boton_presionado: TextureButton, jugador: int):
	var textura_seleccionada = boton_presionado.texture_normal
	var path_seleccionado = mapa_banderas[boton_presionado]

	if jugador == 1:
		# Si el jugador 1 vuelve a presionar su bandera, la deselecciona.
		if bandera_seleccionada_j1 == textura_seleccionada:
			bandera_seleccionada_j1 = null
			bandera_path_j1 = ""
			seleccion_jugador1.texture = null
			texto_seleccion1.text = "Selecciona una bandera"
		# Si la bandera no está ocupada por el jugador 2, la selecciona.
		elif textura_seleccionada != bandera_seleccionada_j2:
			bandera_seleccionada_j1 = textura_seleccionada
			bandera_path_j1 = path_seleccionado
			seleccion_jugador1.texture = bandera_seleccionada_j1
			texto_seleccion1.text = "Bandera seleccionada"

	elif jugador == 2:
		# Si el jugador 2 vuelve a presionar su bandera, la deselecciona.
		if bandera_seleccionada_j2 == textura_seleccionada:
			bandera_seleccionada_j2 = null
			bandera_path_j2 = ""
			seleccion_jugador2.texture = null
			texto_seleccion2.text = "Selecciona una bandera"
		# Si la bandera no está ocupada por el jugador 1, la selecciona.
		elif textura_seleccionada != bandera_seleccionada_j1:
			bandera_seleccionada_j2 = textura_seleccionada
			bandera_path_j2 = path_seleccionado
			seleccion_jugador2.texture = bandera_seleccionada_j2
			texto_seleccion2.text = "Bandera seleccionada"

	_verificar_selecciones()

# Función para habilitar o deshabilitar el botón de jugar.
func _verificar_selecciones():
	if bandera_seleccionada_j1 != null and bandera_seleccionada_j2 != null:
		boton_jugar.disabled = false
		boton_jugar.add_theme_color_override("font_color", Color.GREEN)
	else:
		boton_jugar.disabled = true
		boton_jugar.add_theme_color_override("font_color", Color.WHITE)

# --- 5. NAVEGACIÓN ---
func _on_boton_jugar_pressed():
	# Guardamos las rutas de las banderas (solo el nombre del archivo) en el singleton.
	var nombre_bandera1 = bandera_path_j1.get_file()
	var nombre_bandera2 = bandera_path_j2.get_file()
	GameData.set_banderas(nombre_bandera1, nombre_bandera2)
	
	get_tree().change_scene_to_file("res://scenes/juego.tscn")

func _on_boton_salir_pressed():
	get_tree().quit()
