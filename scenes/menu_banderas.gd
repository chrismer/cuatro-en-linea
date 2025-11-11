extends Control

# --- 1. REFERENCIAS A NODOS ---
@onready var grid_banderas = $GridBanderas
@onready var nombre_jugador1 = $NombreJugador1
@onready var nombre_jugador2 = $NombreJugador2
@onready var seleccion_jugador1 = $SeleccionJugador1
@onready var seleccion_jugador2 = $SeleccionJugador2
@onready var texto_seleccion1 = $TextoSeleccion1
@onready var texto_seleccion2 = $TextoSeleccion2
@onready var boton_jugar = $BotonJugar
@onready var boton_salir = $BotonSalir

# --- 2. VARIABLES DE ESTADO ---
var bandera_seleccionada_j1: Texture2D = null
var bandera_seleccionada_j2: Texture2D = null
var bandera_path_j1: String = ""
var bandera_path_j2: String = ""
var turno_actual = 1  # 1 para Jugador 1, 2 para Jugador 2

var mapa_banderas = {}

# --- 3. INICIALIZACIÓN ---
func _ready():
	# Cargar nombres de jugadores desde el singleton.
	nombre_jugador1.text = GameData.nombre_jugador1
	nombre_jugador2.text = GameData.nombre_jugador2

	# Conectar señales de los botones.
	boton_jugar.pressed.connect(_on_boton_jugar_pressed)
	boton_salir.pressed.connect(_on_boton_salir_pressed)

	# Llenar el mapa de banderas y conectar las señales.
	for boton in grid_banderas.get_children():
		if boton is TextureButton:
			var textura = boton.texture_normal
			if textura:
				mapa_banderas[boton] = textura.resource_path
			boton.pressed.connect(_on_bandera_seleccionada.bind(boton))

	# Estado inicial de los textos de selección.
	texto_seleccion1.text = "¡Es tu turno, %s!" % GameData.nombre_jugador1
	texto_seleccion2.text = "Esperando..."
	_verificar_selecciones()

# --- 4. LÓGICA DEL JUEGO ---
func _on_bandera_seleccionada(boton_presionado: TextureButton):
	var textura_seleccionada = boton_presionado.texture_normal
	var path_seleccionado = mapa_banderas[boton_presionado]

	if turno_actual == 1:
		# No permitir seleccionar la bandera del oponente.
		if textura_seleccionada == bandera_seleccionada_j2:
			return

		# Asignar o deseleccionar bandera.
		if bandera_seleccionada_j1 == textura_seleccionada:
			bandera_seleccionada_j1 = null
			bandera_path_j1 = ""
			seleccion_jugador1.texture = null
		else:
			bandera_seleccionada_j1 = textura_seleccionada
			bandera_path_j1 = path_seleccionado
			seleccion_jugador1.texture = bandera_seleccionada_j1

		# Cambiar al siguiente turno.
		turno_actual = 2
		texto_seleccion1.text = "Seleccionado"
		texto_seleccion2.text = "¡Tu turno, %s!" % GameData.nombre_jugador2

	elif turno_actual == 2:
		# No permitir seleccionar la bandera del oponente.
		if textura_seleccionada == bandera_seleccionada_j1:
			return

		# Asignar o deseleccionar bandera.
		if bandera_seleccionada_j2 == textura_seleccionada:
			bandera_seleccionada_j2 = null
			bandera_path_j2 = ""
			seleccion_jugador2.texture = null
		else:
			bandera_seleccionada_j2 = textura_seleccionada
			bandera_path_j2 = path_seleccionado
			seleccion_jugador2.texture = bandera_seleccionada_j2

		# Cambiar al siguiente turno.
		turno_actual = 1
		texto_seleccion2.text = "Seleccionado"
		texto_seleccion1.text = "¡Tu turno, %s!" % GameData.nombre_jugador1

	_actualizar_feedback_botones()
	_verificar_selecciones()

# --- 5. FUNCIONES AUXILIARES ---
func _verificar_selecciones():
	# Habilita el botón de jugar solo si ambos jugadores han elegido.
	if bandera_seleccionada_j1 and bandera_seleccionada_j2:
		boton_jugar.disabled = false
		boton_jugar.add_theme_color_override("font_color", Color.GREEN)
	else:
		boton_jugar.disabled = true
		boton_jugar.add_theme_color_override("font_color", Color.GRAY)

func _actualizar_feedback_botones():
	# Modula los botones para indicar cuáles están seleccionados.
	for boton in grid_banderas.get_children():
		if boton is TextureButton:
			var textura = boton.texture_normal
			if textura == bandera_seleccionada_j1 or textura == bandera_seleccionada_j2:
				boton.modulate = Color(0.5, 0.5, 0.5) # Color atenuado para seleccionados.
			else:
				boton.modulate = Color(1, 1, 1) # Color normal.

# --- 6. NAVEGACIÓN ---
func _on_boton_jugar_pressed():
	if not boton_jugar.disabled:
		GameData.set_banderas(bandera_path_j1, bandera_path_j2)
		get_tree().change_scene_to_file("res://scenes/juego.tscn")

func _on_boton_salir_pressed():
	get_tree().quit()
