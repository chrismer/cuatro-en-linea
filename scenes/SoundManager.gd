extends Node

# Referencias a nuestros reproductores de audio
@onready var music_player = $MusicPlayer
@onready var ficha_sound = $FichaSound
@onready var win_sound = $WinSound

func _ready():
	# Conectamos una señal que se disparará cuando el sonido de victoria termine.
	# Esto es clave para saber cuándo volver a subir el volumen.
	win_sound.finished.connect(_on_win_sound_finished)
	
# Función para reproducir el sonido de la ficha
func play_ficha_sound():
	ficha_sound.play()

# Función para reproducir el sonido de victoria
func play_win_sound():
	var tween = create_tween()
	tween.tween_property(music_player, "volume_db", -20, 1.0)
	win_sound.play()

func _on_win_sound_finished():
	# Esta función se llama automáticamente cuando 'win_sound' termina.
	# Creamos otra animación para restaurar el volumen de la música.
	var tween = create_tween()
	# Animamos la propiedad 'volume_db' de vuelta a 0 (volumen normal) durante 1.5 segundos.
	tween.tween_property(music_player, "volume_db", 0, 1.5)
