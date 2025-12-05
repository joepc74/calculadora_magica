# Calculadora Mágica

Una calculadora Flutter funcional con un **truco de magia** oculto.

## Características

-   **Calculadora Estándar**: Realiza operaciones básicas (suma, resta, multiplicación, división).
-   **Modo Mágico**: Un modo secreto que permite realizar una predicción "imposible".

## ¿Cómo funciona el Truco de Magia?

El truco consiste en predecir un código de fecha y hora futuro (la hora actual + 1 minuto).

### Pasos para realizar el truco:

1.  **Preparación**: Asegúrate de que tu "espectador" te dé un número inicial o escribe tú uno aleatorio.
2.  **Activación**: Haz **doble clic** discretamente en el botón `+`.
    -   *Indicador Visual*: El título de la aplicación cambiará sutilmente a "Calculadora ."
3.  **La "Suma"**:
    -   Pide al espectador que escriba un número grande de 10 dígitos (por ejemplo, su teléfono, una fecha, etc.).
    -   **El Secreto**: No importa qué números pulse el espectador; la calculadora introducirá automáticamente los dígitos necesarios para que la suma dé el resultado objetivo.
    -   *Nota*: Otros botones como `C`, `.` o los operadores están desactivados durante este paso para evitar errores.
4.  **Finalización**:
    -   Una vez introducidos los 10 dígitos, el título volverá a ser "Calculadora".
    -   Pulsa `=`.
5.  **El Resultado**:
    -   El resultado será una secuencia de números que coincidirá exactamente con la fecha y hora n ese momento (+ 1 minuto de margen), formateado como `ddmmyyhhmm`.
    -   ¡Sorprende a tu audiencia revelando que el resultado es la hora exacta en el futuro!

## Instalación y Ejecución

Este proyecto es una aplicación Flutter estándar.

```bash
# Obtener dependencias
flutter pub get

# Ejecutar la aplicación
flutter run
```

## Requisitos

-   Flutter SDK
-   Dart SDK
