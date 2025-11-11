extends Node

# La ruta donde se guardará nuestro archivo de ranking.
# Seguirá guardándose en la carpeta de datos del usuario.
const SAVE_PATH = "user://ranking.json"

# Esta variable contendrá nuestros datos del ranking en memoria.
var ranking_data = {}

func _ready():
	# Cargamos los datos del ranking al iniciar el juego.
	load_ranking()

# Función para guardar el ranking en el archivo.
func save_ranking():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	# Convertimos nuestro diccionario de datos a un string en formato JSON.
	var json_string = JSON.stringify(ranking_data, "\t")
	file.store_string(json_string)
	file.close()
	print("Ranking guardado.")

# Función para cargar el ranking desde el archivo.
func load_ranking():
	if not FileAccess.file_exists(SAVE_PATH):
		print("No se encontró archivo de ranking. Se creará uno nuevo.")
		return # No hay nada que cargar.

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var json_string = file.get_as_text()
	file.close()
	
	# Convertimos el string de JSON de vuelta a un diccionario de Godot.
	var json = JSON.new()
	var error = json.parse(json_string)
	if error == OK:
		ranking_data = json.data
		print("Ranking cargado exitosamente.")
	else:
		print("Error al cargar el ranking: ", json.get_error_message())


# La nueva lógica para registrar una victoria.
func register_victory(nombre: String, bandera: String):
	# Creamos una clave única para cada jugador-bandera, ej: "chris_Argentina.png"
	var key = nombre + "_" + bandera
	
	if ranking_data.has(key):
		# Si ya existe, simplemente le sumamos 1 a las victorias.
		ranking_data[key]["victorias"] += 1
	else:
		# Si no existe, creamos una nueva entrada.
		ranking_data[key] = {
			"nombre": nombre,
			"bandera": bandera,
			"victorias": 1
		}
	
	# Guardamos los cambios en el archivo.
	save_ranking()

# Nueva función para obtener el ranking como un Array ordenado.
func get_sorted_ranking() -> Array:
	var sorted_array = ranking_data.values()
	
	# Ordenamos el array de mayor a menor número de victorias.
	sorted_array.sort_custom(func(a, b): return a.victorias > b.victorias)
	
	return sorted_array
