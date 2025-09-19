# Glosario Unidad 1 - Programación de Servicios y Procesos

## Conceptos básicos

### 🔄 Cambio de contexto
Mecanismo que permite la ejecución de un nuevo proceso en la memoria, e incluye la salvaguarda previa del estado de ejecución del proceso activo.

### 🧵 Hilo (thread)
Unidad de ejecución para un proceso existente, cuya creación no implica la reserva de memoria adicional, ya que comparte la existente del proceso.

### 🖥️ Kernel o núcleo del sistema operativo
Parte central del sistema operativo que gestiona las interrupciones y se encarga de la planificación de procesos a corto plazo.

### 🔀 Multiprogramación
Ejecución concurrente de varios procesos en un sistema monoprocesador. El procesador se asigna a otro proceso cuando el actual realiza operaciones de entrada/salida, maximizando así su aprovechamiento.

### 🖥️ Multitarea
Ejecución de más de un programa por un único procesador, realizando cambios de contexto para alternar su ejecución a lo largo del tiempo.

### 📋 Planificación a corto plazo
Parte del kernel encargada de decidir qué proceso se ejecuta a continuación, invocada en respuesta a interrupciones (CPU scheduling).

### ⚙️ Proceso
Programa que se ha cargado en memoria y está en ejecución.

### 💻 Programa
Conjunto de instrucciones y datos para una máquina específica, que puede ejecutarse en un procesador una vez cargado en memoria.

---

## Conceptos adicionales

### 🌐 Servicio en red
Servicio que se presta a procesos remotos mediante protocolos estándar de red.

### 🛠️ Servicio
Proceso con el que no interactúa directamente el usuario, sino otros procesos, a los que proporciona servicios.

### 🖧 Sistema distribuido
Sistema multiprocesador en el que los procesadores están en ordenadores autónomos y se comunican entre sí a través de una red.

### 🖲️ Sistema monoprocesador
Sistema que dispone de un único procesador.

### 🖥️🖥️ Sistema multiprocesador
Sistema que dispone de más de un procesador.
