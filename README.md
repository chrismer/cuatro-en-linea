# 4 en Línea - Juego con Selección de Banderas

## Descripción
Este es un juego de "4 en línea" (Connect Four) desarrollado en Godot 4.4.1 que permite a los jugadores seleccionar banderas de diferentes países para representar sus fichas en lugar de usar colores tradicionales.

## Características
- **Menú de Selección de Banderas**: Cada jugador puede elegir una bandera diferente de una colección de 8 países
- **Prevención de Duplicados**: No se pueden seleccionar la misma bandera para ambos jugadores
- **Sistema de Turnos**: Alternancia automática entre jugadores
- **Detección de Ganador**: Identifica automáticamente cuando hay 4 fichas en línea
- **Línea Ganadora**: Dibuja una línea conectando las 4 fichas ganadoras
- **Mensajes de Estado**: Muestra claramente el turno actual y el ganador
- **Botón de Reinicio**: Permite reiniciar la partida manteniendo las banderas seleccionadas
- **Botón de Menú**: Permite volver al menú de selección de banderas

## Banderas Disponibles
- Argentina
- Japón
- Rusia
- Brasil
- Alemania
- Italia
- Francia
- España

## Cómo Jugar
1. **Selección de Banderas**: 
   - El Jugador 1 selecciona su bandera
   - El Jugador 2 selecciona una bandera diferente
   - El botón "¡JUGAR!" se habilita solo cuando ambos han seleccionado

2. **Juego**:
   - Hacer clic en cualquier columna para colocar una ficha
   - Las fichas caen automáticamente al fondo de la columna
   - El objetivo es conectar 4 fichas en línea (horizontal, vertical o diagonal)

3. **Navegación**:
   - **Reiniciar**: Limpia el tablero y reinicia la partida
   - **Menú**: Vuelve al menú de selección de banderas
   - **Salir**: Cierra el juego

## Archivos Principales
- `Main.tscn` / `Main.gd`: Escena principal que redirige al menú
- `scenes/menu_banderas.tscn` / `scenes/menu_banderas.gd`: Menú de selección de banderas
- `scenes/juego.tscn` / `scenes/juego.gd`: Lógica principal del juego
- `scenes/Ficha.tscn` / `scenes/ficha.gd`: Comportamiento de las fichas individuales

## Controles
- **Mouse**: Hacer clic para seleccionar banderas y colocar fichas
- **Teclado**: No se requiere

## Requisitos
- Godot 4.4.1 o superior
- Resolución mínima recomendada: 1280x720

## Instalación
1. Abrir el proyecto en Godot
2. Presionar F5 o el botón de "Play" para ejecutar
3. El juego se abrirá automáticamente en el menú de selección de banderas

## Personalización
- **Nuevas Banderas**: Agregar archivos de imagen en la carpeta `assets/` y actualizar la lista en `menu_banderas.gd`
- **Colores**: Modificar las constantes de color en `juego.gd`
- **Tamaños**: Ajustar las variables de escala y offset en `juego.gd`

## Notas Técnicas
- El juego usa un sistema de coordenadas donde la fila 0 está en la parte inferior
- Las banderas se cargan dinámicamente desde la carpeta de assets
- El sistema de limpieza automáticamente elimina fichas, mensajes y líneas al reiniciar
- Las posiciones de las fichas se calculan dinámicamente basándose en el tamaño y escala del tablero

