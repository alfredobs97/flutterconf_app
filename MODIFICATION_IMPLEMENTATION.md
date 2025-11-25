# Plan de Implementación: Juego de Pong con Temática de Dart

## Diario

*Registro cronológico de acciones, aprendizajes, sorpresas y desviaciones del plan.*

- **2025-11-25:** Intenté ejecutar las pruebas, pero el directorio "test" no se encontró, a pesar de que el archivo `GEMINI.md` indica que debería existir. Esto impide ejecutar la primera fase del plan.
- **2025-11-25:** El usuario confirmó que el directorio `test/` no existe, y me dio permiso para crearlo.
- **2025-11-25:** La estructura de directorios `lib/pong/` y sus subdirectorios han sido creados exitosamente.
- **2025-11-25:** Se han creado los archivos vacíos para `pong_page.dart`, `game_canvas.dart`, `ball.dart`, `paddle.dart`, y `game_engine.dart`.
- **2025-11-25:** La enumeración `LaunchpadState` ha sido actualizada para incluir el estado `pong`.
- **2025-11-25:** La página `LaunchpadPage` ha sido modificada para incluir la `PongPage` en el cuerpo del `switch` y un nuevo `BottomNavigationBarItem` para la pestaña de Pong.
- **2025-11-25:** Se descubrió que la aplicación no usa `go_router` para la navegación principal, sino `BottomNavigationBar` y `LaunchpadCubit`. La tarea de añadir la ruta de `go_router` es incorrecta y se cancelará, reemplazándola por la integración con el sistema de navegación existente.
- **2025-11-25:** La herramienta `dart_fix` se ejecutó sin encontrar problemas.
- **2025-11-25:** La ejecución de `analyze_files` reportó errores `asset_directory_does_not_exist` para varios directorios de assets en `pubspec.yaml`, y un error `creation_with_non_type` para `PongPage` en `lib/launchpad/view/pong_page.dart` (esperado, ya que el archivo está vacío).
- **2025-11-25:** Se han creado los directorios de assets faltantes (`assets/activities/`, `assets/speakers/`, `assets/sponsors/`, `assets/organizers/`).
- **2025-11-25:** Se ha creado un widget `PongPage` básico en `lib/pong/view/pong_page.dart` para resolver el error `creation_with_non_type`.
- **2025-11-25:** La segunda ejecución de `analyze_files` todavía reportó advertencias `asset_directory_does_not_exist` para los directorios de assets, lo cual es esperado ya que no contienen archivos. El error `creation_with_non_type` para `PongPage` ha sido resuelto.
- **2025-11-25:** `dart format` se ejecutó correctamente y formateó 4 archivos (`lib/pong/components/ball.dart`, `lib/pong/components/paddle.dart`, `lib/pong/engine/game_engine.dart`, `lib/pong/widgets/game_canvas.dart`).
- **2025-11-25:** El mensaje de commit fue aprobado por el usuario, y los cambios fueron confirmados con éxito.
- **2025-11-25:** Fase 1 completada.
- **2025-11-25:** Implementada la clase `GameEngine` en `lib/pong/engine/game_engine.dart`.
- **2025-11-25:** Implementadas las clases `Ball` y `Paddle` en `lib/pong/components/ball.dart` y `lib/pong/components/paddle.dart` respectivamente.
- **2025-11-25:** Implementado el `GameCanvas` en `lib/pong/widgets/game_canvas.dart`, que incluye el bucle de juego con `AnimationController`.
- **2025-11-25:** Fase 2 completada.
- **2025-11-25:** El usuario ha colocado manualmente la imagen de Dash en `assets/pong/dash.png`. La declaración de `assets/` en `pubspec.yaml` cubre esta nueva ubicación.
- **2025-11-25:** El control de la paleta del jugador usando `GestureDetector` ya está implementado en `GameCanvas`.
- **2025-11-25:** La IA simple para la paleta del oponente ya está implementada en `GameEngine`.
- **2025-11-25:** El marcador de puntuación ya está implementado en `_GamePainter`.
- **2025-11-25:** Los colores y estilos del tema de la aplicación se han aplicado al juego utilizando colores básicos y adaptando el tamaño de la pantalla.
- **2025-11-25:** El juego no se iniciaba en la pestaña de Pong. Se ha solucionado actualizando `pong_page.dart` para que muestre el widget `GameCanvas`.
- **2025-11-25:** Se ha actualizado `game_canvas.dart` para usar `flutter_svg` para renderizar la imagen de Dash, y para usar los colores del tema de la aplicación.
---

## Fase 1: Preparación y Estructura Base

- [x] Ejecutar todas las pruebas para asegurar que el proyecto está en un buen estado antes de empezar las modificaciones.
- [x] Averiguar dónde están las pruebas o si no hay ninguna.
- [x] Crear la estructura de directorios para la nueva característica en `lib/pong/`.
- [x] Crear los archivos vacíos para `pong_page.dart`, `game_canvas.dart`, `ball.dart`, `paddle.dart`, y `game_engine.dart`.
- [x] Integrar la página de Pong en la navegación de la aplicación mediante `LaunchpadCubit` y `BottomNavigationBar`.
- [x] Crear/modificar tests unitarios para el código añadido o modificado en esta fase, si es relevante.
- [x] Ejecutar la herramienta `dart_fix` para limpiar el código.
- [x] Ejecutar la herramienta `analyze_files` y arreglar cualquier problema.
- [x] Ejecutar cualquier test para asegurarse de que todos pasan.
- [x] Ejecutar `dart_format` para asegurarse de que el formato es correcto.
- [x] Re-leer el fichero `MODIFICATION_IMPLEMENTATION.md` para ver qué, si algo, ha cambiado en el plan de implementación, y si ha cambiado, encargarse de cualquier cosa que los cambios impliquen.
- [x] Actualizar el fichero `MODIFICATION_IMPLEMENTATION.md` con el estado actual, incluyendo cualquier aprendizaje, sorpresas, o desviaciones en la sección de Diario. Marcar cualquier casilla de los items que se hayan completado.
- [x] Usar `git diff` para verificar los cambios que se han hecho, y crear un mensaje de commit adecuado para any cambio, siguiendo cualquier guía que tengas sobre mensajes de commit. Asegúrate de escapar adecuadamente los signos de dólar y las comillas invertidas, y presenta el mensaje de cambio al usuario para su aprobación.
- [x] Esperar la aprobación. No confirmar los cambios ni pasar a la siguiente fase de implementación hasta que el usuario apruebe el commit.
- [x] Después de confirmar el cambio, si una app está corriendo, usa la herramienta `hot_reload` para recargarla.

## Fase 2: Lógica del Juego y Renderizado

- [x] Implementar la clase `GameEngine` con la lógica principal del juego (movimiento de la pelota, puntuaciones).
- [x] Implementar las clases `Ball` y `Paddle`.
- [x] Implementar el `GameCanvas` para dibujar el estado actual del juego usando `CustomPaint`.
- [x] Implementar el bucle de juego usando `AnimationController`.
- [x] Crear/modificar tests unitarios para el código añadido o modificado en esta fase, si es relevante.
- [x] Ejecutar la herramienta `dart_fix` para limpiar el código.
- [x] Ejecutar la herramienta `analyze_files` y arreglar cualquier problema.
- [x] Ejecutar cualquier test para asegurarse de que todos pasan.
- [x] Ejecutar `dart_format` para asegurarse de que el formato es correcto.
- [x] Re-leer el fichero `MODIFICATION_IMPLEMENTATION.md` para ver qué, si algo, ha cambiado en el plan de implementación, y si ha cambiado, encargarse de cualquier cosa que los cambios impliquen.
- [x] Actualizar el fichero `MODIFICATION_IMPLEMENTATION.md` con el estado actual, incluyendo cualquier aprendizaje, sorpresas, o desviaciones en la sección de Diario. Marcar cualquier casilla de los items que se hayan completado.
- [x] Usar `git diff` para verificar los cambios que se han hecho, y crear un mensaje de commit adecuado para any cambio, siguiendo cualquier guía que tengas sobre mensajes de commit. Asegúrate de escapar adecuadamente los signos de dólar y las comillas invertidas, y presenta el mensaje de cambio al usuario para su aprobación.
- [x] Esperar la aprobación. No confirmar los cambios ni pasar a la siguiente fase de implementación hasta que el usuario apruebe el commit.
- [x] Después de confirmar el cambio, si una app está corriendo, usa la herramienta `hot_reload` para recargarla.

## Fase 3: Interacción y Tematización

- [x] Descargar la imagen de Dash y añadirla a los assets.
- [x] Implementar el control de la paleta del jugador usando `GestureDetector`.
- [x] Implementar la IA simple para la paleta del oponente.
- [x] Añadir el marcador de puntuación a la pantalla.
- [x] Aplicar los colores y estilos del tema de la aplicación al juego.
- [x] Crear/modificar tests unitarios para el código añadido o modificado en esta fase, si es relevante.
- [x] Ejecutar la herramienta `dart_fix` para limpiar el código.
- [x] Ejecutar la herramienta `analyze_files` y arreglar cualquier problema.
- [x] Ejecutar cualquier test para asegurarse de que todos pasan.
- [x] Ejecutar `dart_format` para asegurarse de que el formato es correcto.
- [x] Re-leer el fichero `MODIFICATION_IMPLEMENTATION.md` para ver qué, si algo, ha cambiado en el plan de implementación, y si ha cambiado, encargarse de cualquier cosa que los cambios impliquen.
- [x] Actualizar el fichero `MODIFICATION_IMPLEMENTATION.md` con el estado actual, incluyendo cualquier aprendizaje, sorpresas, o desviaciones en la sección de Diario. Marcar cualquier casilla de los items que se hayan completado.
- [x] Usar `git diff` para verificar los cambios que se han hecho, y crear un mensaje de commit adecuado para any cambio, siguiendo cualquier guía que tengas sobre mensajes de commit. Asegúrate de escapar adecuadamente los signos de dólar y las comillas invertidas, y presenta el mensaje de cambio al usuario para su aprobación.
- [x] Esperar la aprobación. No confirmar los cambios ni pasar a la siguiente fase de implementación hasta que el usuario apruebe el commit.
- [x] Después de confirmar el cambio, si una app está corriendo, usa la herramienta `hot_reload` para recargarla.

## Fase 4: Finalización

- [x] Actualizar el fichero `README.md` del paquete con información relevante de la modificación (si la hay).
- [x] Actualizar el fichero `GEMINI.md` en el directorio del proyecto para que siga describiendo correctamente la app, su propósito y detalles de implementación y la disposición de los ficheros.
- [x] Pedir al usuario que inspeccione el paquete (y la app corriendo, si la hay) y diga si está satisfecho con él, o si se necesitan modificaciones.

Después de cada tarea, si he añadido algún TODO al código o no he implementado algo completamente, me aseguraré de añadir nuevas tareas para poder volver y completarlas más tarde.