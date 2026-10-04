# Taller Segundo Plano – Flutter

## Descripción
App que demuestra asincronía en Flutter: Future/async/await, Timer e Isolate.

## ¿Cuándo usar cada uno?
| Herramienta | Úsala cuando... | Ejemplo |
|---|---|---|
| Future | Una operación tarda y devuelve un valor una vez | Consulta a API/BD |
| async/await | Quieres escribir código asíncrono legible, secuencial | Esperar el resultado de un Future |
| Timer | Necesitas ejecutar algo tras un tiempo o periódicamente | Cronómetro, cuenta regresiva |
| Isolate | Hay trabajo CPU-bound que congelaría la UI | Cálculos grandes, procesar datos |

> Future/async NO crean hilos: solo no bloquean mientras *esperan* I/O.
> Un Isolate sí corre en otro hilo con memoria propia (comunica por mensajes).

## Pantallas y flujos
1. **Future:** Inicial → Cargando (3 s) → Éxito/Error
2. **Cronómetro:** Iniciar → Pausar → Reanudar → Reiniciar (Timer.periodic 100 ms, cancelado en dispose)
3. **Isolate:** Botón → spawn → cálculo → SendPort → resultado en UI

(Incluye un diagrama Mermaid o imagen)

## Cómo ejecutar
flutter pub get && flutter run

## GitFlow
feature/taller_segundo_plano → dev → main