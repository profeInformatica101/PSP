# 🐧 Comandos Linux para Evaluar RA1 (Programación multiproceso)

Este documento contiene ejemplos de **comandos Linux** que permiten evaluar los criterios de evaluación del **RA1** del módulo *Programación de servicios y procesos (0490)*.

---

## 🔹 CE a) Reconocer características de la programación concurrente
```bash
# Ver todos los procesos que se ejecutan simultáneamente
ps aux | head

# Medir tiempos de ejecución secuencial vs. concurrente
time (sleep 2; sleep 2)       # secuencial (≈4s)
time (sleep 2 & sleep 2; wait) # concurrente (≈2s)
```

---

## 🔹 CE b) Diferencias entre programación paralela y distribuida
```bash
# Paralelo: usar varios cores con 'yes' en background
yes > /dev/null &
yes > /dev/null &
jobs

# Distribuido: ejecutar en otra máquina mediante ssh
ssh usuario@servidor "hostname && date"
```

---

## 🔹 CE c) Analizar procesos y ejecución por el sistema operativo
```bash
# Ver PID, PPID y estado
ps -eo pid,ppid,cmd,stat | head

# Mostrar info completa de un proceso
top -p <PID>
```

---

## 🔹 CE d) Caracterizar hilos y su relación con procesos
```bash
# Ver hilos de un proceso
ps -Lp <PID>

# O con htop (F2 > Columns > Threads)
htop
```

---

## 🔹 CE e) Crear subprocesos
```bash
# Lanzar subproceso
echo "Hola desde subproceso" | cat
```

---

## 🔹 CE f) Compartir información con subprocesos
```bash
# Enviar datos a proceso 'bc' (calculadora)
echo "2+3" | bc
```

---

## 🔹 CE g) Sincronizar y obtener valores de subprocesos
```bash
# Esperar finalización de procesos en background
(sleep 3; echo "terminé") &
wait
echo "Todos los subprocesos finalizados"
```

---

## 🔹 CE h) Gestionar procesos en paralelo
```bash
# Ejecutar dos procesos simultáneos
(sleep 2; echo "Proc1 ok") &
(sleep 2; echo "Proc2 ok") &
wait
```

---

## 🔹 CE i) Depurar y documentar aplicaciones desarrolladas
```bash
# Ver logs en tiempo real
tail -f /var/log/syslog

# Redirigir salida estándar y error a fichero de log
ls /inexistente > salida.log 2>&1
```

---

# ✅ Resumen
- `ps`, `top`, `htop` → gestión de procesos e hilos.  
- `&`, `wait`, `jobs` → control de concurrencia.  
- `ssh` → distribución en red.  
- `tail`, redirecciones (`>`, `2>&1`) → depuración.  
