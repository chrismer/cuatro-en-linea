extends Node

# Singleton para manejar datos del juego entre escenas
var bandera_jugador1: String = ""
var bandera_jugador2: String = ""
var nombre_jugador1: String = "Jugador 1"
var nombre_jugador2: String = "Jugador 2"

func set_nombres(nombre1: String, nombre2: String):
	nombre_jugador1 = nombre1
	nombre_jugador2 = nombre2
	
func set_banderas(bandera1: String, bandera2: String):
	bandera_jugador1 = bandera1
	bandera_jugador2 = bandera2
	print("Banderas guardadas: ", bandera1, " y ", bandera2)

func get_banderas() -> Array:
	return [bandera_jugador1, bandera_jugador2]

func reset():
	bandera_jugador1 = ""
	bandera_jugador2 = ""
	nombre_jugador1 = "Jugador 1"
	nombre_jugador2 = "Jugador 2"
