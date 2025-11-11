extends Node2D

var jugador: int = 1
var bandera: String = ""

@onready var sprite = $Sprite2D

func setup_ficha(bandera_path: String, jugador_num: int, target_width: float):
	var texture_to_load_path = ""
	if not bandera_path.is_empty():
		texture_to_load_path = "res://assets/" + bandera_path
	else:
		if jugador_num == 1:
			texture_to_load_path = "res://assets/red_piece.png"
		else:
			texture_to_load_path = "res://assets/yellow_piece.png"
	
	sprite.texture = load(texture_to_load_path)
	
	if sprite.texture:
		var escala = (target_width / sprite.texture.get_width()) * 0.90
		self.scale = Vector2(escala, escala)
		
# NUEVO: Función para animar la caída de la ficha
func iniciar_caida(posicion_final):
	# 1. Definimos la posición inicial (arriba, fuera de la pantalla)
	var posicion_inicial = Vector2(posicion_final.x, -100)
	self.position = posicion_inicial # Colocamos la ficha ahí al instante
	
	# 2. Creamos un Tween para la animación
	var tween = create_tween()
	
	# 3. Le decimos al Tween que anime la propiedad "position"
	#    desde su lugar actual hasta la 'posicion_final'.
	#    La animación durará 0.8 segundos.
	tween.tween_property(self, "position", posicion_final, 0.8) \
		 .set_trans(Tween.TRANS_BOUNCE) \
		 .set_ease(Tween.EASE_OUT)
		
func _ready():
	# Si hay una bandera seleccionada, usarla; si no, usar el color por defecto
	if bandera != "":
		sprite.texture = load("res://assets/" + bandera)
	else:
		# Usar colores por defecto si no hay bandera
		if jugador == 1:
			sprite.texture = load("res://assets/red_piece.png")
		else:
			sprite.texture = load("res://assets/yellow_piece.png")
	
	# Asegurar que la ficha esté centrada
	sprite.centered = true
	
	# Ajustar el offset para que la ficha esté perfectamente centrada en su posición
	sprite.offset = Vector2.ZERO
