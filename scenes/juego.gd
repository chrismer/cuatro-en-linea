extends Node2D

const ANCHO = 7
const ALTO = 6

var cuadricula = []
var turno_actual = 1  # 1 = rojo, 2 = amarillo
var partida_terminada = false
var posiciones_ganadoras = []  # Para guardar inicio y fin de la línea ganadora

const EscenaFicha = preload("res://scenes/Ficha.tscn")

#@onready var sprite = $Sprite2D

## Variables de Ajuste Manual de Posición
@export var offset_general_x: float = 12.0  # Mueve TODAS las fichas a la izquierda (-) o derecha (+)
@export var offset_general_y: float = -16.0  # Mueve TODAS las fichas hacia arriba (-) o abajo (+)
@export var espaciado_horizontal_ajuste: float = -5.0 # Aumenta o reduce el espacio ENTRE columnas
@export var espaciado_vertical_ajuste: float = 5.0   # Aumenta o reduce el espacio ENTRE filas

@onready var contenedor_fichas = $ContenedorFichas
@onready var info_label = $UI/InfoLabel
@onready var tablero = $Tablero
@onready var boton_reiniciar = $UI/BotonReiniciar
@onready var posiciones_fichas = $PosicionesFichas

func _ready():
	iniciar_partida()
	boton_reiniciar.pressed.connect(_on_boton_reiniciar_pressed)

func _on_boton_reiniciar_pressed():
	iniciar_partida()

func iniciar_partida():
	print("Iniciando la partida...")
	partida_terminada = false
	turno_actual = 1
	posiciones_ganadoras.clear()  # Limpiar posiciones ganadoras anteriores
	
	# Verificar si la cuadrícula ya está inicializada, si no, inicializarla
	if cuadricula.size() == 0:
		print("Inicializando cuadrícula por primera vez...")
		cuadricula = []
		for columna in range(ANCHO):
			var fila_array = []
			for fila in range(ALTO):
				fila_array.append(0)
			cuadricula.append(fila_array)
	else:
		# Limpiar la cuadrícula lógica existente
		print("Limpiando cuadrícula existente...")
		for columna in range(ANCHO):
			for fila in range(ALTO):
				cuadricula[columna][fila] = 0
	
	# Debug: verificar que la cuadrícula esté limpia
	print("DEBUG - Cuadrícula después de limpiar:")
	for columna in range(ANCHO):
		print("  Columna ", columna, ": ", cuadricula[columna])
	
	# Eliminar fichas existentes del contenedor
	for ficha in contenedor_fichas.get_children():
		ficha.queue_free()
	
	# También eliminar fichas del grupo (por si acaso)
	for ficha in get_tree().get_nodes_in_group("fichas"):
		ficha.queue_free()
	
	# Eliminar mensajes de ganador/empate
	for nodo in get_children():
		if nodo is Label and (nodo.name == "MensajeGanador" or nodo.name == "MensajeEmpate"):
			nodo.queue_free()
		elif nodo is ColorRect and (nodo.name == "FondoGanador" or nodo.name == "FondoEmpate"):
			nodo.queue_free()
	
	# Eliminar líneas ganadoras anteriores
	for nodo in get_children():
		if nodo is Line2D:
			nodo.queue_free()
	
	print("Partida reiniciada - Cuadrícula limpia, fichas eliminadas")
	actualizar_texto_turno()

func actualizar_texto_turno():
	var banderas = GameData.get_banderas()
	var nombre_jugador1 = "Jugador 1"
	var nombre_jugador2 = "Jugador 2"
	
	if banderas[0] != "":
		nombre_jugador1 = banderas[0].replace(".png", "")
	if banderas[1] != "":
		nombre_jugador2 = banderas[1].replace(".png", "")
		
	if turno_actual == 1:
		info_label.text = "Turno de " + nombre_jugador1
		info_label.add_theme_color_override("font_color", Color.WHITE)
	else:
		info_label.text = "Turno de " + nombre_jugador2
		info_label.add_theme_color_override("font_color", Color.WHITE)
	
func _input(event):
	if partida_terminada:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		
		# Calcular el tamaño real de cada celda basado en el tablero escalado
		var tamano_celda_x = tablero.texture.get_width() * tablero.scale.x / ANCHO
		
		# Calcular la posición relativa al tablero
		var pos_relativa_x = event.position.x - tablero.position.x + (tablero.texture.get_width() * tablero.scale.x) / 2
		var columna_seleccionada = int(pos_relativa_x / tamano_celda_x)
		
		colocar_ficha(columna_seleccionada)

func colocar_ficha(columna):
	
	if columna < 0 or columna >= ANCHO:
		print("Columna fuera de rango: ", columna)
		return

	print("Intentando colocar ficha en columna: ", columna)
	
	# Debug: mostrar el estado de la columna
	print("DEBUG - Estado de la columna ", columna, ": ", cuadricula[columna])
	
	# Buscar desde abajo hacia arriba para que las fichas "caigan"
	# ALTO = 6, entonces las filas son [0, 1, 2, 3, 4, 5] donde 0 es abajo y 5 es arriba
	for fila in range(ALTO):  # range(6) = [0, 1, 2, 3, 4, 5]
		print("DEBUG - Revisando fila ", fila, " valor: ", cuadricula[columna][fila])
		if cuadricula[columna][fila] == 0:
			
			print("Colocando ficha en columna ", columna, " fila ", fila)
			cuadricula[columna][fila] = turno_actual
			
			var nueva_ficha = EscenaFicha.instantiate()
			
			var nombre_posicion = "Pos_%d_%d" % [columna, fila]
			var nodo_posicion = posiciones_fichas.get_node_or_null(nombre_posicion)
			
			if nodo_posicion:
				#nueva_ficha.global_position = nodo_posicion.global_position
				nueva_ficha.iniciar_caida(nodo_posicion.global_position)
				SoundManager.play_ficha_sound()
			else:
				print("ERROR: No se encontró el Marker2D llamado '", nombre_posicion, "'. La ficha no se posicionará correctamente.")
				continue # Salta a la siguiente iteración si el marcador no existe
			
			contenedor_fichas.add_child(nueva_ficha)
			
			var bandera_para_usar = ""
			var banderas = GameData.get_banderas()
			
			#nueva_ficha.jugador = turno_actual
			if turno_actual == 1:
				bandera_para_usar = banderas[0]
			else:
				bandera_para_usar = banderas[1]
			
			var tamano_celda_x = (tablero.texture.get_width() * tablero.scale.x) / ANCHO
			nueva_ficha.setup_ficha(bandera_para_usar, turno_actual, tamano_celda_x)
			
			# Agregar la ficha al grupo para poder eliminarla después
			nueva_ficha.add_to_group("fichas")
			# Calcular la posición de la ficha de manera simple y directa
			#var tamano_celda_x = (600 * tablero.scale.x) / ANCHO

			#var textura_ficha = nueva_ficha.sprite.texture
			#if textura_ficha:
			#	var escala = (tamano_celda_x / textura_ficha.get_width()) * 0.90
			#	nueva_ficha.scale = Vector2(escala, escala)
			#var tamano_celda_y = (600 * tablero.scale.y) / ALTO
			#nueva_ficha.add_to_group("fichas")
			#contenedor_fichas.add_child(nueva_ficha)
			
			# Posición base del tablero (esquina superior izquierda)
			#var pos_tablero_x = tablero.position.x - (tablero.texture.get_width() * tablero.scale.x) / 2
			#var pos_tablero_y = tablero.position.y - (tablero.texture.get_height() * tablero.scale.y) / 2
			
			# Posición de la ficha en la celda (centrada)
			# IMPORTANTE: Las filas 0,1,2,3,4,5 deben corresponder visualmente de abajo hacia arriba
			# Aplicamos los offsets para un ajuste fino
			#var pos_x = pos_tablero_x + (columna * tamano_celda_x) + (tamano_celda_x / 2) + offset_general_x + (columna * espaciado_horizontal_ajuste)
			#var pos_y = pos_tablero_y + ((ALTO - 1 - fila) * tamano_celda_y) + (tamano_celda_y / 2) + offset_general_y + (fila * espaciado_vertical_ajuste)
			
			# Debug: imprimir información de posicionamiento
			print("DEBUG - Tablero pos: ", tablero.position, " scale: ", tablero.scale)
			#print("DEBUG - Celda tamaño: ", tamano_celda_x, " x ", tamano_celda_y)
			#print("DEBUG - Pos base tablero: ", pos_tablero_x, ", ", pos_tablero_y)
			print("DEBUG - Fila lógica: ", fila, " Fila visual: ", ALTO - 1 - fila)
			#print("DEBUG - Ficha pos final: ", pos_x, ", ", pos_y)
			
			# Escalar la ficha para que quepa en la celda
			#var escala_ficha = min(tamano_celda_x, tamano_celda_y) / 290.0  # Ajustar este valor según sea necesario
			#nueva_ficha.scale = Vector2(escala_ficha, escala_ficha)
			
			# Posicionar la ficha
			#nueva_ficha.position = Vector2(pos_x, pos_y)
			
			# Verificar si hay un ganador
			if verificar_ganador(columna, fila):
				partida_terminada = true
				#var jugador_ganador = "Rojo" if turno_actual == 1 else "Amarillo"
				
				var nombre_ganador = banderas[turno_actual - 1].replace(".png", "")
				info_label.text = "¡Ganador: " + nombre_ganador + "!"
				
				#info_label.text = "¡Ganador: Jugador " + jugador_ganador + "!"
				#if turno_actual == 1:
				#	info_label.add_theme_color_override("font_color", Color.RED)
				#else:
				#	info_label.add_theme_color_override("font_color", Color.YELLOW)
				#mostrar_mensaje_ganador(jugador_ganador, turno_actual)
				mostrar_mensaje_ganador(turno_actual)
				return
			
			# Verificar si hay empate (tablero lleno)
			if verificar_empate():
				partida_terminada = true
				info_label.text = "¡EMPATE!"
				info_label.add_theme_color_override("font_color", Color.WHITE)
				mostrar_mensaje_empate()
				return
			
			cambiar_turno()
			
			return
	
	print("No se pudo colocar la ficha en la columna ", columna, " - columna llena")

func cambiar_turno():
	if turno_actual == 1:
		turno_actual = 2
	else:
		turno_actual = 1
	actualizar_texto_turno()

func verificar_ganador(columna, fila):
	var jugador = cuadricula[columna][fila]
	if jugador == 0:
		return false

	var direcciones = [[1, 0], [0, 1], [1, 1], [1, -1]] # Horizontal, Vertical, Diag Abajo, Diag Arriba

	for dir in direcciones:
		var linea = [Vector2(columna, fila)]
		# Revisar en una dirección
		for i in range(1, 4):
			var c = columna + dir[0] * i  # Usar dir[0] en lugar de dir.x
			var f = fila + dir[1] * i    # Usar dir[1] en lugar de dir.y
			if c >= 0 and c < ANCHO and f >= 0 and f < ALTO and cuadricula[c][f] == jugador:
				linea.append(Vector2(c, f))
			else:
				break
		# Revisar en la dirección opuesta
		for i in range(1, 4):
			var c = columna - dir[0] * i  # Usar dir[0] en lugar de dir.x
			var f = fila - dir[1] * i    # Usar dir[1] en lugar de dir.y
			if c >= 0 and c < ANCHO and f >= 0 and f < ALTO and cuadricula[c][f] == jugador:
				linea.append(Vector2(c, f))
			else:
				break

		if linea.size() >= 4:
			# Ordenar para encontrar los extremos
			linea.sort()
			posiciones_ganadoras = [linea[0], linea[-1]] # Guardar solo el inicio y el fin
			mostrar_linea_ganadora(jugador)
			return true

	return false

func verificar_empate():
	# Verificar si el tablero está completamente lleno
	for columna in range(ANCHO):
		for fila in range(ALTO):
			if cuadricula[columna][fila] == 0:
				return false  # Hay al menos un espacio vacío
	return true  # Tablero lleno, empate

func mostrar_mensaje_empate():
	# Crear el fondo oscuro semi-transparente
	var fondo_empate = ColorRect.new()
	fondo_empate.name = "FondoEmpate"
	fondo_empate.color = Color(0, 0, 0, 0.8)
	
	var ancho_tablero = tablero.texture.get_width() * tablero.scale.x
	var alto_tablero = tablero.texture.get_height() * tablero.scale.y
	
	fondo_empate.size = Vector2(ancho_tablero, alto_tablero * 0.4)
	fondo_empate.position = Vector2(tablero.position.x - ancho_tablero/2, tablero.position.y - (alto_tablero * 0.2))
	
	# --- INICIO DE LA CORRECCIÓN ---
	# Crear el mensaje de empate
	var mensaje_empate = Label.new()
	mensaje_empate.name = "MensajeEmpate"
	mensaje_empate.text = "¡EMPATE!"
	mensaje_empate.add_theme_font_size_override("font_size", 48)
	mensaje_empate.add_theme_color_override("font_color", Color.WHITE)
	
	# Hacemos que la etiqueta tenga la misma posición y tamaño que el fondo
	mensaje_empate.position = fondo_empate.position
	mensaje_empate.size = fondo_empate.size
	
	# Centramos el texto DENTRO de la etiqueta
	mensaje_empate.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	mensaje_empate.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	# --- FIN DE LA CORRECCIÓN ---
	
	# Agregar al nodo principal
	add_child(fondo_empate)
	add_child(mensaje_empate)
	
	# Hacer que el mensaje esté por encima del fondo
	mensaje_empate.z_index = 100
	fondo_empate.z_index = 99

func mostrar_linea_ganadora(jugador_ganador):
	if posiciones_ganadoras.size() < 2:
		return

	var linea = Line2D.new()
	linea.width = 10
	
	if jugador_ganador == 1:
		linea.default_color = Color.RED
	else:
		linea.default_color = Color.YELLOW

	var puntos = []
	var tamano_celda_x = (tablero.texture.get_width() * tablero.scale.x) / ANCHO
	var tamano_celda_y = (tablero.texture.get_height() * tablero.scale.y) / ALTO
	
	var pos_tablero_x = tablero.position.x - (tablero.texture.get_width() * tablero.scale.x) / 2
	var pos_tablero_y = tablero.position.y - (tablero.texture.get_height() * tablero.scale.y) / 2

	# Puntos de inicio y fin de la secuencia ganadora
	var inicio = posiciones_ganadoras[0]
	var fin = posiciones_ganadoras[1]
	
	# Calculamos la posición del punto INICIAL
	var pos_x_inicio = pos_tablero_x + (inicio.x * tamano_celda_x) + (tamano_celda_x / 2) + offset_general_x + (inicio.x * espaciado_horizontal_ajuste)
	var pos_y_inicio = pos_tablero_y + ((ALTO - 1 - inicio.y) * tamano_celda_y) + (tamano_celda_y / 2) + offset_general_y + (inicio.y * espaciado_vertical_ajuste)
	puntos.append(Vector2(pos_x_inicio, pos_y_inicio))
	
	# Calculamos la posición del punto FINAL
	var pos_x_fin = pos_tablero_x + (fin.x * tamano_celda_x) + (tamano_celda_x / 2) + offset_general_x + (fin.x * espaciado_horizontal_ajuste)
	var pos_y_fin = pos_tablero_y + ((ALTO - 1 - fin.y) * tamano_celda_y) + (tamano_celda_y / 2) + offset_general_y + (fin.y * espaciado_vertical_ajuste)
	puntos.append(Vector2(pos_x_fin, pos_y_fin))

	linea.points = puntos
	linea.z_index = 50
	add_child(linea)

func mostrar_mensaje_ganador(jugador_numero):
	# ... (código para crear el fondo_ganador igual que antes)
	SoundManager.play_win_sound()
	var fondo_ganador = ColorRect.new()
	fondo_ganador.name = "FondoGanador"
	fondo_ganador.color = Color(0, 0, 0, 0.8)
	var ancho_tablero = tablero.texture.get_width() * tablero.scale.x
	var alto_tablero = tablero.texture.get_height() * tablero.scale.y
	fondo_ganador.size = Vector2(ancho_tablero, alto_tablero * 0.4)
	fondo_ganador.position = Vector2(tablero.position.x - ancho_tablero/2, tablero.position.y - (alto_tablero * 0.2))
	
	var mensaje_ganador = Label.new()
	mensaje_ganador.name = "MensajeGanador"
	
	var banderas = GameData.get_banderas()
	var nombre_ganador = "Jugador " + str(jugador_numero)
	
	if jugador_numero == 1:
		nombre_ganador = GameData.nombre_jugador1
	else:
		nombre_ganador = GameData.nombre_jugador2
	
	var bandera_ganadora_archivo = banderas[jugador_numero - 1]
	
	# NUEVO: Llamamos a la función para registrar la victoria en la base de datos.
	#DatabaseManager.registrar_victoria(nombre_ganador, bandera_ganadora_archivo)
	RankingManager.register_victory(nombre_ganador, bandera_ganadora_archivo)
	
	#var nombre_pais_ganador = bandera_ganadora_archivo.replace(".png", "")
	#
	#if not banderas[jugador_numero - 1].is_empty():
		#nombre_pais_ganador = banderas[jugador_numero - 1].replace(".png", "")
	#
	#mensaje_ganador.text = "¡" + jugador_ganador + " GANÓ!"
	mensaje_ganador.text = "¡" + nombre_ganador + " GANÓ!"
	mensaje_ganador.add_theme_font_size_override("font_size", 48)
	mensaje_ganador.add_theme_color_override("font_color", Color.GOLD)
	
	
	#if jugador_numero == 1:
	#	mensaje_ganador.add_theme_color_override("font_color", Color.RED)
	#else:
	#	mensaje_ganador.add_theme_color_override("font_color", Color.YELLOW)
	
	# Hacemos que la etiqueta tenga la misma posición y tamaño que el fondo
	mensaje_ganador.position = fondo_ganador.position
	mensaje_ganador.size = fondo_ganador.size
	
	# Centramos el texto DENTRO de la etiqueta
	mensaje_ganador.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	mensaje_ganador.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	# --- FIN DEL CAMBIO ---
	
	add_child(fondo_ganador)
	add_child(mensaje_ganador)
	
	mensaje_ganador.z_index = 100
	fondo_ganador.z_index = 99


func _on_boton_menu_pressed() -> void:
	#get_tree().change_scene_to_file("res://scenes/menu_simple.tscn")
	get_tree().change_scene_to_file("res://scenes/ingresar_nombres.tscn")
	#get_tree().change_scene_to_packed(menuSimple)
